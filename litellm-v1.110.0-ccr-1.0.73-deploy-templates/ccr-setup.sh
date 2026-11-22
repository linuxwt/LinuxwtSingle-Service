#!/usr/bin/env bash
# 在宿主机（不是容器里）执行：bash ccr-setup.sh
# 作用：安装 claude-code-router、写入配置、重启服务
set -e

echo "== 1. 检查 node =="
node -v
NODE_MAJOR=$(node -v | sed 's/v\([0-9]*\).*/\1/')
if [ "$NODE_MAJOR" -lt 18 ]; then
  echo "!! 需要 Node 18 以上，请先升级"
  exit 1
fi

echo "== 2. 安装 CCR（固定 1.0.73，该版本用 config.json，不用 SQLite） =="
npm install -g @musistudio/claude-code-router@1.0.73

echo "== 3. 写入配置 =="
mkdir -p ~/.claude-code-router
cp "$(dirname "$0")/ccr-config.json" ~/.claude-code-router/config.json
echo "   已写入 ~/.claude-code-router/config.json"

echo "== 4. 清掉会干扰的 ANTHROPIC 变量 =="
unset ANTHROPIC_BASE_URL ANTHROPIC_AUTH_TOKEN ANTHROPIC_API_KEY ANTHROPIC_MODEL ANTHROPIC_SMALL_FAST_MODEL || true

echo "== 5. 重启 CCR 服务（监听 127.0.0.1:3456） =="
ccr restart || ccr start
sleep 2
ccr status || true

cat <<'EOF'

== 完成。启动 Claude Code：==

  ccr code

如果要临时切模型，进入 Claude Code 后用：
  /model litellm,<你的模型名1>
  /model litellm,<你的模型名2>

日志位置：
  ~/.claude-code-router/logs/ccr-*.log        （HTTP 层）
  ~/.claude-code-router/claude-code-router.log （路由决策）
EOF
#（注：内容由AI生成）
