
## 0. Obtaining API Keys
Depending on which workflows you are running, you may need to obtain API keys from the respective services. NI require an NVIDIA API key defined with the NVIDIA_API_KEY environment variable. An API key can be obtained by creating an account on build.nvidia.com.

## 1. Install Nim CLI
```bash
curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```

**China / 国内用户：**

```bash
curl -fsSL https://v6.gh-proxy.org/https://raw.githubusercontent.com/LuYanFCP/nim-go-release/refs/heads/main/install.sh | bash
```
<details>
<summary>Install NIM CLI</summary>

![Install NIM CLI](./pic/install.png)

</details>

## 1.1. Diag check and fix
```bash
nim diag
nim diag --fix
```

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

![Launch Openclaw](./pic/ngc-openclaw-1.png)

</details>
<details>
<summary>Launch OpenClaw (2)</summary>

![Launch Openclaw1](./pic/ngc-openclaw-2.png)

</details>


## 2b. Launch a NIM with Claude Code

```bash
nim launch claude-code --run 
```
<details>
<summary>Launch Claude Code</summary>

![Launch ClaudeCode](./pic/ngc-cc.png)

</details>



## 2c. ONLY NIM
### search NIM models
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

![nim run qwen/qwen3.5-35b-a3b](./pic/ngc-pull.png)

</details>

### run NIM
```bash
nim run qwen3.5-35b-a3b
```

<details>
<summary>nim run qwen3.5-35b-a3b</summary>

![nim pull qwen3.5-35b-a3b](./pic/ngc-nim-run.png)

</details>
