#!/usr/bin/env python3
"""Recursively reorder Chrome bookmarks:
1) folders before non-folders
2) names containing CJK before non-CJK names
3) CJK names sorted by GB18030 byte order
4) non-CJK names sorted case-insensitively

Usage:
  chrome_bookmarks_sort_gb18030.py
  chrome_bookmarks_sort_gb18030.py --profile "~/Library/Application Support/Google/Chrome/Profile 1"
  chrome_bookmarks_sort_gb18030.py --list-backups

Notes:
- Intended for macOS. It may work on Linux with minor modifications
- Reorder the bookmarks, but Chrome will not sync the changes between devices
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any


DEFAULT_PROFILE = Path("~/Library/Application Support/Google/Chrome/Profile 1").expanduser()
BACKUP_RE = re.compile(r"^Bookmarks\.backup-\d{8}-\d{6}$")


def has_cjk(text: str) -> bool:
    for ch in text:
        code = ord(ch)
        if (
            0x3400 <= code <= 0x4DBF
            or 0x4E00 <= code <= 0x9FFF
            or 0xF900 <= code <= 0xFAFF
            or 0x20000 <= code <= 0x2A6DF
            or 0x2A700 <= code <= 0x2B73F
            or 0x2B740 <= code <= 0x2B81F
            or 0x2B820 <= code <= 0x2CEAF
        ):
            return True
    return False


def safe_name(node: dict[str, Any]) -> str:
    return str(node.get("name", ""))


def sort_key(node: dict[str, Any]) -> tuple[int, int, bytes]:
    type_rank = 0 if node.get("type") == "folder" else 1
    name = safe_name(node)
    cjk_rank = 0 if has_cjk(name) else 1
    if cjk_rank == 0:
        name_key = name.encode("gb18030", errors="ignore")
    else:
        name_key = name.casefold().encode("utf-8", errors="ignore")
    return (type_rank, cjk_rank, name_key)


def sort_children(node: dict[str, Any]) -> dict[str, Any]:
    if node.get("type") == "folder" and isinstance(node.get("children"), list):
        children = node["children"]
        for i, child in enumerate(children):
            if isinstance(child, dict):
                children[i] = sort_children(child)
        children.sort(key=sort_key)
    return node


def chrome_running() -> bool:
    proc = subprocess.run(
        ["pgrep", "-f", "Google Chrome.app/Contents/MacOS/Google Chrome"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    return proc.returncode == 0


def list_backups(profile_dir: Path) -> list[Path]:
    if not profile_dir.exists():
        return []
    backups = [
        p for p in profile_dir.iterdir() if p.is_file() and BACKUP_RE.match(p.name)
    ]
    return sorted(backups, key=lambda p: p.name)


def make_backup(bookmarks_path: Path) -> Path:
    ts = dt.datetime.now().strftime("%Y%m%d-%H%M%S")
    backup = bookmarks_path.with_name(f"Bookmarks.backup-{ts}")
    # Resolve potential same-second collisions.
    suffix = 1
    while backup.exists():
        backup = bookmarks_path.with_name(f"Bookmarks.backup-{ts}-{suffix}")
        suffix += 1
    shutil.copy2(bookmarks_path, backup)
    return backup


def reorder_bookmarks(bookmarks_path: Path) -> Path:
    with bookmarks_path.open("r", encoding="utf-8") as f:
        data = json.load(f)

    roots = data.get("roots", {})
    if isinstance(roots, dict):
        for key, value in list(roots.items()):
            if isinstance(value, dict):
                roots[key] = sort_children(value)

    tmp_path = bookmarks_path.with_suffix(".tmp")
    with tmp_path.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, separators=(",", ":"))

    # Validate JSON before replacing original.
    with tmp_path.open("r", encoding="utf-8") as f:
        json.load(f)

    tmp_path.replace(bookmarks_path)
    return bookmarks_path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Sort Chrome bookmarks recursively with folder-first and GB18030-aware Chinese ordering."
    )
    parser.add_argument(
        "--profile",
        default=str(DEFAULT_PROFILE),
        help="Chrome profile directory, default: %(default)s",
    )
    parser.add_argument(
        "--list-backups",
        action="store_true",
        help="Only list backup files and exit",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Run even if Chrome is running (not recommended)",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    profile_dir = Path(os.path.expanduser(args.profile))
    bookmarks_path = profile_dir / "Bookmarks"

    if args.list_backups:
        backups = list_backups(profile_dir)
        if not backups:
            print("No backup files found.")
            return 0
        print("Backup files:")
        for p in backups:
            print(str(p))
        return 0

    if not bookmarks_path.exists():
        print(f"Bookmarks file not found: {bookmarks_path}", file=sys.stderr)
        return 1

    if chrome_running() and not args.force:
        print(
            "Google Chrome appears to be running. Quit Chrome first, then rerun. "
            "(Or use --force if you accept overwrite risk.)",
            file=sys.stderr,
        )
        return 2

    backup_path = make_backup(bookmarks_path)
    reorder_bookmarks(bookmarks_path)
    print(f"Done. Backup created at: {backup_path}")
    print(f"Updated bookmarks: {bookmarks_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
