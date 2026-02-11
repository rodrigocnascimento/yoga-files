# AI Integration

This doc explains the current AI integration shipped in yoga-files.

## Requirements

- `curl`
- `jq`
- `OPENAI_API_KEY` in your environment

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

## Safety Notes

- Some modes may offer to execute the suggested command. Review carefully before confirming.
- Never paste secrets into prompts (API keys, tokens, private repo URLs with credentials).
