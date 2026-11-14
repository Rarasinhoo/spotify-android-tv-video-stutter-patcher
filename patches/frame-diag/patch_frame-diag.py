"""Add the FrameDiag logger to Media3's video renderer in a decoded (apktool) Spotify TV smali tree.

Diagnostic only, applied on top of a fix (repatch.sh --diag). It finds, by code shape:
- updateVideoFrameProcessingOffsetCounters(J)V: adds to DecoderCounters' long and int (offset sum
  and count), then to the renderer's own long and int;
- updateDroppedBufferCounters(II)V: the only (II)V on the renderer that calls Math.max(II).
and calls FrameDiag at the start of each.
"""
import pathlib, re, sys

root = pathlib.Path(sys.argv[1])

def one(items, what):
    items = list(dict.fromkeys(items))
    if len(items) != 1:
        sys.exit(f"Invariant failed: expected one {what}, found {len(items)}: {items[:5]}")
    return items[0]

def methods(src):
    return re.findall(r'(\.method [^\n]*\n.*?\.end method)', src, re.S)

renderer = one([f for f in root.glob('smali*/**/*.smali')
                if '"allow-frame-drop"' in (t := f.read_text()) and '"releaseOutputBuffer"' in t],
               'video renderer')
src = renderer.read_text()

offset = one([m for m in methods(src)
              if re.match(r'\.method public final \w+\(J\)V', m)
              and len(re.findall(r'add-long/2addr', m)) == 2
              and len(re.findall(r'add-int/lit8 \w+, \w+, 0x1', m)) == 2
              and 'invoke-' not in m], 'processing-offset counter method')
dropped = one([m for m in methods(src)
               if re.match(r'\.method public final \w+\(II\)V', m)
               and 'Ljava/lang/Math;->max(II)I' in m], 'dropped-buffer counter method')

def hook(body, call):
    first = re.search(r'(\.locals \d+\n)', body)
    if not first:
        sys.exit('Invariant failed: no .locals line')
    return body.replace(first.group(1), first.group(1) + f'\n    {call}\n', 1)

src = src.replace(offset, hook(offset, 'invoke-static {p1, p2}, LFrameDiag;->offset(J)V'), 1)
src = src.replace(dropped, hook(dropped, 'invoke-static {p1, p2}, LFrameDiag;->dropped(II)V'), 1)
if src.count('LFrameDiag;') != 2:
    sys.exit('Invariant failed: renderer edits did not apply')
renderer.write_text(src)

dex_dirs = sorted(root.glob('smali_classes*'), key=lambda p: int(p.name.replace('smali_classes', '') or 0))
here = pathlib.Path(__file__).parent
(dex_dirs[-1] if dex_dirs else root / 'smali').joinpath('FrameDiag.smali').write_text(
    here.joinpath('FrameDiag.smali').read_text())
print(f'frame-diag: hooked {renderer.relative_to(root)}')
