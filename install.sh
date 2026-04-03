#!/usr/bin/env bash
set -euo pipefail

REPO="LuYanFCP/nim-go-release"
BINARY_NAME="nim"
INSTALL_DIR="${NIM_INSTALL_DIR:-/usr/local/bin}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()  { printf "${CYAN}%s${RESET}\n" "$*"; }
success() { printf "${GREEN}${BOLD}%s${RESET}\n" "$*"; }
warn()  { printf "${YELLOW}%s${RESET}\n" "$*"; }
error() { printf "${RED}%s${RESET}\n" "$*" >&2; exit 1; }

detect_arch() {
    local arch
    arch=$(uname -m)
    case "${arch}" in
        x86_64|amd64)   echo "amd64" ;;
        aarch64|arm64)  echo "arm64" ;;
        *)              error "Unsupported architecture: ${arch}" ;;
    esac
}

detect_os() {
    local os
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    case "${os}" in
        linux)  echo "linux" ;;
        *)      error "Unsupported OS: ${os}. Only Linux is supported." ;;
    esac
}

detect_china_network() {
    if curl -sI --connect-timeout 3 --max-time 5 "https://api.github.com" > /dev/null 2>&1; then
        echo "direct"
    else
        echo "proxy"
    fi
}

get_version_via_api() {
    local url="$1"
    curl -fsSL "${url}/repos/${REPO}/releases/latest" 2>/dev/null \
        | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"//;s/".*//'
}

get_version_via_redirect() {
    local base="$1"
    curl -fsSLI -o /dev/null -w '%{url_effective}' "${base}/${REPO}/releases/latest" 2>/dev/null \
        | sed 's|.*/tag/||'
}

get_latest_version() {
    local api_base="$1"
    local github_base="$2"
    local version

    version=$(get_version_via_api "${api_base}")

    if [ -z "${version}" ]; then
        warn "API fetch failed, trying redirect method..."
        version=$(get_version_via_redirect "${github_base}")
    fi

    if [ -z "${version}" ] && [ "${api_base}" != "https://v6.gh-proxy.org/https://api.github.com" ]; then
        warn "Direct access failed, falling back to proxy..."
        version=$(get_version_via_api "https://v6.gh-proxy.org/https://api.github.com")
        if [ -z "${version}" ]; then
            version=$(get_version_via_redirect "https://v6.gh-proxy.org/https://github.com")
        fi
    fi

    if [ -z "${version}" ]; then
        error "Failed to fetch latest version. Check your network or set NIM_VERSION manually."
    fi
    echo "${version}"
}

main() {
    local os arch version network_mode github_base api_base download_url

    printf "\n${BOLD}  nim installer${RESET}\n\n"

    os=$(detect_os)
    arch=$(detect_arch)
    info "Detected platform: ${os}/${arch}"

    info "Checking network connectivity..."
    network_mode=$(detect_china_network)

    if [ "${network_mode}" = "proxy" ]; then
        warn "Direct access to GitHub is slow or unavailable, using proxy (v6.gh-proxy.org)"
        github_base="https://v6.gh-proxy.org/https://github.com"
        api_base="https://v6.gh-proxy.org/https://api.github.com"
    else
        info "Direct access to GitHub is available"
        github_base="https://github.com"
        api_base="https://api.github.com"
    fi

    version="${NIM_VERSION:-}"
    if [ -z "${version}" ]; then
        info "Fetching latest version..."
        version=$(get_latest_version "${api_base}" "${github_base}")
    fi
    info "Version: ${version}"

    local binary_name="${BINARY_NAME}-${os}-${arch}"
    download_url="${github_base}/${REPO}/releases/download/${version}/${binary_name}"

    info "Downloading ${binary_name}..."
    tmpdir=$(mktemp -d)
    trap 'rm -rf "${tmpdir}"' EXIT

    if ! curl -fSL --progress-bar -o "${tmpdir}/${BINARY_NAME}" "${download_url}"; then
        error "Download failed: ${download_url}"
    fi

    chmod +x "${tmpdir}/${BINARY_NAME}"

    info "Verifying binary..."
    if ! "${tmpdir}/${BINARY_NAME}" --version > /dev/null 2>&1; then
        warn "Binary verification skipped (--version not supported yet)"
    fi

    info "Installing to ${INSTALL_DIR}/${BINARY_NAME}..."
    if [ -w "${INSTALL_DIR}" ]; then
        mv "${tmpdir}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
    else
        sudo mv "${tmpdir}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
    fi

    if command -v "${BINARY_NAME}" > /dev/null 2>&1; then
        success "nim installed successfully!"
        printf "\n  ${BOLD}%s${RESET}\n\n" "$(command -v "${BINARY_NAME}")"
    else
        success "nim installed to ${INSTALL_DIR}/${BINARY_NAME}"
        warn "${INSTALL_DIR} is not in your PATH. To fix this, run:\n"

        local shell_name current_shell rc_file
        current_shell=$(basename "${SHELL:-/bin/bash}")
        case "${current_shell}" in
            zsh)  rc_file=~/.zshrc ;;
            fish) rc_file=~/.config/fish/config.fish ;;
            *)    rc_file=~/.bashrc ;;
        esac

        if [ "${current_shell}" = "fish" ]; then
            printf "  ${CYAN}# Add to %s for permanent use${RESET}\n" "${rc_file}"
            printf "  ${BOLD}fish_add_path %s${RESET}\n\n" "${INSTALL_DIR}"
        else
            printf "  ${CYAN}# Temporary (current session only)${RESET}\n"
            printf "  ${BOLD}export PATH=\"%s:\$PATH\"${RESET}\n\n" "${INSTALL_DIR}"
            printf "  ${CYAN}# Permanent (add to %s)${RESET}\n" "${rc_file}"
            printf "  ${BOLD}echo 'export PATH=\"%s:\$PATH\"' >> %s && source %s${RESET}\n\n" \
                "${INSTALL_DIR}" "${rc_file}" "${rc_file}"
        fi
    fi

    local checksum_url="${github_base}/${REPO}/releases/download/${version}/checksums-sha256.txt"
    local checksum_file="${tmpdir}/checksums-sha256.txt"
    if curl -fsSL -o "${checksum_file}" "${checksum_url}" 2>/dev/null; then
        local expected actual
        expected=$(grep "${binary_name}" "${checksum_file}" | awk '{print $1}')
        actual=$(sha256sum "${INSTALL_DIR}/${BINARY_NAME}" | awk '{print $1}')
        if [ -n "${expected}" ] && [ "${expected}" = "${actual}" ]; then
            success "Checksum verified"
        elif [ -n "${expected}" ]; then
            error "Checksum mismatch! Expected: ${expected}, Got: ${actual}"
        fi
    fi

    printf "${GREEN}${BOLD}Done!${RESET} Run ${CYAN}nim --help${RESET} to get started.\n\n"
}

main "$@"
