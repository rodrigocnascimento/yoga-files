# AI Integration

This doc explains the current AI integration shipped in yoga-files.

## Requirements

- `curl`
- `jq`
- `OPENAI_API_KEY` in your environment

Optional:

- GitHub CLI (`gh`) if you want to use `preferences.ai_provider: "copilot"`
- `preferences.ai_provider` in `config.yaml` (currently only `openai` is supported)

Example (zsh):

```bash
export OPENAI_API_KEY="..."
```

## Yoga AI Terminal Helper

The terminal helper lives at `core/ai/yoga-ai-terminal.sh` and provides a single entrypoint function.

Commands:

```bash
yai help "describe the command I need"
yai fix "git comit -m 'msg'"
yai cmd "generate a safe command to ..."
yai explain "tar -czf archive.tgz ."
yai debug "TypeError: ..."
yai code "TypeScript function to ..."
yai learn "topic"
yai "freeform question"
```

## Config

The model and provider are read from `config.yaml` when present:

- `preferences.ai_provider` (supported: `openai`)
- `tools.ai.model` (default: `gpt-4`)

## Safety Notes

- Some modes may offer to execute the suggested command. Review carefully before confirming.
- Never paste secrets into prompts (API keys, tokens, private repo URLs with credentials).

## Providers

Configured in `config.yaml`:

- `preferences.ai_provider`: `openai` (default) or `copilot`
- `tools.ai.model`: model name for OpenAI (default: `gpt-4`)

Notes:

- `copilot` provider uses `gh copilot` under the hood and requires you to be authenticated in GitHub CLI.
