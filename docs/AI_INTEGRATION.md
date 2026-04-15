# AI Integration

This doc explains the current AI integration shipped in yoga-files.

## Requirements

- `curl`
- `jq`
- API key for at least one provider:
  - `GEMINI_API_KEY` for Google Gemini
  - `OPENAI_API_KEY` for OpenAI
  - GitHub CLI (`gh`) authenticated for Copilot

Optional:

- Ollama running locally for `ollama` provider

Example (zsh):

```bash
export GEMINI_API_KEY="..."
# or
export OPENAI_API_KEY="..."
```

## Yoga AI Terminal Helper

The terminal helper has two entry points:

- **`yoga ai ask "<question>"`** — via the main CLI (`bin/yoga`, requires daemon)
- **`yoga-ai <mode> "<query>"`** — standalone binary (`bin/yoga-ai`, works without daemon)

The standalone helper lives at `core/ai/yoga-ai-terminal.sh` and provides a single entrypoint function.

Commands (standalone `yoga-ai`):

```bash
yoga-ai help "describe the command I need"
yoga-ai fix "git comit -m 'msg'"
yoga-ai cmd "generate a safe command to ..."
yoga-ai explain "tar -czf archive.tgz ."
yoga-ai debug "TypeError: ..."
yoga-ai optimize "optimize this query ..."
yoga-ai code "TypeScript function to ..."
yoga-ai learn "topic"
yoga-ai "freeform question"
```

Commands (via main CLI, requires daemon):

```bash
yoga ai ask "how to list open ports"
```

## Config

The model and provider are read from `config.yaml` when present:

- `preferences.ai_provider` (supported: `ollama`, `openai`, `gemini`, `copilot`)
- `tools.ai.model` (default depends on provider: `llama3.2` for ollama, `gpt-4` for openai)

Note: The daemon module and terminal module have **different default providers**:
- **Daemon** (`bin/yoga` via `yoga ai ask`): defaults to `ollama`/`llama3.2`
- **Terminal helper** (`bin/yoga-ai`): defaults to `openai`/`gpt-4`
- **Config default** (`config.yaml`): `gemini`/`gemini-1.5-pro`

## Safety Notes

- Some modes may offer to execute the suggested command. Review carefully before confirming.
- Never paste secrets into prompts (API keys, tokens, private repo URLs with credentials).

## Providers

Configured in `config.yaml`:

- `preferences.ai_provider`:
  - `ollama` — Local AI via Ollama (daemon default)
  - `openai` — OpenAI GPT-4 (terminal helper default)
  - `gemini` — Google Gemini
  - `copilot` — GitHub Copilot (requires `gh copilot`)
- `tools.ai.model`: model name for the active provider

Notes:

- `ollama` provider runs models locally via `http://localhost:11434`
- `copilot` provider uses `gh copilot` under the hood and requires you to be authenticated in GitHub CLI.
