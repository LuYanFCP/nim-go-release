# Quick Start with NGC
## 0. Obtaining API Keys
Depending on which workflows you are running, you may need to obtain API keys from the respective services. NIM requires an NVIDIA API key defined with the `NVIDIA_API_KEY` environment variable. You can obtain an API key by creating an account on [build.nvidia.com](https://build.nvidia.com).

## 1. Install NIM CLI
```bash
curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

**For users located in China:**

```bash
curl -fsSL https://v6.gh-proxy.org/https://raw.githubusercontent.com/LuYanFCP/nim-go-release/refs/heads/main/install.sh | bash
```
<details>
<summary>Install NIM CLI</summary>

![Install NIM CLI](./pic/install.png)

</details>

## 2a. Launch a NIM with OpenClaw

```bash
nim launch openclaw --with-wechat --model qwen3.5-35b-a3b
```
<details>
<summary>Config registry with NGC</summary>

![Config registry with NGC](./pic/ngc-choose-1.png)

</details>
<details>
<summary>Launch OpenClaw (1)</summary>

![Launch OpenClaw](./pic/ngc-openclaw-1.png)

</details>
<details>
<summary>Launch OpenClaw (2)</summary>

![Launch OpenClaw (2)](./pic/ngc-openclaw-2.png)

</details>


## 2b. Launch a NIM with Claude Code

```bash
nim launch claude-code --run
```
<details>
<summary>Launch Claude Code</summary>

![Launch Claude Code](./pic/ngc-cc.png)

</details>



## 2c. Use NIM Only
### Search NIM models
```bash
nim search qwen
```
<details>
<summary>nim search qwen</summary>

![nim search qwen](./pic/ngc-nim-seach.png)

</details>

### pull NIM image
```bash
nim pull qwen3.5-35b-a3b
```

<details>
<summary>nim pull qwen3.5-35b-a3b</summary>

![nim pull qwen3.5-35b-a3b](./pic/ngc-pull.png)

</details>

### Run NIM
```bash
nim run qwen3.5-35b-a3b
```

<details>
<summary>nim run qwen3.5-35b-a3b</summary>

![nim run qwen3.5-35b-a3b](./pic/ngc-nim-run.png)

</details>
