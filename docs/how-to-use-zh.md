# 如何使用Nim Cli

## 0. 介绍

Nim Cli 是一个用于管理NVIDIA NIM 容器的命令行工具。它提供了拉取NIM 容器、启动NIM 容器、停止NIM 容器、列出NIM 容器等功能。 尤其是在中国他提供了接入和切换NGC-NIM镜像的能力，极大的方便了用户的使用。除此之外他最核心的功能是和Agent整合，提供了`nim launch <agent>` 命令，可以一键安装/配置/启动Agent并自动将本地的NIM接入Agent。

## 1. 安装Nim Cli

```bash
curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

**China / 国内用户：**

```bash
curl -fsSL https://v6.gh-proxy.org/https://raw.githubusercontent.com/LuYanFCP/nim-go-release/refs/heads/main/install.sh | bash
```

## 2. 如何找到合适的NIM 容器

```bash
nim search <query>
```

例如搜索Qwen3.5相关的模型的NIM:
[搜索Qwen3.5相关的模型的NIM](./pic/qwen3.5-search.png)

### 3. 如何拉取和启动NIM

找到合适的NIM之后，COPY nim的Image进行拉取和启动, 例如拉取Qwen3.5-35B-A3B的NIM:
```bash
nim pull qwen/qwen3.5-35b-a3b
nim run qwen/qwen3.5-35b-a3b --port 8001 # 指定端口为8001, 如果不填会默认使用8000端口
```

> 注意：nim run 类似于docker run 如果没有找到相关NIM，会自动拉取并启动NIM。

[拉取和启动NIM](./pic/qwen3.5-run.png)

### 4. 如何使用Nim Cli 启动Claude Code

Nim Cli 提供了`nim launch <agent>` 命令，可以一键安装/配置/启动Agent并自动将本地的NIM接入Agent。

例如启动Claude Code:
```bash
nim launch claude-code --model qwen/qwen3.5-35b-a3b --port 8001
nim launch claude-code # 使用本地已启动的NIM
```

[完整示例](./pic/claude-code-without-run.png)

使用提示命令进行启动:

```bash
source /root/.nim/claude-code.env && claude
```

[claude-code](./pic/claude-code-local.png)


### 5. 如何使用Nim Cli 启动OpenClaw

Nim Cli 提供了`nim launch openclaw` 命令，可以一键安装/配置/启动OpenClaw并自动将本地的NIM接入Agent。除此之外为了适配中国市场，我们提供了`nim launch openclaw --with-wechat` 命令，自动安装wechat plugin并自动配置。

例如启动OpenClaw:
```bash
nim launch openclaw --model qwen/qwen3.5-35b-a3b --port 8001
nim launch openclaw # 使用本地已启动的NIM
nim launch openclaw --with-wechat # 安装wechat plugin, 并自动配置, 然后启动openclaw gateway
nim launch openclaw --run # 启动openclaw gateway 和 openclaw tui
```

当前图片展示为安装/启动/配置 OpenClaw 的全流程, 包括wechat plugin的安装和配置。
[安装/启动/配置 OpenClaw](./pic/openclaw-install.png)
[微信配置](./pic/config_wechat.png)


微信连接和访问:

[微信连接和访问](./pic/wechat_connect.jpg)
[微信对话](./pic/wechat-comm.jpg)