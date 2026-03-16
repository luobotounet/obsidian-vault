---
name: knowledge-base
description: |
  知识库管理技能。自动将团队讨论方案存到 Obsidian vault，并同步到 GitHub。
  支持存储方案、查询调取、自动同步。
---

# 知识库管理技能

## 概述

本技能负责管理团队知识库，包括：
- 将讨论方案自动存到 Obsidian vault
- 查询/调取历史方案
- 自动同步到 GitHub

## Vault 配置

**Vault 路径**：`./obsidian-vault/`（各 agent 工作空间共享）

**Git 远程仓库**：`https://github.com/luobotounet/obsidian-vault.git`

**自动同步**：每 5 分钟通过 cron job 自动 push 到 GitHub

## 使用方式

### 存储方案

当讨论完成后，自动将方案存到 vault：

```markdown
# [主题名称]

> 创建时间：YYYY-MM-DD
> 来源：团队头脑风暴讨论

## 思考者观点
[内容...]

## 评审官评估
[内容...]

## 方案师建议
[内容...]

## 综合建议
[内容...]

*Tags: #标签1 #标签2*
```

**文件命名**：`<主题>.md`

### 查询方案

在群里直接说关键词查询：
- "查一下 + 关键词" → 如 "查一下销量提升的方案"
- "搜索 + 关键词" → 如 "搜索 营销 讨论"
- "找找 + 关键词" → 如 "找找之前的策略"

### 示例对话

```
用户：讨论一下如何提升产品销量
机器人：→ 发起团队讨论 → 输出方案 → 自动存到知识库

用户：查一下销量提升的方案
机器人：→ 搜索 vault → 展示历史方案
```

## 配置要求

### 1. 共享 Vault

各 agent 工作空间通过符号链接共享同一个 vault：

```bash
# 创建符号链接
ln -sf /root/.openclaw/workspace/obsidian-vault /root/.openclaw/workspace-<agent>/obsidian-vault
```

### 2. Git 配置

每个工作空间需要配置 remote：

```bash
git remote add origin https://github.com/luobotounet/obsidian-vault.git
```

### 3. Cron 同步

自动同步脚本：`/root/.openclaw/workspace/obsidian-vault/sync.sh`

Crontab 配置：
```
*/5 * * * * /root/.openclaw/workspace/obsidian-vault/sync.sh >> /tmp/obsidian-sync.log 2>&1
```

## 同步状态

- **服务器 → GitHub**：每 5 分钟自动推送
- **GitHub → 本地**：用户在 Obsidian 中手动 pull 或配置自动 pull

## 本地同步（用户操作）

Obsidian 安装 Git 插件后，配置：
```json
{
  "pullOnSave": true,
  "autoCommitInterval": 5,
  "commitMessage": "auto sync"
}
```

## 文件列表

当前 vault 包含：
- 如何提升产品销量.md
- GEO系统开发-团队头脑风暴.md
- GEO系统技术实现方案.md

## 注意事项

1. 文件名使用中文，便于中文搜索
2. 包含 Tags 方便分类查询
3. 自动同步有 5 分钟延迟，急需同步可手动运行 `sync.sh`
