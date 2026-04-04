# ASDF Guide

This guide documents how yoga-files uses ASDF to manage tool versions.

## What ASDF Does Here

- Installs language runtimes (example: nodejs, python)
- Pins versions per project via `.tool-versions`
- Lets you switch versions quickly (global vs local)

## Quick Checks

```bash
command -v asdf
asdf --version
```

If `asdf` is not found, ensure your shell loads it (see `init.sh` and your shell rc).

## Core Commands

```bash
# list plugins
asdf plugin list

# add a plugin
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

# list available versions
asdf list-all nodejs

# install a version
asdf install nodejs 20.11.1

# set a global version
asdf global nodejs 20.11.1

# set a local (project) version
asdf local nodejs 20.11.1

# show active version in current directory
asdf current nodejs
```

## Project Pinning With .tool-versions

Example `.tool-versions`:

```text
nodejs 20.11.1
python 3.11.7
```

Commit `.tool-versions` with your project to make CI and teammates match your runtime.

## Troubleshooting

- `asdf: command not found`
  - Ensure your shell rc sources ASDF (often: `. "$HOME/.asdf/asdf.sh"`)
  - Restart the shell or run `source ~/.zshrc`

- Version not switching
  - Verify you are in the directory that contains `.tool-versions`
  - Run `asdf current` and confirm the plugin is installed

## Yoga Wrapper Commands

yoga-files provides convenient wrapper commands for common ASDF operations.

### yoga asdf (Interactive Manager)

Opens the interactive ASDF menu (same as `asdf-menu`):

```bash
yoga asdf
```

### yoga remove (Uninstall a Runtime)

Completely removes a language runtime managed by ASDF. This includes:

- All installed versions of the language
- The ASDF plugin itself
- Any entries for the language in `~/.tool-versions`

```bash
# Remove Go
yoga remove go

# Remove Python
yoga remove python

# Using the alias
asdf-remove go
```

The command asks for confirmation before proceeding.

#### Interactive version selection

When multiple versions are installed, `yoga remove` lists them and lets you
choose which one to uninstall. You can also type **`all`** to remove every
version, the plugin, and the `~/.tool-versions` entry in one step:

```text
Installed versions for golang:
  1.21.0
  1.22.1
  all  (remove everything + plugin)

Version to remove: all
```

#### Ghost state handling

If a plugin exists but has no versions installed (for example, after manually
running `asdf uninstall`), `yoga remove` detects this and offers to remove the
plugin entirely instead of just exiting:

```text
No versions installed for 'golang', but the plugin still exists.
Remove plugin entirely? (y/n):
```

#### Post-uninstall cleanup

After uninstalling the last remaining version, `yoga remove` automatically
offers to remove the plugin and clean `~/.tool-versions` so no stale entries
are left behind.

### Aliases (from config.yaml)

| Alias | Command | Description |
|-------|---------|-------------|
| `asdf-menu` | `yoga asdf` | Interactive ASDF manager |
| `asdf-list` | `asdf list` | List installed versions |
| `asdf-install` | `asdf install` | Install a version |
| `asdf-remove` | `yoga remove` | Uninstall a runtime completely |
| `asdf-update` | ASDF update | Update ASDF and plugins |
