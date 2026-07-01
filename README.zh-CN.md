<p align="center">
  <img src="assets/banner.png" alt="Hermes Lite" width="100%">
</p>

# Hermes Lite ☤

**[Hermes Agent](https://github.com/NousResearch/hermes-agent) 的轻量级分支** —— 精简为仅保留本地 CLI + TUI 界面。所有多平台消息网关代码（Telegram、Discord、Slack、WhatsApp 等）以及 Electron 桌面应用和 Web 仪表盘均已移除。

支持任意模型 —— [Nous Portal](https://portal.nousresearch.com)、OpenRouter、OpenAI、自定义端点，以及[其他众多提供商](https://hermes-agent.nousresearch.com/docs/integrations/providers)。

<table>
<tr><td><b>真正的终端界面</b></td><td>完整的 TUI，支持多行编辑、斜杠命令自动补全、对话历史、中断重定向和流式工具输出。</td></tr>
<tr><td><b>闭环学习</b></td><td>代理管理记忆并定期自我提醒。复杂任务后自动创建技能。技能在使用中自我改进。FTS5 会话搜索配合 LLM 摘要实现跨会话回溯。</td></tr>
<tr><td><b>定时自动化</b></td><td>内置 cron 调度器。日报、夜间备份、周审计 —— 全部用自然语言描述，无人值守运行。</td></tr>
<tr><td><b>委派与并行</b></td><td>生成隔离子代理处理并行工作流。编写 Python 脚本通过 RPC 调用工具，将多步管道压缩为零上下文开销的轮次。</td></tr>
<tr><td><b>随处运行</b></td><td>多种终端后端 —— 本地、Docker、SSH、Singularity、Modal 和 Daytona。</td></tr>
<tr><td><b>研究就绪</b></td><td>批量轨迹生成、轨迹压缩 —— 用于训练下一代工具调用模型。</td></tr>
</table>

---

## 快速安装

```bash
pip install hermes-lite[all]
```

> **注意：** 这是 Lite 分支。上游 [Hermes Agent](https://github.com/NousResearch/hermes-agent) 包含多平台消息（Telegram、Discord、Slack、WhatsApp 等）、Web 仪表盘和 Electron 桌面应用。

---

## Lite 版本移除了什么

| 功能 | 状态 |
|------|------|
| Telegram 网关 | 已移除 |
| Discord 网关 | 已移除 |
| Slack 网关 | 已移除 |
| WhatsApp 网关 | 已移除 |
| Signal 网关 | 已移除 |
| Web 仪表盘 | 已移除 |
| Electron 桌面应用 | 已移除 |
| 可选技能 | 已移除 |
| CLI + TUI | **保留** |
| 核心工具 | **保留** |
| Cron 调度器 | **保留** |
| 技能系统 | **保留** |
| 插件系统 | **保留** |
| 记忆提供商 | **保留** |

---

## 快速入门

```bash
hermes              # 交互式 CLI —— 开始对话
hermes model        # 选择 LLM 提供商和模型
hermes tools        # 配置启用的工具
hermes config set   # 设置单个配置项
hermes setup        # 运行完整设置向导（一次性配置所有内容）
hermes update       # 更新到最新版本
hermes doctor       # 诊断问题
```

---

## 文档

请参阅上游 [Hermes Agent 文档](https://hermes-agent.nousresearch.com/docs/) 了解使用指南。注意：任何涉及消息平台、Web 仪表盘或桌面应用的文档均不适用于此 Lite 分支。

---

## 许可证

MIT —— 与上游 [Hermes Agent](https://github.com/NousResearch/hermes-agent) 相同。
