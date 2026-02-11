# Git Profiles

Yoga-files includes a Git profile wizard to help switch identities across personal/work repos.

## Wizard Script

- Script: `core/git/git-wizard.sh`
- Config file: `~/.yoga/config/git-profiles.yaml`

## Usage

Run interactively:

```bash
bash core/git/git-wizard.sh
```

Or use subcommands:

```bash
bash core/git/git-wizard.sh list
bash core/git/git-wizard.sh current
bash core/git/git-wizard.sh add
bash core/git/git-wizard.sh switch
bash core/git/git-wizard.sh repo
```

## Notes

- Global profile changes update `git config --global user.name` and `user.email`.
- Repo-specific mode sets local config for the current repository.
