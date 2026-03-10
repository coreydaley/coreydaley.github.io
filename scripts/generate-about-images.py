#!/usr/bin/env python3
"""
Generate illustration images for the About page sections.

Generates one square DALL-E 3 image per section, downloads the PNG to
static/images/about/, converts to WebP via cwebp, and prints the
shortcode snippet to insert into about.md.

Requirements:
  pip install openai requests

Environment:
  OPENAI_API_KEY — OpenAI API key (for DALL-E 3)

Usage:
  python3 scripts/generate-about-images.py
"""

import base64
import os
import subprocess
import sys
from pathlib import Path

_VENV_PYTHON = Path(__file__).parent.parent / ".venv" / "bin" / "python3"
if _VENV_PYTHON.exists() and Path(sys.executable).resolve() != _VENV_PYTHON.resolve():
    os.execv(str(_VENV_PYTHON), [str(_VENV_PYTHON)] + sys.argv)

try:
    import anthropic
    import openai
    import requests
except ImportError as e:
    print(f"Error: missing dependency — {e}")
    sys.exit(1)

REPO_ROOT = Path(__file__).parent.parent
OUT_DIR = REPO_ROOT / "static" / "images" / "about"

IMAGE_STYLE = (
    "Flat vector illustration. Dark navy or charcoal background. "
    "Electric blue and warm amber as primary accent colors. "
    "Clean lines, minimal detail, no photorealism. "
    "No text, letters, words, or numbers anywhere in the image. "
    "Modern SaaS marketing illustration aesthetic, similar to Stripe or Linear. "
    "Square 1:1 format."
)

SECTIONS = [
    {
        "slug": "what-i-do",
        "concept": (
            "A cartoon developer sitting at a glowing workstation surrounded by "
            "multiple floating chat windows and AI agent panels. Code streams on "
            "the monitors. The developer and the AI panels are collaborating, "
            "passing glowing ideas back and forth."
        ),
    },
    {
        "slug": "why-this-blog-exists",
        "concept": (
            "A cartoon person writing at a desk, illuminated by a warm lamp. "
            "Above them, a thought bubble splits into two streams — one showing "
            "lines of code, the other showing blog post paragraphs — which then "
            "merge back into a single glowing document."
        ),
    },
    {
        "slug": "my-philosophy-on-ai",
        "concept": (
            "A human hand and a robotic hand reaching toward each other across "
            "a glowing divide, not quite touching but close — evoking the Sistine "
            "Chapel but in a flat vector tech aesthetic. A balance scale floats "
            "between them with a brain on one side and a circuit board on the other."
        ),
    },
    {
        "slug": "the-iterative-approach",
        "concept": (
            "A spiral staircase viewed from above, each step glowing slightly "
            "brighter than the last as it ascends, suggesting continuous upward "
            "progress through repetition. At five distinct points on the spiral, "
            "small glowing tool icons sit on the steps — a hammer, a magnifying "
            "glass, a speech bubble, a wrench, and a refresh arrow. The overall "
            "shape is elegant and upward-moving, not flat."
        ),
    },
    {
        "slug": "beyond-code",
        "concept": (
            "A person sits at a desk with a laptop, but behind them a large "
            "window opens onto a wide city skyline at dusk. The window frame "
            "divides the scene — warm amber tones outside representing the wider "
            "world, cool electric blue inside representing the technical workspace. "
            "The figure is small, emphasizing the vastness of what lies beyond "
            "the screen."
        ),
    },
    {
        "slug": "lets-connect",
        "concept": (
            "Two cartoon hands reaching toward each other from opposite sides "
            "of the image, almost touching at the center in a warm fist-bump "
            "or handshake gesture. Between them, a small burst of electric blue "
            "and amber light radiates outward like a spark of connection. "
            "The background is dark, keeping the focus entirely on the hands "
            "and the moment of connection between them."
        ),
    },
    {
        "slug": "whats-next",
        "concept": (
            "A rocket launching upward from a launchpad on the left, trailing "
            "electric blue exhaust. To the right, a branching roadmap of glowing "
            "nodes and paths extends upward — some paths split, some converge — "
            "suggesting multiple parallel projects in motion. Dark background "
            "with amber accent highlights on the rocket and key nodes."
        ),
    },
]


def load_dotenv() -> None:
    env_file = REPO_ROOT / ".env"
    if not env_file.exists():
        return
    for line in env_file.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, _, value = line.partition("=")
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = value


def generate_image(concept: str) -> str:
    client = openai.OpenAI()
    full_prompt = f"{concept}\n\nStyle requirements: {IMAGE_STYLE}"
    response = client.images.generate(
        model="dall-e-3",
        prompt=full_prompt,
        size="1024x1024",
        quality="hd",
        n=1,
    )
    return response.data[0].url


def download_image(url: str, dest: Path) -> None:
    resp = requests.get(url, timeout=60)
    resp.raise_for_status()
    dest.write_bytes(resp.content)


def convert_to_webp(png_path: Path) -> Path:
    webp_path = png_path.with_suffix(".webp")
    subprocess.run(
        ["cwebp", "-q", "90", str(png_path), "-o", str(webp_path)],
        check=True,
        capture_output=True,
    )
    return webp_path


def generate_alt_text(webp_path: Path) -> str:
    client = anthropic.Anthropic()
    image_data = base64.standard_b64encode(webp_path.read_bytes()).decode()
    response = client.messages.create(
        model="claude-sonnet-4-6",
        max_tokens=100,
        messages=[{
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": "image/webp",
                        "data": image_data,
                    },
                },
                {
                    "type": "text",
                    "text": (
                        "Write alt text for this image describing exactly what is "
                        "literally depicted — objects, colors, layout. "
                        "Aim for 10-15 words. No preamble, just the alt text."
                    ),
                },
            ],
        }],
    )
    return response.content[0].text.strip()


def main() -> None:
    load_dotenv()

    missing = [k for k in ("ANTHROPIC_API_KEY", "OPENAI_API_KEY") if not os.environ.get(k)]
    if missing:
        for k in missing:
            print(f"Error: {k} is not set")
        sys.exit(1)

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    sides = ["right", "left", "right", "left", "right", "left", "right"]

    for i, section in enumerate(SECTIONS):
        slug = section["slug"]
        side = sides[i]
        png_path = OUT_DIR / f"{slug}.png"
        webp_path = OUT_DIR / f"{slug}.webp"

        if webp_path.exists():
            print(f"Skipping {slug} — WebP already exists")
            continue

        print(f"\n[{i+1}/{len(SECTIONS)}] {slug}")
        print(f"  Generating image...")
        url = generate_image(section["concept"])

        print(f"  Downloading PNG...")
        download_image(url, png_path)

        print(f"  Converting to WebP...")
        convert_to_webp(png_path)

        print(f"  Generating alt text...")
        alt = generate_alt_text(webp_path)
        print(f"  Alt: {alt}")

        print(f"\n  Shortcode ({side} side):")
        print(f'  {{{{< avatar src="/images/about/{slug}.webp" alt="{alt}" side="{side}" shape="square" >}}}}')
        print(f'  ## <heading here>')
        print(f'  <content here>')
        print(f'  {{{{< /avatar >}}}}')

    print("\nDone. Add the shortcodes above to content/pages/about.md")


if __name__ == "__main__":
    main()
