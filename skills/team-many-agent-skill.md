---
name: team-many-agent-skill
description: |
  创建和管理多 Agent 财税开发团队。用于在飞书群中建立 AI 团队协作：
  包括领导者、思考者、评审官、方案师、财税专家、编程专家、审核员。
  当用户要求创建多 Agent 团队、团队协作、头脑风暴、任务分配执行时触发此技能。
---

# 财税开发多 Agent 团队技能

## 概述

本技能用于在 OpenClaw 中创建和管理一个专业的财税开发团队，包含 7 个独立 Agent，协作完成财税功能的开发任务。

## 团队成员

| Agent ID | 角色 | 职责 |
|----------|------|------|
| leader | 领导者 | 主持头脑风暴、拍板定案、分配任务、验收结果、向你汇报 |
| thinker | 思考者 | 创意发散、提供多种思路和想法 |
| reviewer | 评审官 | 评估方案可行性、识别风险 |
| planner | 方案师 | 整理方案、输出详细实施计划 |
| tax_expert | 财税专家 | 财税专业审核、确保合规性 |
| coder | 编程专家 | 执行开发、代码实现 |
| auditor | 审核员 | 检查测试、验证执行结果 |

## 工作流程

```
1. 你下达任务 → Leader 接收
         ↓
2. Leader 主持头脑风暴（Thinker 出主意、Reviewer 评估）
         ↓
3. Planner 整理方案 → TaxExpert 专业审核
         ↓
4. Leader 拍板定方案
         ↓
5. Leader 分配任务给 Coder 执行
         ↓
6. Auditor 检查测试 → Coder 修复问题
         ↓
7. Leader 验收通过 → 向你汇报最终结果
```

## 创建团队步骤

### 步骤 1：创建独立 Agent

使用 `openclaw agents add` 创建 7 个 Agent：

```bash
# 创建领导者
openclaw agents add --name "财税团队领导者" --id leader

# 创建思考者
openclaw agents add --name "财税团队思考者" --id thinker

# 创建评审官
openclaw agents add --name "财税团队评审官" --id reviewer

# 创建方案师
openclaw agents add --name "财税团队方案师" --id planner

# 创建财税专家
openclaw agents add --name "财税团队财税专家" --id tax_expert

# 创建编程专家
openclaw agents add --name "财税团队编程专家" --id coder

# 创建审核员
openclaw agents add --name "财税团队审核员" --id auditor
```

### 步骤 2：配置 Agent 个性化

为每个 Agent 设置专属 prompt（通过 system prompt 或 AGENTS.md）：

**leader.md** - 领导者:
- 稳重、有决策力
- 主持会议时公平听取各方意见
- 最终拍板并对结果负责

**thinker.md** - 思考者:
- 思维活跃、创意多多
- 善于从不同角度思考问题
- 产出多种可行方案

**reviewer.md** - 评审官:
- 严谨、善于发现问题
- 评估方案的可行性和风险
- 提出改进建议

**planner.md** - 方案师:
- 条理清晰、善于归纳
- 把讨论结果整理成详细方案
- 输出可执行的操作步骤

**tax_expert.md** - 财税专家:
- 财税知识丰富
- 审核方案的合规性
- 确保符合税法和财务规范

**coder.md** - 编程专家:
- 技术能力强
- 执行具体的开发任务
- 产出高质量代码

**auditor.md** - 审核员:
- 细心、严格
- 检查执行结果
- 确保任务真正完成且无误

### 步骤 3：加入飞书群

1. 把 7 个 Agent 都加入到同一个飞书群
2. 或通过 `sessions_spawn` 运行时指定 thread 让他们协作

## 任务执行示例

当你给团队下达任务时：

```
"开发一个增值税发票自动识别和验证的功能"
```

**Leader 会这样执行：**

1. **召集团队**：请 Thinker 提供思路、Reviewer 评估可行性
2. **整理方案**：让 Planner 输出方案，TaxExpert 审核合规性
3. **拍板定案**：选择最优方案
4. **分配任务**：让 Coder 开发，让 Auditor 验收
5. **汇报结果**：完成后向你汇报

## 关键原则

- **Leader 是核心**：所有任务通过 Leader 协调，其他 Agent 不直接向你汇报
- **专业分工**：财税问题必须经过 TaxExpert 审核
- **严格验收**： Auditor 测试通过才算完成
- **持续改进**：如果执行有问题，返回上一步重新讨论

## 快捷命令

查看团队状态：
```bash
openclaw agents list
```

查看某个 Agent 的对话：
```bash
openclaw sessions --agent leader
```

重启团队任务：
```bash
# Leader 重新开始
openclaw agent --agent leader --message "重新执行上一个任务"
```
