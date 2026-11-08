# Investigation log

How the cause was found on a TCL 55C825 (MT5889, firmware V620) with Spotify TV 9.1.94, using only
`adb` over the network (no root).

## 1. Reproduce and capture

- Connected with `adb connect <tv-ip>:5555` (Network debugging on).
- Captured `logcat` and `dumpsys SurfaceFlinger` while a video was smooth, then again after
  skipping to the next one.
- Repro rule, confirmed many times:
  - switching while a video is playing → broken
  - going back to the menu first → fine
  - first video after app start → fine

## 2. Red herrings

| Suspect | Evidence | Verdict |
|---|---|---|
| 60↔50 Hz display switching | Spotify's `setFrameRate(25)` flips the panel mode. Locking 60 Hz removed the flips | Side effect, not the cause |
| Wi-Fi / CDN | RSSI −41 dBm, 1201 Mbps link. During a stall the player wasn't even requesting data | Not the cause |
| CPU / memory | Load average ~68, but mostly kernel tasks in D-state. Spotify's CPU use was normal | Not the cause |
| Decoder resets | `forceP` lines in the log turned out to be per-frame messages | Misread |

## 3. The decisive difference

The MStar OMX component prints the surface's consumer usage when it sets up its buffers. Every
good start logged `ConsumerUsage: 100, Hardware Render: 0` and every bad start
`ConsumerUsage: 900, Hardware Render: 1`, with these consequences:

| | Good (`0x100`) | Bad (`0x900`) |
|---|---|---|
| Mode | DIP detile + MFDEC, "SW render", NV12 | "Hardware render", GRM display buffer (`db:0`) |
| Buffers | 1920×1088 YUV, usage `0x2400930` | 1.8 KiB metadata handles, usage `0x42000900` |
| SurfaceFlinger | composes the YUV layer | Mali allocates 9 `detiled_native_buffer`s and de-tiles every frame |
| `MSTAR_VDEC_DBG Rate` | 23–25 | 0–3 |
| ExoPlayer | `READY` | flips `READY`↔`BUFFERING` ~3×/s, AudioTrack restarted ~5×/s |

## 4. Levers checked without root

- `strings libOMX.MStar.so`: about 60 properties, all `vendor.mstar.*` / `vendor.mtk.*`, labelled
  `vendor_mstar_*_prop` / `vendor_mtk_*_prop` in `vendor_property_contexts`. `setprop` from shell
  fails for every one. The only per-app code is a special case for `com.netflix.ninja`.
- `hwcomposer.mt5889.so`, `gralloc.default.so`, `mstar.hardware.mmdisp`: no shell-settable
  property that touches this path.
- `debug.stagefright.omx_default_rank` is settable, but the codec list is built when the media
  server starts, and restarting it needs root.
- `service call SurfaceFlinger 1008` (disable HW overlays): permission denied. The Developer
  options toggle ran but changed nothing.

## 5. Inside the Spotify app

Decompiled with `jadx`:
- The video player is Spotify's "Betamax" on AndroidX Media3 1.11.0, with a player pool
  (`BetamaxPlayerPool.*`) and a surface manager (`BetamaxPlayer.ReleaseSurfaceManager`).
- The video view inflates either `video_surface_view_surface` (`SurfaceView`) or
  `video_surface_view_texture` (`TextureView`), chosen by a boolean in the player configuration.
  It defaults to `false`; something (most likely remote config) turns it on for TVs.
- Media3's `MediaCodecVideoRenderer` gets the surface for a new decoder from a method that
  returns the display surface if there is one, else the placeholder surface
  (`ExoPlayer:PlaceholderSurface`, a `SurfaceTexture`).

## 6. Experiments with patched builds

| Build | Result |
|---|---|
| TextureView forced | All starts `0x100`, smooth. Brief hitch when a menu opens over video |
| Fresh `SurfaceView` swapped in per playback session | The swap ran, the next decoder still got `0x900` |
| **Decoder set up on the placeholder, moved to the `SurfaceView` before its first frame** | **All starts `0x100`, smooth, menus smooth** |

The fresh-surface failure is what pinned the real condition. What matters isn't whether the
surface already shows video. It's whether the decoder is set up directly on an on-screen surface
at all. A new `SurfaceView`'s surface is created within milliseconds, long before the decoder
is set up.

## 7. Cross-check with Google's Media3 demo app

To see whether the bug lives in Media3 itself, Google's demo app (Media3 1.12.0-alpha02, built from
`main`) was run on the same TV. Every new decoder took `ConsumerUsage: 900, Hardware Render: 1`,
and both the video layer and the app window were composited by the display hardware (`DEVICE`):

| Test | Decode rate |
|---|---|
| 720p H.264 → HEVC → H.264 playlist (new decoder while video is on screen) | 29–31 fps |
| 25 fps HEVC, display switching 60 → 50 Hz | 24–25 fps |
| 1080p60 H.264 DASH, new decoder while video is on screen | 58–62 fps |

A capture of the unpatched Spotify in the broken state showed the same `DEVICE` composition. The
decoder still dropped to 0–3 fps, starting about 2 s after it started, around the time the display
switched to 50 Hz. Hardware-render mode was therefore only harmful together with something specific
to Spotify; section 8 shows what.

## 8. The trigger: a wrong frame rate in the stream header

Ruled out first, each with a modified demo build (all smooth):
- 1080p 25 fps with audio;
- 60↔50 Hz refresh switches timed 0.6–1.0 s after the decoder starts;
- a first decoder on the placeholder followed by hardware-render decoders on the same layer;
- a brand-new `SurfaceView` for every new decoder;
- 16 reference frames and 8 B-frames.

A Spotify build instrumented with per-frame logs showed:
- In the broken state the player only receives 1–2 decoded frames a second and shows each one
  immediately. The decoder is starving, not the player.
- Each broken start produced the identical frame counter sequence 8, 16, 22, 25, 29, 30.
- Spotify decrypts its streams in the app and queues clear data to the decoder.
- The `MediaFormat` has no `frame-rate` key, so the decoder logs `Demuxer Frame Rate = 0 0`.

The decoder's own frame-rate decision separated good from broken starts:

| Spotify hardware-render start | Header timing | Decoder | Result |
|---|---|---|---|
| 00:30:01, 00:46:10 | 1 / 2,000,000 | `Enter FrameRate Guess Mode`, `in = 24000` | smooth |
| 23:51:51, 00:20:17, 00:30:44 | plausible wrong value | no guess mode, `in = 1000, out = 0` | stall |

Repro in the demo app (Media3 1.11.0): a 25 fps clip with its header rewritten to Spotify's
`1 / 3050` (`ffmpeg -bsf:v h264_metadata=tick_rate=3050/1`):
- with the frame rate left out of the `MediaFormat`: `in = 4000, out = 4000`, 5–11 fps;
- with it passed (stock demo): `Demuxer Frame Rate = 25000`, 24–25 fps.

So the stall needs all four together:
1. a wrong-but-plausible header frame rate;
2. no frame rate from the app;
3. the MStar decoder trusting the header;
4. hardware-render mode, the only mode that paces output by that rate.
