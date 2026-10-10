import argparse
from html.parser import HTMLParser
from pathlib import Path
import re
import subprocess
import tomllib
from urllib.parse import unquote, urlsplit


LINK = re.compile(r'\[[^\]\n]*\]\(\s*(?:<([^>]+)>|([^\s)]+))(?:\s+"[^"]*")?\s*\)')
REFERENCE = re.compile(r'^\s{0,3}\[[^\]]+\]:\s*(?:<([^>]+)>|(\S+))', re.MULTILINE)
FENCE = re.compile(r'^\s*(`{3,}|~{3,})')


class HtmlLinks(HTMLParser):
    def __init__(self):
        super().__init__()
        self.targets = []

    def handle_starttag(self, tag, attrs):
        for name, value in attrs:
            if value and (tag == 'a' and name == 'href' or tag == 'img' and name == 'src'):
                self.targets.append(value)


def link_targets(text):
    lines = []
    fence = None
    for line in text.splitlines():
        marker = FENCE.match(line)
        if marker:
            value = marker.group(1)
            if fence is None:
                fence = value
            elif value[0] == fence[0] and len(value) >= len(fence):
                fence = None
        elif fence is None:
            lines.append(line)
    text = '\n'.join(lines)
    for match in LINK.finditer(text):
        yield match.group(1) or match.group(2)
    for match in REFERENCE.finditer(text):
        yield match.group(1) or match.group(2)
    html = HtmlLinks()
    html.feed(text)
    yield from html.targets


def check_files(root, files):
    problems = []
    for name in files:
        path = root / name
        if path.suffix.lower() == '.toml':
            try:
                with path.open('rb') as source:
                    tomllib.load(source)
            except (tomllib.TOMLDecodeError, OSError) as error:
                problems.append(f'{name}: invalid TOML: {error}')
        elif path.suffix.lower() == '.md':
            for target in link_targets(path.read_text(encoding='utf-8-sig')):
                url = urlsplit(target)
                if url.scheme or url.netloc or not url.path:
                    continue
                decoded = unquote(url.path)
                destination = root / decoded.lstrip('/') if decoded.startswith('/') else path.parent / decoded
                if not destination.exists():
                    problems.append(f'{name}: missing link target {target}')
    return problems


def main():
    parser = argparse.ArgumentParser(description='Check tracked Markdown links and TOML syntax.')
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    root = args.root.resolve()
    result = subprocess.run(['git', 'ls-files', '-z'], cwd=root, check=True, capture_output=True)
    files = result.stdout.decode('utf-8').split('\0')
    problems = check_files(root, (name for name in files if name))
    for problem in problems:
        print(problem)
    print(f'{len(problems)} problem(s) in tracked Markdown and TOML files.')
    return 1 if problems else 0


if __name__ == '__main__':
    raise SystemExit(main())
