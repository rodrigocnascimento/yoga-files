# Troubleshooting

## Shell Does Not Load Yoga

- Ensure your shell rc sources `~/.yoga/init.sh`
- Reload:

```bash
source ~/.zshrc
```

## ASDF Not Found

- Verify:

```bash
ls -la "$HOME/.asdf/asdf.sh"
```

- Ensure your rc file sources ASDF.

## Neovim Missing

```bash
command -v nvim
nvim --version
```

If missing, install Neovim (or rerun the installer).

## AI Commands Fail

- Ensure `OPENAI_API_KEY` is set
- Ensure `jq` is installed

```bash
echo "$OPENAI_API_KEY" | wc -c
command -v jq
```

## Git Profile Wizard Issues

- Ensure the config exists:

```bash
ls -la ~/.yoga/config/git-profiles.yaml
```

If not, run the wizard once to initialize it.
