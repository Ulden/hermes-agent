<p align="center">
  <img src="assets/banner.png" alt="Hermes Lite" width="100%">
</p>

# Hermes Lite ☤

**A lightweight fork of [Hermes Agent](https://github.com/NousResearch/hermes-agent)** — stripped down to only local CLI + TUI interfaces. All multi-platform messaging gateway code (Telegram, Discord, Slack, WhatsApp, etc.) has been removed, along with the Electron desktop app and web dashboard.

Use any model you want — [Nous Portal](https://portal.nousresearch.com), OpenRouter, OpenAI, your own endpoint, and [many others](https://hermes-agent.nousresearch.com/docs/integrations/providers).

<table>
<tr><td><b>A real terminal interface</b></td><td>Full TUI with multiline editing, slash-command autocomplete, conversation history, interrupt-and-redirect, and streaming tool output.</td></tr>
<tr><td><b>A closed learning loop</b></td><td>Agent-curated memory with periodic nudges. Autonomous skill creation after complex tasks. Skills self-improve during use. FTS5 session search with LLM summarization for cross-session recall.</td></tr>
<tr><td><b>Scheduled automations</b></td><td>Built-in cron scheduler. Daily reports, nightly backups, weekly audits — all in natural language, running unattended.</td></tr>
<tr><td><b>Delegates and parallelizes</b></td><td>Spawn isolated subagents for parallel workstreams. Write Python scripts that call tools via RPC, collapsing multi-step pipelines into zero-context-cost turns.</td></tr>
<tr><td><b>Runs anywhere</b></td><td>Multiple terminal backends — local, Docker, SSH, Singularity, Modal, and Daytona.</td></tr>
<tr><td><b>Research-ready</b></td><td>Batch trajectory generation, trajectory compression for training the next generation of tool-calling models.</td></tr>
</table>

---

## Quick Install

```bash
pip install hermes-lite[all]
```

> **Note:** This is the lite fork. The upstream [Hermes Agent](https://github.com/NousResearch/hermes-agent) includes multi-platform messaging (Telegram, Discord, Slack, WhatsApp, etc.), a web dashboard, and an Electron desktop app.

---

## What was removed in the lite version

| Feature | Status |
|---------|--------|
| Telegram gateway | Removed |
| Discord gateway | Removed |
| Slack gateway | Removed |
| WhatsApp gateway | Removed |
| Signal gateway | Removed |
| Web dashboard | Removed |
| Electron desktop app | Removed |
| Optional skills | Removed |
| CLI + TUI | **Kept** |
| Core tools | **Kept** |
| Cron scheduler | **Kept** |
| Skills system | **Kept** |
| Plugins system | **Kept** |
| Memory providers | **Kept** |

---

## Documentation

See the upstream [Hermes Agent documentation](https://hermes-agent.nousresearch.com/docs/) for usage guides. Note that any documentation referencing messaging platforms, the web dashboard, or the desktop app does not apply to this lite fork.

---

## License

MIT — same as upstream [Hermes Agent](https://github.com/NousResearch/hermes-agent).
