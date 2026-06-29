#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = []
# ///

from __future__ import annotations

import hashlib
import json
import os
import platform
import shutil
import stat
import subprocess
import sys
import tempfile
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any

BINARY_NAME = "nim"
INSTALL_DIR = Path(os.environ.get("NIM_INSTALL_DIR", "/usr/local/bin")).expanduser()
GITHUB_REPO = "LuYanFCP/nim-go-release"
GITHUB_API_BASE = f"https://api.github.com/repos/{GITHUB_REPO}"
USER_AGENT = "nim-uv-installer"


def info(message: str) -> None:
    print(f"\033[0;36m{message}\033[0m", file=sys.stderr)


def success(message: str) -> None:
    print(f"\033[0;32m\033[1m{message}\033[0m", file=sys.stderr)


def warn(message: str) -> None:
    print(f"\033[1;33m{message}\033[0m", file=sys.stderr)


def fail(message: str) -> None:
    print(f"\033[0;31m{message}\033[0m", file=sys.stderr)
    raise SystemExit(1)


def detect_os() -> str:
    os_name = platform.system().lower()
    if os_name == "linux":
        return "linux"
    fail(f"Unsupported OS: {os_name}. Only Linux is supported.")


def detect_arch() -> str:
    arch = platform.machine().lower()
    if arch in {"x86_64", "amd64"}:
        return "amd64"
    if arch in {"aarch64", "arm64"}:
        return "arm64"
    fail(f"Unsupported architecture: {arch}")


def request_url(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    try:
        with urllib.request.urlopen(request) as response:
            return response.read()
    except urllib.error.URLError as exc:
        fail(f"Download failed: {url}\n{exc}")


def request_json(url: str) -> dict[str, Any]:
    body = request_url(url)
    try:
        value = json.loads(body)
    except json.JSONDecodeError as exc:
        fail(f"Invalid JSON response from {url}: {exc}")

    if not isinstance(value, dict):
        fail(f"Invalid JSON response from {url}: expected object")
    return value


def normalize_tag(version: str) -> str:
    return version if version.startswith("v") else f"v{version}"


def release_api_url() -> str:
    version = os.environ.get("NIM_VERSION", "")
    if version:
        return f"{GITHUB_API_BASE}/releases/tags/{normalize_tag(version)}"
    return f"{GITHUB_API_BASE}/releases/latest"


def find_asset(release: dict[str, Any], name: str) -> dict[str, Any]:
    assets = release.get("assets")
    if not isinstance(assets, list):
        fail("Invalid release response: assets is missing")

    for asset in assets:
        if isinstance(asset, dict) and asset.get("name") == name:
            return asset

    tag_name = release.get("tag_name", "unknown")
    fail(f"Release {tag_name} does not contain asset {name}")


def asset_sha256(asset: dict[str, Any]) -> str | None:
    digest = asset.get("digest")
    if isinstance(digest, str) and digest.startswith("sha256:"):
        return digest.removeprefix("sha256:")
    return None


def checksum_from_file(release: dict[str, Any], binary_name: str) -> str | None:
    checksum_asset = find_asset(release, "checksums-sha256.txt")
    checksum_url = checksum_asset.get("browser_download_url")
    if not isinstance(checksum_url, str):
        return None

    content = request_url(checksum_url).decode("utf-8")
    for line in content.splitlines():
        parts = line.split()
        if len(parts) >= 2 and parts[1] == binary_name:
            return parts[0]
    return None


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as file:
        for chunk in iter(lambda: file.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def download_asset(asset: dict[str, Any], output: Path) -> None:
    url = asset.get("browser_download_url")
    if not isinstance(url, str):
        fail("Invalid release asset: browser_download_url is missing")

    info(f"Downloading {asset.get('name', BINARY_NAME)}...")
    output.write_bytes(request_url(url))
    output.chmod(output.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)


def ensure_install_dir(path: Path) -> None:
    if path.exists():
        return

    parent = path.parent
    if parent.exists() and os.access(parent, os.W_OK):
        path.mkdir(parents=True, exist_ok=True)
        return

    subprocess.run(["sudo", "mkdir", "-p", str(path)], check=True)


def move_into_place(source: Path, target: Path) -> None:
    if os.access(target.parent, os.W_OK):
        shutil.move(str(source), str(target))
    else:
        subprocess.run(["sudo", "mv", str(source), str(target)], check=True)


def verify_binary(path: Path) -> None:
    result = subprocess.run([str(path), "--version"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    if result.returncode != 0:
        warn("Binary verification skipped (--version not supported yet)")


def install_binary(binary_file: Path) -> Path:
    ensure_install_dir(INSTALL_DIR)
    target = INSTALL_DIR / BINARY_NAME
    info(f"Installing to {target}...")
    move_into_place(binary_file, target)
    return target


def print_path_hint(target: Path) -> None:
    if shutil.which(BINARY_NAME):
        success("nim installed successfully!")
        print(f"\n  \033[1m{shutil.which(BINARY_NAME)}\033[0m\n", file=sys.stderr)
        return

    success(f"nim installed to {target}")
    warn(f"{INSTALL_DIR} is not in your PATH.")
    print(f'  \033[1mexport PATH="{INSTALL_DIR}:$PATH"\033[0m\n', file=sys.stderr)


def main() -> None:
    print("\n\033[1m  nim uv installer\033[0m\n", file=sys.stderr)

    os_name = detect_os()
    arch = detect_arch()
    info(f"Detected platform: {os_name}/{arch}")

    release = request_json(release_api_url())
    tag_name = release.get("tag_name")
    if not isinstance(tag_name, str):
        fail("Invalid release response: tag_name is missing")
    info(f"Version: {tag_name}")

    binary_name = f"nim-{os_name}-{arch}"
    asset = find_asset(release, binary_name)
    expected = asset_sha256(asset) or checksum_from_file(release, binary_name)

    with tempfile.TemporaryDirectory() as tmpdir:
        binary_file = Path(tmpdir) / BINARY_NAME
        download_asset(asset, binary_file)

        if expected:
            actual = sha256_file(binary_file)
            if expected != actual:
                fail(f"Checksum mismatch! Expected: {expected}, Got: {actual}")
            success("Checksum verified")

        verify_binary(binary_file)
        target = install_binary(binary_file)

    print_path_hint(target)
    print("\033[0;32m\033[1mDone!\033[0m Run \033[0;36mnim --help\033[0m to get started.\n")


if __name__ == "__main__":
    main()
