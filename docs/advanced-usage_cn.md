# NIM CLI 详细使用说明

## 0. 介绍

NIM CLI 是一个用于管理 NVIDIA NIM 容器的命令行工具，可以方便地拉取、启动、停止和查看 NIM 容器。

它的主要特性包括：

- **中国镜像支持：** 支持接入和切换 NGC-NIM 镜像源，方便中国用户获取 NIM 镜像。
- **Agent 集成：** 提供 `nim launch <agent>` 命令，可一键安装、配置并启动 Agent，同时自动将本地 NIM 接入 Agent。

## 1. 安装 NIM CLI

```bash
curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

**中国大陆用户：**

```bash
curl -fsSL https://v6.gh-proxy.org/https://raw.githubusercontent.com/LuYanFCP/nim-go-release/refs/heads/main/install.sh | bash
```

## 2. 选择下载源

在中国，NIM 镜像通过 CND（China NIM Distributor）分发。当前可用的 CND 包括：图灵新智算`tgcr`、图灵模镜`turingcm`、丽蟾`lichan`。

> **注意：** Spark NIMs 在这些 CND 中均无需认证。

```bash
nim config registry list
```

![CND 列表](./pic_yy/CND-List.png)

#### 场景 1：在中国大陆

你可以将任意一个 CND 设置为默认镜像源。例如，`tgcr` 通常提供最快的下载速度：

```bash
nim config registry default tgcr
```

#### 场景 2：在中国大陆以外

可以将 `ngc` 或 `tgcr` 设置为默认镜像源。

> 如果选择 `ngc`，则需要提供 NVIDIA API Key。详情请参阅 [NGC 快速开始](./ngc-quick-start_cn.md)。

## 3. 搜索合适的 NIM 容器

```bash
nim search <query>
```

例如，搜索与 Qwen3.5 相关的 NIM：
![搜索 Qwen3.5 相关的 NIM](./pic/qwen3.5-search.png)

## 4. 拉取并运行 NIM

找到合适的 NIM 后，复制对应的镜像名称进行拉取和启动。下面以 `qwen/qwen3.5-35b-a3b` 为例：

```bash
nim pull qwen/qwen3.5-35b-a3b
nim run qwen/qwen3.5-35b-a3b --port 8001 # 指定端口为 8001；如省略则默认使用 8000
```

> `nim run` 的行为类似于 `docker run`。如果本地不存在对应镜像，会自动先拉取再启动。若未指定 `--port`，默认使用 `8000` 端口。

![拉取并启动 NIM](./pic/qwen3.5-run.png)

## 5. 使用 NIM CLI 启动 Claude Code

NIM CLI 提供 `nim launch <agent>` 命令，可一键安装、配置并启动 Agent，同时自动将本地 NIM 接入 Agent。

例如，启动 Claude Code：

```bash
nim launch claude-code --model qwen/qwen3.5-35b-a3b --port 8001
nim launch claude-code # 使用本地已启动的 NIM
```

![完整示例](./pic/claude-code-without-run.png)

然后执行以下命令启动 Claude Code：

```bash
source /root/.nim/claude-code.env && claude
```

![claude-code](./pic/claude-code-local.png)

## 6. 使用 NIM CLI 启动 OpenClaw

NIM CLI 提供 `nim launch openclaw` 命令，可一键安装、配置并启动 OpenClaw，同时自动将本地 NIM 接入 Agent。为了更好地适配中国用户，我们还提供了 `nim launch openclaw --with-wechat` 命令，可自动安装并配置 WeChat 插件。

例如，启动 OpenClaw：

```bash
nim launch openclaw --model qwen/qwen3.5-35b-a3b --port 8001
nim launch openclaw # 使用本地已启动的 NIM
nim launch openclaw --with-wechat # 安装 WeChat plugin并自动配置，然后启动 OpenClaw gateway
nim launch openclaw --run # 启动 OpenClaw gateway 和 OpenClaw TUI
```

下图展示了安装、启动和配置 OpenClaw 的完整流程，其中也包括 WeChat 插件的安装与配置：
![安装/启动/配置 OpenClaw](./pic/openclaw-install.png)
![微信配置](./pic/config_wechat.png)

微信连接与使用示例：

![微信连接和访问](./pic/wechat_connect.jpg)
![微信对话](./pic/wechat-comm.jpg)

## 7. 故障排查

如果你遇到以下错误：

```
Error: Docker error: Docker responded with status code 401: unauthorized: project nim not found
```

可以先运行诊断命令：

```bash
nim diag
```

![运行诊断](./pic_yy/diagnose.png)

如果希望自动修复问题，可以执行：

```bash
nim diag --fix
```

![修复问题](./pic_yy/fix.png)
![修复完成](./pic_yy/check-pass.png)