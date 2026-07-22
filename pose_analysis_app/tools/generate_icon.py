from PIL import Image, ImageDraw, ImageFont
import os

def create_icon():
    size = 1024
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    for y in range(size):
        for x in range(size):
            r = int(108 * (1 - y/size) + 0 * (y/size))
            g = int(99 * (1 - y/size) + 212 * (y/size))
            b = int(255 * (1 - y/size) + 170 * (y/size))
            draw.point((x, y), fill=(r, g, b, 255))
    
    cx, cy = size // 2, size // 2 - 40
    
    draw.ellipse([cx-220, cy-220, cx+220, cy+220], fill=(255, 255, 255, 30))
    
    lw = 18
    white = (255, 255, 255, 255)
    purple = (108, 99, 255, 255)
    
    head = (cx, cy - 180)
    neck = (cx, cy - 120)
    ls = (cx - 100, cy - 70)
    rs = (cx + 100, cy - 70)
    le = (cx - 170, cy + 30)
    re = (cx + 170, cy + 30)
    lw_ = (cx - 140, cy + 110)
    rw_ = (cx + 140, cy + 110)
    hip = (cx, cy + 30)
    lk = (cx - 80, cy + 160)
    rk = (cx + 80, cy + 160)
    la = (cx - 100, cy + 290)
    ra = (cx + 100, cy + 290)
    
    connections = [
        (head, neck), (neck, ls), (neck, rs),
        (ls, le), (rs, re), (le, lw_), (re, rw_),
        (neck, hip), (hip, lk), (hip, rk),
        (lk, la), (rk, ra),
    ]
    
    for p1, p2 in connections:
        draw.line([p1, p2], fill=white, width=lw)
    
    points = [head, neck, ls, rs, le, re, lw_, rw_, hip, lk, rk, la, ra]
    for p in points:
        draw.ellipse([p[0]-12, p[1]-12, p[0]+12, p[1]+12], fill=white)
        draw.ellipse([p[0]-8, p[1]-8, p[0]+8, p[1]+8], fill=purple)
    
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
