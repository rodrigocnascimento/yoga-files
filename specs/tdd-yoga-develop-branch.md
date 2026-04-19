# TDD: Develop Branch Workflow

## Objective & Scope

**What:** Establish a `develop` branch as the stable base for ongoing development, separating development from production releases on `main`.

**Why:** Current setup causes:
- `yoga update` conflicts in dev environment
- No stable channel for testing before release
- Risk of pushing unfinished work to production

## Proposed Technical Strategy

### Branch Structure

| Branch | Purpose | Protected? |
|--------|---------|------------|
| `main` | Production releases | Yes |
| `develop` | Integration branch | No |
| `feat/*` | Feature development | No |
| `fix/*` | Bug fixes | No |

### Workflow

1. Create branch from `develop`
2. Work on feature/fix
3. Run tests
4. PR → `develop` for integration
5. PR → `main` for release

### Developer Setup

- `~/.yoga`: Stays on `main` → `yoga update` works normally
- `~/code/yoga-files`: Work on branches from `develop`

## Implementation Plan

1. ✅ Create `develop` branch from `main`
2. ✅ Update CI to run on `develop` branch  
3. Document in README (future)

## Path Resolution

- This TDD document: `specs/tdd-yoga-develop-branch.md`
- CI: `.github/workflows/ci.yml`