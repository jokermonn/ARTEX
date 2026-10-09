#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ ! -f go.mod || ! -f web/package-lock.json ]]; then
  printf '请将此配置放在 mhtsec/ARTEX 的个人 fork 根目录。\n' >&2
  exit 1
fi
bash .devcontainer/prepare.sh
docker compose --env-file .codespaces-local/runtime.env -f .devcontainer/compose.yml up -d --build
printf '请在 Codespaces 的端口面板打开 8787，并确认其可见性为 Private。\n'
printf '首次进入 /setup 设置管理员密码，然后在界面填写模型配置。\n'
