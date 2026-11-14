# Frame logger (diagnostic)

Logs once a second what Media3's video renderer did with the decoder's output frames. It changes no
decision.

```text
FrameDiag: frames=24 late=3 late>30ms=1 avgEarlyMs=31 minEarlyMs=-41 droppedOut=1 droppedIn=0 inputDropEvents=0 windowMs=1012
```

| Field | Meaning |
|---|---|
| `frames` | output frames rendered, skipped or dropped in the window |
| `late`, `late>30ms` | frames released after their time; over 30 ms late Media3 drops them |
| `avgEarlyMs`, `minEarlyMs` | how early frames left the decoder against the audio clock (negative = late) |
| `droppedOut` | decoded frames Media3 dropped for being late |
| `droppedIn` | frames Media3 dropped before decoding (late input dropping, drop to keyframe) |

Healthy playback shows `avgEarlyMs` around 40 and no drops. A decoder that can't keep up shows
`avgEarlyMs` falling below -30 and `droppedOut` climbing, while the decoder's own
`MSTAR_VDEC_DBG Rate` stays near the frame rate.

- `FrameDiag.java`: the source. `FrameDiag.smali` is generated from it by `build-smali.sh`.
- `patch_frame-diag.py`: calls it from Media3's `updateVideoFrameProcessingOffsetCounters` and
  `updateDroppedBufferCounters`, found by code shape.

Build with `./repatch.sh <tv-ip> --diag` and read it with `adb logcat -s FrameDiag`.
