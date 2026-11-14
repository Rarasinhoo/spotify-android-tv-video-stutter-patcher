#!/bin/bash
# Regenerate FrameDiag*.smali from FrameDiag.java (only needed after editing the Java).
# Needs a JDK, Android build-tools (d8), an android.jar platform and apktool (for baksmali).
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
SDK=${ANDROID_HOME:-/opt/homebrew/share/android-commandlinetools}
BT=$(ls -d "$SDK"/build-tools/* | tail -1)
JAR=$(ls -d "$SDK"/platforms/android-*/android.jar | head -1)
W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
javac --release 8 -nowarn -cp "$JAR" -d "$W/classes" "$HERE/FrameDiag.java" 2>/dev/null
"$BT/d8" --min-api 21 --lib "$JAR" --output "$W" "$W"/classes/*.class
(cd "$W" && zip -q helper.apk classes.dex)
apktool d -r -f -o "$W/apk" "$W/helper.apk" >/dev/null
rm -f "$HERE"/FrameDiag*.smali
cp "$W"/apk/smali/FrameDiag*.smali "$HERE/"
ls "$HERE"/FrameDiag*.smali
