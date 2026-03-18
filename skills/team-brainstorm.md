---
name: team-brainstorm
description: |
  多 Agent 头脑风暴团队协作技能。适用于飞书群聊场景，
  主 Agent 自动调用 7 个子 Agent（领导者、思考者、评审官、方案师、财税专家、编程专家、审核员）
  进行团队头脑风暴，汇总讨论结果后回复。
  当用户在群里发起头脑风暴、讨论、团队分析等任务时触发此技能。
---

# 多 Agent 头脑风暴团队技能

## 概述

本技能使主 Agent 能够在飞书群聊中自动调用多 Agent 团队进行头脑风暴，模拟真实团队讨论流程，最终输出整合后的讨论结果。

## 团队成员

| Agent ID | 角色 | 工作空间 | 职责 |
|----------|------|---------|------|
| team-leader | 领导者 | workspace-team-leader | 主持会议、分配任务、统筹协调、汇总结果 |
| team-thinker | 思考者 | workspace-team-thinker | 创意发散、提供多种思路、多角度分析 |
| team-reviewer | 评审官 | workspace-team-reviewer | 评估方案可行性、识别风险点、提出改进建议 |
| team-planner | 方案师 | workspace-team-planner | 整理思路、输出详细实施方案、规划执行步骤 |
| team-tax-expert | 财税专家 | workspace-team-tax-expert | 财税合规审核、确保方案符合法规 |
| team-coder | 编程专家 | workspace-team-coder | 技术实现评估、可行性分析、代码开发 |
| team-auditor | 审核员 | workspace-team-auditor | 检查验收、验证结果、确保任务完成 |

## 触发条件

当用户消息包含以下关键词时，自动启用团队头脑风暴：

- "讨论"
- "头脑风暴"
- "团队"
- "分析一下"
- "有什么想法"
- "怎么看"
- "分析问题"
- "给点意见"
- "怎么看待"
- "有什么建议"
- "如何提升"
- "怎么解决"

## 工作流程

```
用户发送任务
      ↓
主 Agent 接收任务，分析复杂度
      ↓
判断是否需要团队协作（复杂任务启用）
      ↓
按需调用团队成员：
  - thinker 提供思路
  - reviewer 评估风险
  - planner 制定方案
  - tax_expert 审核合规
  - coder 评估技术可行性
  - auditor 验证结果
      ↓
leader 汇总讨论结果
      ↓
输出格式化的团队观点
```

## 调用方式

**重要：必须使用 `sessions_spawn` 工具调用团队成员，不要使用 `subagents` 工具**

### 方式一：关键词自动触发

在飞书群中发送包含触发关键词的消息，主 Agent 自动启用团队讨论。

### 方式二：直接指令

```
@机器人 团队讨论 [主题]
@机器人 头脑风暴 [主题]
@机器人 分析 [主题]
```

### 代码调用示例

```javascript
// 调用思考者
sessions_spawn({
  agentId: 'team-thinker',
  runtime: 'subagent',
  task: '你是思考者，请针对"主题"给出分析'
})

// 调用评审官
sessions_spawn({
  agentId: 'team-reviewer',
  runtime: 'subagent',
  task: '你是评审官，请评估"方案"的可行性'
})

// 调用方案师
sessions_spawn({
  agentId: 'team-planner',
  runtime: 'subagent',
  task: '你是方案师，请制定详细实施方案'
})
```

## 输出格式

团队讨论后，按以下格式输出，**完整展示每个成员的观点**：

```
📋 团队讨论结果：[主题]

━━━━━━━━━━━━━━━━━━

【💡 思考者观点】
[详细分析角度1]
[详细分析角度2]
[详细分析角度3]

【⚖️ 评审官评估】
[可行性分析]
[风险点1]
[风险点2]
[风险点3]

【📝 方案师建议】
[方案要点1]
[方案要点2]
[方案要点3]

【💰 财税合规】（如涉及）
[合规建议]

【💻 技术评估】（如涉及）
[技术可行性]

【🔍 审核验收】
[验收要点]

【✅ 综合建议】
[综合建议]
```

**重要**：
- 必须展示每个成员的具体观点，不要只给最终建议
- 如果某个成员未被调用，明确说明"本次未调用该角色"
- 先展示各方观点，再给综合建议

## 配置要求

### 1. Agent 配置 (openclaw.json)

确保 main Agent 配置了子 Agent 允许列表：

```json
{
  "agents": {
    "list": [
      {
        "id": "main",
        "subagents": {
          "allowAgents": [
            "team-leader",
            "team-thinker",
            "team-reviewer",
            "team-planner",
            "team-tax-expert",
            "team-coder",
            "team-auditor"
          ]
        }
      },
      { "id": "team-leader", "workspace": "/root/.openclaw/workspace-team-leader" },
      { "id": "team-thinker", "workspace": "/root/.openclaw/workspace-team-thinker" },
      { "id": "team-reviewer", "workspace": "/root/.openclaw/workspace-team-reviewer" },
      { "id": "team-planner", "workspace": "/root/.openclaw/workspace-team-planner" },
      { "id": "team-tax-expert", "workspace": "/root/.openclaw/workspace-team-tax-expert" },
      { "id": "team-coder", "workspace": "/root/.openclaw/workspace-team-coder" },
      { "id": "team-auditor", "workspace": "/root/.openclaw/workspace-team-auditor" }
    ]
  }
}
```

**关键**：必须在 main 的 `subagents.allowAgents` 中列出所有团队成员的 ID，否则无法调用。

### 2. 工作空间配置

每个子 Agent 需要有独立的工作空间：
- `/root/.openclaw/workspace-team-leader`
- `/root/.openclaw/workspace-team-thinker`
- `/root/.openclaw/workspace-team-reviewer`
- `/root/.openclaw/workspace-team-planner`
- `/root/.openclaw/workspace-team-tax-expert`
- `/root/.openclaw/workspace-team-coder`
- `/root/.openclaw/workspace-team-auditor`

每个工作空间需包含：
- `SOUL.md` - Agent 个性化配置
- `IDENTITY.md` - Agent 身份信息
- `USER.md` - 用户信息

### 3. 技能文件

在主 Agent 工作空间创建 `TEAM_BRAINSTORM.md`，定义团队协作规则。

## 使用示例

### 示例 1：简单讨论

**用户发送：**
```
讨论一下如何提升产品销量
```

**团队响应：**
```
📋 团队讨论结果：如何提升产品销量

━━━━━━━━━━━━━━━━━━

【💡 思考者观点】
- 当前市场环境下，销量提升需要从多个维度入手
- 产品定位、价格策略、渠道拓展、品牌建设...
[详细分析]

【⚖️ 评审官评估】
- 方案可行性评估
- 潜在风险：预算超支、竞品反应...
[风险提示]

【📝 方案师建议】
1. 短期：优化现有渠道促销
2. 中期：拓展线上渠道
3. 长期：品牌差异化建设
[行动计划]

【✅ 最终建议】
综合团队观点，建议优先...
```

### 示例 2：复杂问题分析

**用户发送：**
```
头脑风暴：我们公司面临的最大挑战是什么
```

**团队响应：** 多个 Agent 依次分析，最终汇总

## 注意事项

1. **必须使用 sessions_spawn**：调用团队成员必须用 `sessions_spawn` 工具，不能用 `subagents` 工具
2. **主 Agent 汇总**：所有子 Agent 的响应由主 Agent 汇总后输出，不是各自独立发言
3. **记忆隔离**：每个子 Agent 有独立工作空间，互不干扰
4. **按需调用**：不是每次都调用全部 7 个 Agent，根据任务复杂度选择调用
5. **结果整合**：主 Agent 负责整合各方观点，形成最终建议
6. **完整展示观点**：输出时必须展示每个成员的具体观点，不要只给最终建议
7. **自动存知识库**：讨论完成后，自动将方案存到 Obsidian vault

## 知识库集成

> 详细配置见 `skills/knowledge-base/SKILL.md`

讨论完成后，使用知识库技能自动存储方案到 vault 并同步到 GitHub。

## 扩展

如需每个 Agent 独立在群里发言，需要：
1. 在飞书开放平台创建 7 个独立应用
2. 为每个应用配置机器人权限
3. 在 OpenClaw 中配置 7 个飞书通道
4. 将每个 Agent 绑定到对应通道
