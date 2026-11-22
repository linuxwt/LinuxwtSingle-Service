# LiteLLM + Claude Code Router (CCR) 部署模板

通过 LiteLLM 把自建的 vLLM 网关包装成 OpenAI/Anthropic 兼容接口，
再用 CCR (claude-code-router) 让 Claude Code 走本地模型。

```
Claude Code ──► CCR (127.0.0.1:3456) ──► LiteLLM (127.0.0.1:4000) ──► 上游 vLLM 网关
```

## 文件说明

| 文件 | 作用 | 需要改 |
|---|---|---|
| `docker-compose.yaml` | LiteLLM 容器编排 | 一般不用改 |
| `config.yaml` | LiteLLM 模型路由配置 | ✅ 网关地址、模型名 |
| `.env.example` | 环境变量模板 | ✅ 复制为 `.env` 填真实 key |
| `ccr-config.json` | CCR 路由配置 | ✅ LiteLLM master key、模型名 |
| `ccr-setup.sh` | CCR 一键安装脚本 | 可选 |

## 部署步骤

1. **准备目录**（如 `/opt/litellm-ccr`）：
   ```bash
   mkdir -p /opt/litellm-ccr && cd /opt/litellm-ccr
   # 把本目录 5 个文件传上来（docker-compose.yaml / config.yaml / .env.example / ccr-config.json / ccr-setup.sh）
   ```

2. **配置 LiteLLM**：
   ```bash
   cp .env.example .env
   # 编辑 .env：填 GW_API_KEY（上游网关凭证）、LITELLM_MASTER_KEY（openssl rand -hex 32 生成）
   # 编辑 config.yaml：所有 <YOUR_*> 占位符替换成真实网关地址和模型名
   ```

3. **启动 LiteLLM**：
   ```bash
   docker compose up -d
   docker compose logs -f litellm    # 看到 "Application startup complete" 即可
   ```

4. **验证 LiteLLM**：
   ```bash
   curl http://127.0.0.1:4000/health/liveliness
   curl http://127.0.0.1:4000/v1/models -H "Authorization: Bearer $LITELLM_MASTER_KEY"
   ```

5. **配置 CCR**：
   ```bash
   # 编辑 ccr-config.json：把 <YOUR_LITELLM_MASTER_KEY> 和第 3 步的模型名填进去
   bash ccr-setup.sh
   ```

6. **使用**：
   ```bash
   ccr code          # 启动 Claude Code
   # 进入后切换模型：
   /model litellm,<模型名1>
   /model litellm,<模型名2>
   ```

## 关键坑位

- **`api_base` 必须带协议和 `/v1` 后缀**，如 `http://10.0.0.5:3005/v1`
- **`use_chat_completions_api: true` 不能省**：Claude Code 的 messages 请求默认会被 LiteLLM
  翻译成 OpenAI Responses API（`POST /v1/responses`），只实现 `/chat/completions` 的网关
  会报 `Invalid URL (POST /v1/responses)`
- **CCR 固定 1.0.73**：该版本读 `config.json`，新版改用 SQLite，脚本里已锁版本
- **启动 ccr code 前清掉干扰变量**：`ANTHROPIC_BASE_URL` 等（ccr-setup.sh 第 4 步已处理）
- 容器内访问宿主机网关时，如网关跑在 docker 宿主机上，`api_base` 可用
  `host.docker.internal` 代替内网 IP（compose 里已配 `extra_hosts`）

## 安全提醒

- `.env` 和填好真实值的 `config.yaml` / `ccr-config.json` **只留服务器，不进 git**
- 本仓库里的都是模板，`<YOUR_*>` 占位符在部署时替换
