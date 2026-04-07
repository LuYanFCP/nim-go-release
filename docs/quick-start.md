# Quick Start

## Step 1. Install NIM CLI

```bash
curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

## Step 2. Launch with OpenClaw or Claude Code

**OpenClaw:**

```bash
nim launch openclaw
```

**Claude Code:**

```bash
nim launch claude-code --run
```

The command will guide you to select a registry and a model interactively.

> In China, choose a CND (`tgcr`, `turingcm`, or `lichan`) — we recommend `tgcr` for the fastest speed. Spark NIMs require no authentication.

![Select a registry](./pic_yy/choose-registry.png)
![Select a model](./pic_yy/choose-model.png)

For more details, see [Advanced Usage](./advanced-usage.md).
