"""Apply the placeholder-first fix to a decoded (apktool) Spotify TV smali tree.

Media3's video renderer configures each decoder directly on the on-screen SurfaceView when one
exists. TCL's MStar decoder then picks a broken hardware-render mode (ConsumerUsage 0x900).
This patch makes the renderer configure every decoder on Media3's placeholder surface
(a SurfaceTexture, ConsumerUsage 0x100 -> working DIP mode) and switch to the real surface
right before the first frame is rendered. Names are found by code shape, not by the obfuscated
names, so it should survive Spotify updates; it fails loudly if a shape is not found once.
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
cls = re.search(r'^\.class [^\n]*?(L[\w$/]+;)', src, re.M).group(1)
C = re.escape(cls)

config = one([m for m in methods(src) if '"allow-frame-drop"' in m], 'codec configuration method')
call = re.search(r'invoke-virtual(?:/range)? \{p0(?: \.\.|,) p1\}, ' + C + r'->(\w+)\((L[\w$/]+;)\)Landroid/view/Surface;', config)
if not call:
    sys.exit('Invariant failed: surface lookup call not found in codec configuration')
r0, ci = call.group(1), call.group(2)

r0_body = one([m for m in methods(src) if re.match(r'\.method public final ' + r0 + re.escape(f'({ci})Landroid/view/Surface;'), m)], 'surface lookup method')
sink_field, sink_type = re.search(r'iget-object v0, p0, ' + C + r'->(\w+):(L[\w$/]+;)', r0_body).groups()
surf_field = re.search(r'iget-object v0, p0, ' + C + r'->(\w+):Landroid/view/Surface;', r0_body).group(1)
y0 = one(re.findall(r'invoke-virtual \{p0, p1\}, ' + C + r'->(\w+)\(' + re.escape(ci) + r'\)Z', r0_body), 'placeholder-allowed check')

render = one([m for m in methods(src) if '"releaseOutputBuffer"' in m and re.search(r'invoke-interface \{p1, p2, p3, p4\}, L[\w$/]+;->\w+\(IJ\)V', m)], 'render method')
adapter, release = re.search(r'invoke-interface \{p1, p2, p3, p4\}, (L[\w$/]+;)->(\w+)\(IJ\)V', render).groups()
adapter_file = one([f for f in root.glob('smali*/**/*.smali') if re.search(r'^\.class [^\n]*' + re.escape(adapter), f.read_text(), re.M)], 'codec adapter interface')
set_surface = one(re.findall(r'\.method public abstract (\w+)\(Landroid/view/Surface;\)V', adapter_file.read_text()), 'setOutputSurface')

# 1) pending flag field
src = src.replace(f'.field public {surf_field}:Landroid/view/Surface;\n',
                  f'.field public {surf_field}:Landroid/view/Surface;\n\n.field public phPending:Z\n', 1)
# 2) configuration uses the helper
new_config = config.replace(call.group(0),
    f'invoke-static/range {{p0 .. p1}}, LPlaceholderFirst;->codecSurface({cls}{ci})Landroid/view/Surface;', 1)
src = src.replace(config, new_config, 1)
# 3) switch to the real surface before the first rendered frame
old_call = f'    invoke-interface {{p1, p2, p3, p4}}, {adapter}->{release}(IJ)V'
new_render = render.replace(old_call,
    f'    invoke-static/range {{p0 .. p1}}, LPlaceholderFirst;->beforeRender({cls}{adapter})V\n\n' + old_call, 1)
src = src.replace(render, new_render, 1)
# 4) when Media3 itself moves the decoder to a new surface, drop the pending switch
own_switch = re.findall(r'    invoke-interface \{(v\d+), (v\d+)\}, ' + re.escape(adapter) + r'->' + set_surface + r'\(Landroid/view/Surface;\)V\n', src)
own_switch = one(own_switch, "renderer's own setOutputSurface call")
site = f'    invoke-interface {{{own_switch[0]}, {own_switch[1]}}}, {adapter}->{set_surface}(Landroid/view/Surface;)V\n'
src = src.replace(site, site + f'\n    invoke-static/range {{p0 .. p0}}, LPlaceholderFirst;->surfaceMoved({cls})V\n', 1)
if 'phPending' not in src or src.count('LPlaceholderFirst;') != 3:
    sys.exit('Invariant failed: renderer edits did not apply')
renderer.write_text(src)

helper = pathlib.Path(__file__).with_name('PlaceholderFirst.smali.tmpl').read_text()
for k, v in {'CLS': cls, 'CI': ci, 'R0': r0, 'Y0': y0, 'SURF': surf_field, 'SINK': sink_field,
             'SINKT': sink_type, 'ADP': adapter, 'SETSURF': set_surface}.items():
    helper = helper.replace('@' + k + '@', v)
dex_dirs = sorted(root.glob('smali_classes*'), key=lambda p: int(p.name.replace('smali_classes', '') or 0))
(dex_dirs[-1] if dex_dirs else root / 'smali').joinpath('PlaceholderFirst.smali').write_text(helper)
print(f'patched {renderer.relative_to(root)}: {cls} config={r0} render={release} setSurface={set_surface}')
