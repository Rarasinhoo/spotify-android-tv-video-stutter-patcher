# Header-timing rewrite (experiment)

`VuiFix.fix(MediaFormat)` rewrites the H.264 VUI `num_units_in_tick` / `time_scale` in `csd-0` to
`1 / 2,000,000`. The MStar decoder rejects that as absurd, enters `FrameRate Guess Mode` and measures
the real rate from timestamps, so hardware-render mode paces correctly.

Used for the A/B proof (README, "Proved in Spotify itself"): called in Media3's video renderer right
after the `MediaFormat` is built. `adb shell setprop debug.vuifix 0` disables it at runtime.

Not a shipped fix: it only covers `csd-0`. On a quality switch that keeps the decoder, the new SPS
arrives inside the input buffers with the original timing and the stall comes back. A complete
version must rewrite SPS NAL units in every input buffer as well.
