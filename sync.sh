#!/bin/bash

# Obsidian Vault 自动同步脚本
# 每5分钟检查一次，有新文件自动提交推送

VAULT_DIR="/root/.openclaw/workspace/obsidian-vault"
cd "$VAULT_DIR" || exit 1

# 检查是否有新文件或修改
if [[ -n $(git status --porcelain) ]]; then
    # 添加所有更改
    git add -A
    
    # 获取当前时间
    DATE=$(date "+%Y-%m-%d %H:%M:%S")
    
    # 提交
    git commit -m "更新知识库 $DATE"
    
    # 推送
    git push origin main
    
    echo "[$(date)] 已同步到 GitHub"
else
    echo "[$(date)] 无新内容"
fi
