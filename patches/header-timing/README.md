# Header-timing patch

- `HeaderTiming.java`: the source. It runs inside Spotify (no Android-only APIs beyond `Log` and `MediaFormat`).
- `HeaderTiming*.smali`: generated from it by `build-smali.sh`; `repatch.sh` drops these into the app.
- `patch_header-timing.py`: adds the two calls to Media3's video renderer, found by code shape.

After editing the Java, run `./build-smali.sh` and commit the regenerated smali with it.
