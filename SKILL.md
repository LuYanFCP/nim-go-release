---
name: nim-go-release
description: Guides the agent to install, configure, troubleshoot, and operate the `nim` CLI from nim-go-release. Use when the user mentions `nim`, `nim-go-release`, NVIDIA NIM, registry setup, model search/pull/run/stop/list, `nim launch`, Claude Code, OpenClaw, 更新, 安装, 用法, or asks for exact command examples.
---

# nim-go-release

## Use This Skill When

- The user asks how to install or use the `nim` CLI.
- The user mentions `nim-go-release`, NVIDIA NIM, registry switching, or model lifecycle commands.
- The user wants exact command examples for `nim launch`, `nim search`, `nim pull`, `nim run`, `nim diag`, or `nim update`.

## Source Of Truth

- Treat `src/cli/mod.rs` as the current CLI contract.
- Use `nim-go-release/README.md` and `nim-go-release/docs/how-to-use-detail-zh.md` for install snippets and common workflows.
- If docs and code disagree, trust the code.
- Do not suggest outdated flags that are not in the current CLI, such as `nim list --remote`.

## Install

Default install:

```bash
curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

China network:

```bash
curl -fsSL https://v6.gh-proxy.org/https://raw.githubusercontent.com/LuYanFCP/nim-go-release/refs/heads/main/install.sh | bash
```

Common install options:

```bash
NIM_VERSION=v2026.04.03.a3 curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
NIM_INSTALL_DIR=~/.local/bin curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

## Command Discovery

Use help output when the user asks for exact syntax:

```bash
nim --help
nim <command> --help
nim launch --help
nim config --help
```

## Current Commands

### Environment And Config

- `nim diag [--fix]`
  Diagnose Docker, GPU, permissions, config, cache directory, and updates. Start here when the environment is unknown or broken.
- `nim info`
  Show tracked models, running and stopped containers, GPU summary, and config summary.
- `nim update [--force] [--gh_proxy]`
  Self-upgrade the binary. Prefer `--gh_proxy` on China networks.
- `nim config set <ngc-api-key|default-port|default-gpus|cache-dir> <value>`
  Set core config values.
- `nim config registry list`
  Show built-in registries and auth status.
- `nim config registry default <ngc|tgcr|turingcm>`
  Set the default registry. This may prompt for credentials if required.
- `nim config registry login <name> [-u <username>] [-p <password>]`
  Save registry credentials explicitly.

### Model Lifecycle

- `nim search <query> [--registry <name>]`
  Search available models in a registry. Empty query lists all available models.
- `nim pull <model> [--registry <name>]`
  Pull a NIM model image from the selected registry.
- `nim run [model] [--port <port>] [--gpus <all|0,1>] [-d|--detach] [--only-cache]`
  Start a NIM container. If the model is missing locally, it auto-pulls first.
- `nim stop [model] [--all]`
  Stop one running container or all managed containers.
- `nim list [--running]`
  List tracked models and managed containers.
- `nim rm [model] [--all]`
  Remove one tracked model image or all tracked model images.

Behavior notes:

- Omitting `model` in `nim run` is allowed and may trigger interactive selection.
- `nim run --only-cache` starts a temporary container, runs the cache warm-up flow, then exits.
- `--gpus` accepts values like `all` or `0,1`.

### Agent Launch

- `nim launch --list`
  List available launch recipes.
- `nim launch <recipe> [--model <name> | --image <ref>] [--port <port>] [--run]`
  Launch an agent against a NIM backend.
- OpenClaw-only flags:
  `--with-wechat`, `--with-feishu`, `--websearch`

Current recipes:

- `claude-code`
  Claude Code with NIM via LiteLLM proxy.
  Aliases: `claude`, `claudecode`, `claude_code`
- `hermes-agent`
  Hermes Agent with NIM directly.
  Aliases: `hermes`, `hermes_agent`, `hermesagent`
- `nemoclaw`
  NemoClaw with NIM via OpenShell provider.
  Aliases: `nemo-claw`, `nemo_claw`
- `openclaw`
  OpenClaw with NIM directly.
  Aliases: `open-claw`, `open_claw`, `clawdbot`

Behavior notes:

- `--image` uses a full image reference directly and skips model lookup.
- `--model` resolves through tracked models or registry search.
- If neither `--model` nor `--image` is provided, `nim launch` first tries to reuse a running NIM container.
- If no running NIM exists and the terminal is interactive, `nim launch` can prompt the user to pick a model.
- `nim launch openclaw --with-feishu` and `nim launch openclaw --websearch` require an interactive terminal.
- `nim launch claude-code` writes `~/.nim/claude-code.env`.

## Recommended Workflows

### First-Time Setup

```bash
nim diag
nim config registry list
nim config registry default tgcr
```

If the chosen registry needs credentials:

```bash
nim config registry login tgcr -u <username> -p <password>
nim config registry default tgcr
```

For NGC:

```bash
nim config set ngc-api-key <your-ngc-api-key>
nim config registry default ngc
```

### Search, Pull, And Run A Model

```bash
nim search qwen
nim pull qwen/qwen3.5-35b-a3b
nim run qwen/qwen3.5-35b-a3b --port 8001
nim list --running
```

### Launch Claude Code

Use a specific model:

```bash
nim launch claude-code --model qwen/qwen3.5-35b-a3b --port 8001
source ~/.nim/claude-code.env && claude
```

Reuse an already running NIM:

```bash
nim launch claude-code
source ~/.nim/claude-code.env && claude
```

### Launch OpenClaw

Basic launch:

```bash
nim launch openclaw --model qwen/qwen3.5-35b-a3b --port 8001
```

WeChat integration:

```bash
nim launch openclaw --with-wechat
```

Start the TUI immediately:

```bash
nim launch openclaw --run
```

### Stop, Remove, And Inspect

```bash
nim stop qwen/qwen3.5-35b-a3b
nim rm qwen/qwen3.5-35b-a3b
nim info
```

### Diagnose Or Upgrade

```bash
nim diag
nim diag --fix
nim update
nim update --gh_proxy
```

## Response Guidance

- Prefer short, exact command sequences over long prose.
- When the user is in China or network access is flaky, include proxy install and update commands when relevant.
- When the user asks "怎么用", start from the smallest working flow: `search` -> `pull` -> `run` -> `launch`.
- When the user asks the agent to operate directly on a machine with unknown readiness, start with `nim diag` or `nim info`.
- For registry or auth failures, check `nim config registry list` before suggesting reinstallation.
- After `nim update`, recommend `nim info` or `nim diag` to verify the environment.
