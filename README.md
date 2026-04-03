# nim

A CLI tool that wraps NVIDIA NIM container deployment into Ollama-style commands. Go from `nim pull` to `nim launch claude-code` in three commands.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

**China / 国内用户：**

```bash
curl -fsSL https://v6.gh-proxy.org/https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

### Options

```bash
# Install a specific version
NIM_VERSION=v2026.04.03.a3 curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash

# Custom install directory (default: /usr/local/bin)
NIM_INSTALL_DIR=~/.local/bin curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

### Supported Platforms

| Platform | Architecture | Binary |
|----------|-------------|--------|
| Linux | x86_64 (amd64) | `nim-linux-amd64` |
| Linux | aarch64 (arm64) | `nim-linux-arm64` |

## Quick Start

```bash
# Pull a model
nim pull llama-3.1-8b-instruct

# Run it
nim run llama-3.1-8b-instruct

# Launch with Claude Code
nim launch claude-code --model llama-3.1-8b-instruct
```

## License

Apache-2.0
