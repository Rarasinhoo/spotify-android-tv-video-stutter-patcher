"""Apply the TextureView fallback fix to a decoded (apktool) Spotify TV smali tree.

Spotify's video view can render through a SurfaceView or a TextureView; a player-config flag
(remotely enabled on TVs) picks SurfaceView. With a TextureView the decoder's output goes to a
SurfaceTexture (consumer usage 0x100), so the MStar decoder always takes its working DIP mode.
Cost: video frames are drawn by the app's UI thread, so menus over a playing video hitch briefly.

The patch site is found by code shape: in the player builder (identified by its error string),
the flag read right before `if (!surfaceManager.e || surfaceManager.f != flag)` becomes `false`.
"""
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
pattern = re.compile(
    r'iget-boolean (v\d+), v\d+, L[\w$/]+;->\w+:Z'
    r'(\n\n    iget-boolean v\d+, (v\d+), (L[\w$/]+;)->e:Z'
    r'\n\n    if-eqz v\d+, :\w+'
    r'\n\n    iget-boolean v\d+, \3, \4->f:Z)'
)

hits = []
for f in root.glob('smali*/**/*.smali'):
    src = f.read_text()
    if 'Either a VideoSurfaceView or a VideoSurfaceManager must be specified' not in src:
        continue
    new, n = pattern.subn(lambda m: f'const/4 {m.group(1)}, 0x0{m.group(2)}', src)
    if n:
        f.write_text(new)
        hits.append((f.relative_to(root), n))

if [n for _, n in hits] != [1]:
    sys.exit(f'Invariant failed: expected the SurfaceView flag read exactly once, found {hits}')
print(f'patched {hits[0][0]}: SurfaceView flag forced off')
