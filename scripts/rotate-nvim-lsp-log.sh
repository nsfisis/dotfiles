#!/usr/bin/env bash
set -euo pipefail

lsp_log=$(nvim --headless -c "lua io.stdout:write(vim.lsp.get_log_path())" -c "qa" 2>/dev/null)

if [[ -s "$lsp_log" ]]; then
    cp "$lsp_log" "$lsp_log.bak"
    truncate -s 0 "$lsp_log"
fi
