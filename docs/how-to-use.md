# How to Use Nim CLI

## 0. Introduction

Nim CLI is a command-line tool for managing NVIDIA NIM containers. It provides functionalities such as pulling, launching, stopping, and listing NIM containers. Especially in China, it offers the ability to connect to and switch between NGC-NIM mirrors, greatly simplifying the user experience. Beyond that, its core feature is Agent integration — the `nim launch <agent>` command lets you install, configure, and start an Agent with a single command, automatically connecting your local NIM to the Agent.

## 1. Install Nim CLI

```bash
curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

**China / 国内用户：**

```bash
curl -fsSL https://v6.gh-proxy.org/https://raw.githubusercontent.com/LuYanFCP/nim-go-release/refs/heads/main/install.sh | bash
```

## 2. Finding the Right NIM Container

```bash
nim search <query>
```

For example, searching for NIM containers related to Qwen3.5:
![Search for Qwen3.5 NIM containers](./pic/qwen3.5-search.png)

### 3. Pulling and Starting a NIM

Once you find a suitable NIM, copy the NIM image name to pull and start it. For example, pulling Qwen3.5-35B-A3B:
```bash
nim pull qwen/qwen3.5-35b-a3b
nim run qwen/qwen3.5-35b-a3b --port 8001 # Specify port 8001; defaults to 8000 if omitted
```

> Note: `nim run` works like `docker run` — if the NIM image is not found locally, it will be automatically pulled before starting.

![Pull and start NIM](./pic/qwen3.5-run.png)

### 4. Launching Claude Code with Nim CLI

Nim CLI provides the `nim launch <agent>` command to install, configure, and start an Agent in one step, automatically connecting your local NIM to the Agent.

For example, launching Claude Code:
```bash
nim launch claude-code --model qwen/qwen3.5-35b-a3b --port 8001
nim launch claude-code # Use a locally running NIM
```

![Full example](./pic/claude-code-without-run.png)

Start using the prompted command:

```bash
source /root/.nim/claude-code.env && claude
```

![claude-code](./pic/claude-code-local.png)


### 5. Launching OpenClaw with Nim CLI

Nim CLI provides the `nim launch openclaw` command to install, configure, and start OpenClaw in one step, automatically connecting your local NIM to the Agent. Additionally, to support the China market, we provide `nim launch openclaw --with-wechat`, which automatically installs and configures the WeChat plugin.

For example, launching OpenClaw:
```bash
nim launch openclaw --model qwen/qwen3.5-35b-a3b --port 8001
nim launch openclaw # Use a locally running NIM
nim launch openclaw --with-wechat # Install and auto-configure the WeChat plugin, then start the OpenClaw gateway
nim launch openclaw --run # Start the OpenClaw gateway and OpenClaw TUI
```

The following images show the full workflow of installing, starting, and configuring OpenClaw, including WeChat plugin installation and configuration.
![Install / Start / Configure OpenClaw](./pic/openclaw-install.png)
![WeChat configuration](./pic/config_wechat.png)


WeChat connection and access:

![WeChat connection and access](./pic/wechat_connect.jpg)
![WeChat conversation](./pic/wechat-comm.jpg)
