#!/usr/bin/env python3
"""Build The Desk launcher icons from assets/images/app_icon.png.

iOS, legacy Android, and web icons are full-bleed. Android 8+ masks a 108dp
adaptive icon and only guarantees the center 72dp, which would clip the brass
plate if the artwork filled the whole canvas. The adaptive foreground keeps
the full artwork inside that 72dp square, on a paper-colored background.
"""

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets/images/app_icon.png"

# Android adaptive icon: 108dp canvas, 18dp bleed on each side.
ADAPTIVE_SCALE = 72 / 108
FOREGROUND_PX = {
    "mipmap-mdpi": 108,
    "mipmap-hdpi": 162,
    "mipmap-xhdpi": 216,
    "mipmap-xxhdpi": 324,
    "mipmap-xxxhdpi": 432,
}


def paper_color(image: Image.Image) -> tuple[int, int, int]:
    px = image.load()
    w, h = image.size
    samples = []
    for i in range(0, w, 8):
        samples.append(px[i, 4])
        samples.append(px[i, h - 5])
        samples.append(px[4, min(i, h - 1)])
        samples.append(px[w - 5, min(i, h - 1)])
    count = len(samples)
    return (
        sum(c[0] for c in samples) // count,
        sum(c[1] for c in samples) // count,
        sum(c[2] for c in samples) // count,
    )


def foreground(source: Image.Image, size: int) -> Image.Image:
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    inner = round(size * ADAPTIVE_SCALE)
    art = source.resize((inner, inner), Image.Resampling.LANCZOS).convert("RGBA")
    offset = (size - inner) // 2
    canvas.paste(art, (offset, offset), art)
    return canvas


def main() -> None:
    source = Image.open(SOURCE).convert("RGB")
    paper = paper_color(source)
    res = ROOT / "android/app/src/main/res"
    for bucket, size in FOREGROUND_PX.items():
        out = res / bucket / "ic_launcher_foreground.png"
        out.parent.mkdir(parents=True, exist_ok=True)
        foreground(source, size).save(out, format="PNG", optimize=True)

    hex_color = "#%02X%02X%02X" % paper
    (res / "values").mkdir(parents=True, exist_ok=True)
    (res / "values/colors.xml").write_text(
        """<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">%s</color>
</resources>
"""
        % hex_color
    )
    adaptive = res / "mipmap-anydpi-v26"
    adaptive.mkdir(parents=True, exist_ok=True)
    (adaptive / "ic_launcher.xml").write_text(
        """<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
"""
    )
    print(f"adaptive foregrounds written, background {hex_color}")


if __name__ == "__main__":
    main()
