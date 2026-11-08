"""Apply the header-timing fix to a decoded (apktool) Spotify TV smali tree.

Spotify's H.264 headers declare a wrong-but-plausible frame rate (e.g. 1 / 3050). In hardware-render
mode the MStar decoder paces the video plane by it and stalls. HeaderTiming rewrites that timing to
an absurd value, so the decoder measures the real rate from timestamps. Two hooks in Media3's video
renderer:
  1. the decoder's MediaFormat (csd-0) right before the decoder is set up;
  2. every sample right before it is queued (onQueueInputBuffer), for headers repeated inside the
     video on quality switches.
Names are found by code shape, not by the obfuscated names; it fails loudly if a shape is not found.
"""
import pathlib, re, shutil, sys

root = pathlib.Path(sys.argv[1])
here = pathlib.Path(__file__).parent

def one(items, what):
    items = list(dict.fromkeys(items))
    if len(items) != 1:
        sys.exit(f"Invariant failed: expected one {what}, found {len(items)}: {items[:5]}")
    return items[0]

def methods(src):
    return re.findall(r'(\.method [^\n]*\n.*?\.end method)', src, re.S)

def smali_file(cls):
    rel = cls[1:-1] + '.smali'
    return one([p for d in root.glob('smali*') if (p := d / rel).exists()], f'file for {cls}')

renderer = one([f for f in root.glob('smali*/**/*.smali')
                if '"allow-frame-drop"' in (t := f.read_text()) and '"releaseOutputBuffer"' in t],
               'video renderer')
src = renderer.read_text()
cls = re.search(r'^\.class [^\n]*?(L[\w$/]+;)', src, re.M).group(1)
sup = re.search(r'^\.super (L[\w$/]+;)', src, re.M).group(1)
S = re.escape(sup)

# 1) setup: hand the MediaFormat to HeaderTiming right before the adapter configuration is built
config = one([m for m in methods(src) if '"allow-frame-drop"' in m], 'codec configuration method')
factory = one(re.findall(r'    invoke-static(/range)? \{([^}]*)\}, L[\w$/]+;->\w+\(L[\w$/]+;Landroid/media/MediaFormat;'
                         r'L[\w$/]+;Landroid/view/Surface;Landroid/media/MediaCrypto;\)L[\w$/]+;\n', config),
              'adapter configuration factory call')
if factory[0]:
    first = re.match(r'v(\d+) \.\. v\d+', factory[1]).group(1)
    fmt_reg = f'v{int(first) + 1}'
else:
    fmt_reg = [r.strip() for r in factory[1].split(',')][1]
call_line = one(re.findall(r'    invoke-static(?:/range)? \{' + re.escape(factory[1]) + r'\}, [^\n]*\n', config), 'factory line')
new_config = config.replace(call_line,
    f'    invoke-static {{{fmt_reg}}}, LHeaderTiming;->onFormat(Landroid/media/MediaFormat;)V\n\n' + call_line, 1)
src = src.replace(config, new_config, 1)

# 2) samples: find onQueueInputBuffer and the sample-data field from the base renderer's feed method
base = smali_file(sup).read_text()
feed = one([m for m in methods(base) if re.search(r'invoke-interface(?:/range)? \{[^}]*\}, L[\w$/]+;->\w+\(IL[\w$/]+;JI\)V', m)],
           'feedInputBuffer (queues secure input)')
q = one(re.findall(r'invoke-virtual \{(\w+), (\w+)\}, ' + S + r'->(\w+)\((L[\w$/]+;)\)V\s+'
                   r'invoke-virtual \{\1, \2\}, ' + S + r'->\w+\(\4\)I', feed), 'onQueueInputBuffer call')
on_queue, buf = q[2], q[3]
data = one(re.findall(re.escape(buf) + r'->(\w+):Ljava/nio/ByteBuffer;\s+invoke-static \{\w+\}, L[\w$/]+;->\w+\(Ljava/lang/Object;\)V'
                      r'\s+invoke-virtual \{\w+\}, Ljava/nio/Buffer;->limit\(\)I', feed), 'sample data field')

override = one([m for m in methods(src) if re.match(r'\.method [^\n]*\b' + on_queue + re.escape(f'({buf})V') + r'\n', m)],
               "video renderer's onQueueInputBuffer")
head = re.match(r'(\.method [^\n]*\n)(\s+\.locals )(\d+)\n', override)
if not head:
    sys.exit('Invariant failed: onQueueInputBuffer has no .locals line')
hook = (f'{head.group(1)}{head.group(2)}{max(1, int(head.group(3)))}\n\n'
        f'    iget-object v0, p1, {buf}->{data}:Ljava/nio/ByteBuffer;\n\n'
        f'    invoke-static {{v0}}, LHeaderTiming;->onSample(Ljava/nio/ByteBuffer;)V\n')
src = src.replace(override, hook + override[head.end():], 1)

if src.count('LHeaderTiming;') != 2:
    sys.exit('Invariant failed: renderer edits did not apply')
renderer.write_text(src)

dex_dirs = sorted(root.glob('smali_classes*'), key=lambda p: int(p.name.replace('smali_classes', '') or 0))
dest = dex_dirs[-1] if dex_dirs else root / 'smali'
for f in here.glob('HeaderTiming*.smali'):
    shutil.copy(f, dest / f.name)
print(f'patched {renderer.relative_to(root)}: {cls} format={fmt_reg} sample={on_queue}({buf}).{data}')
