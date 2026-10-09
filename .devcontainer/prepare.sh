#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p .codespaces-local/data
chmod 700 .codespaces-local
if [[ ! -f .codespaces-local/runtime.env ]]; then
  umask 077
  password=$(od -An -N24 -tx1 /dev/urandom | tr -d ' \n')
  printf 'POSTGRES_PASSWORD=%s\n' "$password" > .codespaces-local/runtime.env
fi
if ! git check-ignore -q .codespaces-local/runtime.env; then
  printf '\n/.codespaces-local/\n' >> .git/info/exclude
fi
printf '准备完成。先检查 GitHub Codespaces 免费额度，再执行：\n'
printf 'bash .devcontainer/start.sh\n'
