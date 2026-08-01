from PIL import Image, ImageDraw, ImageFont
import os

def create_icon():
    size = 1024
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    cx, cy = size // 2, size // 2
    r = size // 2

    for y in range(size):
        for x in range(size):
            dx = x - cx
            dy = y - cy
            dist = (dx*dx + dy*dy) ** 0.5
            if dist <= r:
                t = y / size
                c1 = (108, 63, 255)
                c2 = (0, 150, 255)
                red = int(c1[0] * (1 - t) + c2[0] * t)
                green = int(c1[1] * (1 - t) + c2[1] * t)
                blue = int(c1[2] * (1 - t) + c2[2] * t)
                draw.point((x, y), fill=(red, green, blue, 255))

    white = (255, 255, 255, 255)
    bar_w = 280
    bar_h = 56
    bx = cx - bar_w // 2
    by = cy - bar_h // 2

    draw.rounded_rectangle(
        [bx, by, bx + bar_w, by + bar_h],
        radius=bar_h // 2,
        fill=white,
    )

    plate_configs = [
        (70, 220, 0),
        (55, 180, 0),
        (42, 140, 0),
    ]

    for side in [-1, 1]:
        base_x = cx + side * (bar_w // 2 + 10)
        for i, (pw, ph, _) in enumerate(plate_configs):
            px = base_x + side * (sum(p[0] for p in plate_configs[:i]) + i * 8) * side
            if side == 1:
                px = base_x + sum(p[0] for p in plate_configs[:i]) + i * 8
            else:
                px = base_x - sum(p[0] for p in plate_configs[:i]) - i * 8 - pw

            py = cy - ph // 2
            draw.rounded_rectangle(
                [px, py, px + pw, py + ph],
                radius=8,
                fill=white,
            )

    grip_lines = [-50, -25, 0, 25, 50]
    for gx in grip_lines:
        draw.line(
            [cx + gx, by + 8, cx + gx, by + bar_h - 8],
            fill=(200, 200, 255, 120),
            width=4,
        )

    output = 'assets/icon/app_icon.png'
    os.makedirs(os.path.dirname(output), exist_ok=True)
    img.save(output, 'PNG')

    res_dir = 'android/app/src/main/res'
    sizes = {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192,
    }

    for folder, sz in sizes.items():
        path = os.path.join(res_dir, folder)
        if os.path.exists(path):
            resized = img.resize((sz, sz), Image.LANCZOS)
            resized.save(os.path.join(path, 'ic_launcher.png'), 'PNG')
            resized.save(os.path.join(path, 'ic_launcher_round.png'), 'PNG')

    print(f'Icon generated: {output} (1024x1024)')

if __name__ == '__main__':
    create_icon()
