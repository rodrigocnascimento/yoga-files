# Release Checklist

This checklist is meant to keep yoga-files releases consistent.

## Before Tagging

- [ ] `./tests/run-all.sh` passes locally
- [ ] `.github/workflows/ci.yml` is green for the default branch
- [ ] `README.md` install command is correct (`curl ... | zsh`)
- [ ] `docs/SETUP_GUIDE.md` matches the installer behavior
- [ ] No secrets committed (API keys, tokens)

## Versioning

- [ ] Update `CHANGELOG.md` (move items from Unreleased into a version section)
- [ ] Tag the release (semver): `vMAJOR.MINOR.PATCH`

## After Tagging

- [ ] Verify installation from scratch on macOS
- [ ] Verify installation from scratch on Linux
