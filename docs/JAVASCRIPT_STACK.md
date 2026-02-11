# JavaScript / TypeScript Stack

Yoga-files is optimized for JavaScript/TypeScript development.

## Tooling

- Node.js (via ASDF)
- npm
- TypeScript (`tsc`)
- tsx (run TS directly)
- Biome (format/lint)

## Recommended Global Installs

```bash
npm install -g typescript tsx @biomejs/biome
```

## Typical Project Scripts

In your `package.json`:

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "test": "vitest",
    "lint": "biome check .",
    "format": "biome format --write ."
  }
}
```

## Editor

See `docs/LAZYVIM_SETUP.md` for the Neovim baseline.
