# Gambit Tool Mapping for Gemini CLI

Gambit skills reference Claude Code tool names. When executing skills in Gemini CLI, use these equivalents:

| Skill references | Gemini CLI equivalent |
|---|---|
| `Read` | `read_file` |
| `Write` | `write_file` |
| `Edit` | `replace` |
| `Bash` | `run_shell_command` |
| `Grep` | `grep_search` |
| `Glob` | `glob` |
| `TodoWrite` | `write_todos` |
| `Skill` | `activate_skill` |
| `WebSearch` | `google_web_search` |
| `WebFetch` | `web_fetch` |
| `Agent` / `Task` | `@generalist` |

## Subagent support

Gemini CLI supports subagents via the `@` syntax. When a skill dispatches a subagent task, use `@generalist` with the full prompt from the skill's instructions.
