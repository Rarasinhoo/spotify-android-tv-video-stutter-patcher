#!/bin/bash
# Patch the Spotify Android TV app installed on your TV so music videos play on MStar/MediaTek TVs.
#
#   ./repatch.sh <tv-ip>[:port]                 header frame rate fixed at 60 fps (recommended)
#   ./repatch.sh <tv-ip>[:port] --placeholder   fallback fix (DIP mode, slower in heavy scenes)
#   ./repatch.sh <tv-ip>[:port] --textureview   last-resort fix
#   ./repatch.sh <tv-ip>[:port] --dry-run       build only, change nothing on the TV
#   add --aspect to stop non-16:9 videos being stretched (docs/ASPECT.md)
#   add --diag to log Media3's late and dropped frames (adb logcat -s FrameDiag)
#
# Steps: pull the official Spotify from the TV, verify it is Spotify's signed build, keep a copy
# in ./local/original-<version>/, patch it, sign it with your local key, uninstall the official app
# and install the patched one. If a build signed with your key is already installed, the kept
# official copy is patched instead and installed over it, so you stay logged in.
# Signing key: ./local/patch.keystore (created on first run), or set KEYSTORE and KEYSTORE_PASS.
set -euo pipefail

usage() { sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }
[ $# -ge 1 ] || usage
TV=$1; shift
[[ $TV == *:* ]] || TV="$TV:5555"
MODE=header-timing; DRY=0; ASPECT=0; DIAG=0
for a in "$@"; do case $a in
  --textureview) MODE=textureview ;;
  --placeholder) MODE=placeholder ;;
  --header-timing) MODE=header-timing ;;
  --dry-run) DRY=1 ;;
  --aspect) ASPECT=1 ;;
  --diag) DIAG=1 ;;
  *) usage ;;
esac; done

HERE=$(cd "$(dirname "$0")" && pwd)
SPOTIFY_CERT_SHA256=fd450f5f94b9dba0ae7f6b19e0b512e041ea7fc2cc291b71737b319ba7f4b3d4

for tool in adb apktool java python3; do
  command -v $tool >/dev/null || { echo "Missing $tool. See 'Requirements' in README.md."; exit 1; }
done
BT=$(ls -d "${ANDROID_HOME:-/opt/homebrew/share/android-commandlinetools}"/build-tools/* 2>/dev/null | tail -1)
[ -x "$BT/apksigner" ] || { echo "Android build-tools (apksigner, zipalign) not found. Set ANDROID_HOME."; exit 1; }

KEYSTORE=${KEYSTORE:-$HERE/local/patch.keystore}
if [ ! -f "$KEYSTORE" ]; then
  mkdir -p "$(dirname "$KEYSTORE")"
  KEYSTORE_PASS=${KEYSTORE_PASS:-$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 24)}
  keytool -genkeypair -keystore "$KEYSTORE" -alias patch -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass "$KEYSTORE_PASS" -keypass "$KEYSTORE_PASS" -dname "CN=Local Spotify TV patch" >/dev/null 2>&1
  printf '%s' "$KEYSTORE_PASS" > "$KEYSTORE.pass"
  echo "Created signing key $KEYSTORE (keep it: updates must be signed with the same key)"
fi
KEYSTORE_PASS=${KEYSTORE_PASS:-$(cat "$KEYSTORE.pass")}

W=$(mktemp -d)
trap 'rm -rf "$W"' EXIT
A="adb -s $TV"
adb connect "$TV" >/dev/null
VER=$($A shell dumpsys package com.spotify.tv.android | tr -d '\r' | grep -m1 versionName | cut -d= -f2 || true)
[ -n "$VER" ] || { echo "Spotify is not installed on $TV. Install it from the Play Store first."; exit 1; }
echo "Spotify $VER on $TV"

mkdir -p "$W/orig"
for p in $($A shell pm path com.spotify.tv.android | tr -d '\r' | sed 's/package://'); do
  $A pull "$p" "$W/orig/" >/dev/null 2>&1
done
cert() { "$BT/apksigner" verify --print-certs "$1" | grep -m1 'SHA-256' | awk '{print $NF}'; }
KEEP="$HERE/local/original-$VER"
CERT=$(cert "$W/orig/base.apk")
UPDATE=0
if [ "$CERT" = "$SPOTIFY_CERT_SHA256" ]; then
  mkdir -p "$KEEP"; cp "$W"/orig/*.apk "$KEEP/"
else
  OURS=$(keytool -list -v -keystore "$KEYSTORE" -storepass "$KEYSTORE_PASS" 2>/dev/null \
    | grep -m1 -iE 'SHA.?256' | sed 's/.*: //; s/://g' | tr 'A-F' 'a-f')
  if [ "$CERT" = "$OURS" ] && [ -f "$KEEP/base.apk" ] && [ "$(cert "$KEEP/base.apk")" = "$SPOTIFY_CERT_SHA256" ]; then
    echo "A build signed with your key is installed: patching the kept official $VER instead"
    rm -f "$W"/orig/*.apk; cp "$KEEP"/*.apk "$W/orig/"; UPDATE=1
  else
    echo "The installed Spotify is not Spotify's official build (signer $CERT)."
    echo "Uninstall it and install Spotify from the Play Store, then run this again."
    exit 1
  fi
fi

apktool d -r -f -o "$W/src" "$W/orig/base.apk" >/dev/null
python3 -I "$HERE/patches/$MODE/patch_$MODE.py" "$W/src"
if [ $ASPECT = 1 ]; then python3 -I "$HERE/patches/aspect/patch_aspect.py" "$W/src"; fi
if [ $DIAG = 1 ]; then python3 -I "$HERE/patches/frame-diag/patch_frame-diag.py" "$W/src"; fi
apktool b -o "$W/base-unsigned.apk" "$W/src" >/dev/null

mkdir -p "$W/out"
"$BT/zipalign" -f -p 4 "$W/base-unsigned.apk" "$W/a-base.apk"
for s in "$W"/orig/split_*.apk; do "$BT/zipalign" -f -p 4 "$s" "$W/a-$(basename "$s")"; done
for f in "$W"/a-*.apk; do
  n=$(basename "$f")
  "$BT/apksigner" sign --ks "$KEYSTORE" --ks-pass "pass:$KEYSTORE_PASS" --out "$W/out/${n#a-}" "$f"
done
rm -f "$W"/out/*.idsig

SUFFIX=""; if [ $ASPECT = 1 ]; then SUFFIX=-aspect; fi; if [ $DIAG = 1 ]; then SUFFIX=$SUFFIX-diag; fi
DEST="$HERE/local/$MODE$SUFFIX-$VER"
mkdir -p "$DEST"
cp "$W"/out/*.apk "$DEST/"
echo "Built $DEST"
[ $DRY = 1 ] && exit 0

if [ $UPDATE = 1 ]; then
  $A install-multiple -r "$DEST"/*.apk
  echo "Updated patched Spotify $VER ($MODE$SUFFIX). Your login is kept."
else
  $A uninstall com.spotify.tv.android >/dev/null
  $A install-multiple "$DEST"/*.apk
  echo "Installed patched Spotify $VER ($MODE$SUFFIX). Open Spotify on the TV and log in."
fi
