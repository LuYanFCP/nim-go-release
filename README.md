# nim cli

We built the NIM CLI with 2 goals:
- Make running NIM extremely simple
- Deeply integrate NIM with the Claw ecosystem, so users can install OpenClaw (or other code agent like Claude Code) in a single command, with NIM automatically configured as the agent’s LLM

For now, $\color{red}{\textbf{it supports DGX Spark only}}$. We'll extend to a wide range of GPUs later.

## Documentation



- [QuickStart](./docs/quick-start.md)

- [Detail](./docs/how-to-use-detail.md)



## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

**China / 国内用户：**

```bash
curl -fsSL https://v6.gh-proxy.org/https://raw.githubusercontent.com/LuYanFCP/nim-go-release/refs/heads/main/install.sh | bash
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
| Linux | aarch64 (arm64) | `nim-linux-arm64` |
