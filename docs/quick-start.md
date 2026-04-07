
# Quick Start

## Step 1. Install NIM CLI

```bash
curl -fsSL https://raw.githubusercontent.com/LuYanFCP/nim-go-release/main/install.sh | bash
```


## Step 2. Launch a NIM with OpenClaw or Claude Code

```bash
nim launch openclaw
```

If you want to use wechat to send instructions to the openclaw

```bash
nim launch openclaw --with-wechat
```
The command will install OpenClaw, and in the meanwhile, it will ask the user to choose a registry and then choose a model.
In China, we distribute NIM via CND (China NIM Distributor). We have Three CNDs: ```tgcr```, ```turingcm```, ```lichan```
For __Spark NIMs__, authentication is not required from these 3 CNDs.
We recommend ```tgrc``` for its fastest downloading speed.

![Select a spark model](./pic_yy/choose-model.png)
![Install openclaw with NIM](./pic_yy/choose-registry.png)

If you want to use Claude Code as the code agent

```bash
nim launch claude-code --run 
```

For detail information, please reference ![advanced-usage.md](./advanced-usage.md)



