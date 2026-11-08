"""Show music videos at their own aspect ratio instead of stretched to the screen.

Spotify's video view has four scale modes (ASPECT_FIT, ASPECT_FILL, ASPECT_FILL_DISPLAY_AR,
STRETCH) and the TV app picks ASPECT_FILL. With a TextureView that mode crops through a transform
matrix, but with a SurfaceView (what TVs get) the view lays the SurfaceView out at the full
container size, so a 1590x1080 video is drawn into 1920x1080: stretched 1.2x. Two edits:

1. Every place outside the view that picks ASPECT_FILL picks ASPECT_FIT instead: the SurfaceView
   is sized to the video's aspect and centred, with black bars where the shapes differ.
2. The video size Spotify gives the view is the decoded width and height; it ignores Media3's
   pixel aspect ratio. The width becomes `round(width * pixelWidthHeightRatio)`, so anamorphic
   streams come out right too.

Sites are found by code shape: the scale-mode enum by its names, the view by its
"Invalid combination: " error, Media3's VideoSize by its (int, int, float) layout.
"""
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
files = {f: f.read_text() for f in root.glob('smali*/**/*.smali')}


def one(found, what):
    if len(found) != 1:
        sys.exit(f'Invariant failed: expected one {what}, found {len(found)}')
    return found[0]


def cls(src):
    return re.search(r'^\.class .*?(L[\w$/]+;)$', src, re.M).group(1)


# The scale-mode enum and its ASPECT_FIT / ASPECT_FILL fields.
enum_file = one([f for f, s in files.items()
                 if all(f'"{n}"' in s for n in ('ASPECT_FIT', 'ASPECT_FILL', 'STRETCH'))],
                'scale-mode enum')
enum_src = files[enum_file]
enum = cls(enum_src)


def enum_field(name):
    m = re.search(rf'const-string v\d+, "{name}"[\s\S]*?sput-object v\d+, {re.escape(enum)}->(\w+):', enum_src)
    return m.group(1)


fit, fill = enum_field('ASPECT_FIT'), enum_field('ASPECT_FILL')

# The video view: compares its mode against ASPECT_FILL, so it is left alone.
view_file = one([f for f, s in files.items() if '"Invalid combination: "' in s and enum in s], 'video view')
view = cls(files[view_file])

fill_ref = f'{enum}->{fill}:{enum}'
fill_sites = []
for f, s in files.items():
    if f in (enum_file, view_file) or fill_ref not in s:
        continue
    files[f] = s.replace(fill_ref, f'{enum}->{fit}:{enum}')
    fill_sites.append((f.relative_to(root), s.count(fill_ref)))
if not fill_sites:
    sys.exit('Invariant failed: no code outside the view picks ASPECT_FILL')

# Media3's VideoSize: a:I width, b:I height, c:F pixelWidthHeightRatio, built by <init>(IIF)V.
vs_file = one([f for f, s in files.items()
               if re.search(r'^\.field public final a:I$', s, re.M)
               and re.search(r'^\.field public final b:I$', s, re.M)
               and re.search(r'^\.field public final c:F$', s, re.M)
               and '.method public constructor <init>(IIF)V' in s
               and re.search(r'invoke-static \{v\d+, v\d+\}, Ljava/lang/Integer;->toString\(II\)', s)],
              'Media3 VideoSize')
vs = cls(files[vs_file])

# Spotify's onVideoSizeChanged: takes a VideoSize, reads its width, writes the view's size.
listener = re.compile(
    rf'(\.method public final \w+\({re.escape(vs)}\)V\n    \.locals (\d+)\n[\s\S]*?\.end method)')
width_read = re.compile(rf'^    iget (p\d+), (p\d+), {re.escape(vs)}->a:I$', re.M)
hits = []
for f, s in files.items():
    if f == vs_file:
        continue
    for m in listener.finditer(s):
        body = m.group(1)
        if f'{view}->' not in body or 'iput' not in body:
            continue
        reads = width_read.findall(body)
        if len(reads) != 1 or int(m.group(2)) < 2:
            continue
        dst, size = reads[0]
        # v1 is free here: the method only uses v0 (height) and v1 (a new size object) later.
        if re.search(r'\bv1\b', body.split(f'{vs}->a:I')[0].split('.locals')[1]):
            continue
        new = width_read.sub(
            f'    iget v1, {size}, {vs}->c:F\n\n'
            f'    iget {dst}, {size}, {vs}->a:I\n\n'
            f'    int-to-float {dst}, {dst}\n\n'
            f'    mul-float/2addr {dst}, v1\n\n'
            f'    invoke-static {{{dst}}}, Ljava/lang/Math;->round(F)I\n\n'
            f'    move-result {dst}', body)
        hits.append((f, body, new))
listener_file, body, new = one(hits, 'video-size listener that feeds the view')
files[listener_file] = files[listener_file].replace(body, new)

for changed in {root / p for p, _ in fill_sites} | {listener_file}:
    changed.write_text(files[changed])
print(f'patched {", ".join(f"{p} ({n}x)" for p, n in fill_sites)}: ASPECT_FILL -> ASPECT_FIT')
print(f'patched {listener_file.relative_to(root)}: view width uses the pixel aspect ratio')
