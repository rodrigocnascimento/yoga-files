# 🧘 Yoga Files - Guia de Uso (End-to-End)

Este guia cobre desde a instalacao ate o uso diario de todas as ferramentas do `yoga-files`.

## Instalar

Requisito: `zsh`.

```bash
curl -fsSL https://raw.githubusercontent.com/rodrigocnascimento/yoga-files/main/install.sh | zsh
```

Depois, recarregue o shell (ou abra um terminal novo):

```bash
source ~/.zshrc
```

Checklist rapido:

```bash
yoga-doctor
yoga-status
```

## Atualizar

```bash
yoga-update
```

## Estrutura (onde fica o que)

- Home: `~/.yoga`
- Config: `~/.yoga/config.yaml`
- Git profiles: `~/.yoga/config/git-profiles.yaml`
- Plugins: `~/.yoga/plugins/<nome>/plugin.zsh`
- Templates: `~/.yoga/templates/`
- Logs (opt-in): `~/.yoga/logs/yoga.jsonl`

## Comandos (todas as ferramentas)

### `yoga`

Abre o dashboard interativo.

```bash
yoga
```

### `yoga-status`

Mostra um status resumido do ambiente (binarios, configuracao e caminhos).

```bash
yoga-status
```

### `yoga-doctor`

Diagnostico: verifica dependencias e mostra o que esta faltando.

```bash
yoga-doctor
yoga-doctor --full
yoga-doctor --report
```

### `yoga-update`

Atualiza o `~/.yoga` via git e tenta atualizar ferramentas (quando disponivel).

```bash
yoga-update
```

### `yoga-ai`

Assistente de IA no terminal. Provider e modelo vem do `config.yaml`.

```bash
yoga-ai help "como listar arquivos modificados no git"
yoga-ai fix "git comit -m 'msg'"
yoga-ai cmd "achar arquivos grandes no repo"
yoga-ai explain "tar -czf backup.tgz --exclude=node_modules ."
yoga-ai debug "TypeError: Cannot read property 'map' of undefined"
yoga-ai code "funcao TypeScript para validar email"
yoga-ai learn "useEffect dependencies"
yoga-ai "pergunta livre"
```

Atalhos:

- `yai` -> `yoga-ai`

Config (exemplo):

```yaml
preferences:
  ai_provider: "openai"   # openai | copilot

tools:
  ai:
    model: "gpt-4"
```

Notas:

- `openai` requer `OPENAI_API_KEY`.
- `copilot` usa `gh copilot` (GitHub CLI) e requer login no `gh`.

### `asdf-menu`

Menu interativo do ASDF.

```bash
asdf-menu
```

### `git-wizard`

Wizard de perfis Git (personal/work). Configura e alterna identidade global/local.

```bash
git-wizard
git-wizard list
git-wizard current
git-wizard add
git-wizard switch
git-wizard repo
```

### `yoga-create` / `create_js_project`

Cria projetos (templates locais) com comandos conhecidos.

```bash
yoga-create react my-app
yoga-create node my-api
yoga-create next my-site
yoga-create ts my-lib
yoga-create express my-server

create_js_project react my-app
```

Community templates (curated):

```bash
yoga-templates list
yoga-templates show nextjs

yoga-create community nextjs my-site
yoga-create community react-vite my-app
```

### `yoga-plugin`

Sistema de plugins (modulos independentes).

```bash
yoga-plugin list

# install from a git repo (plugin must provide plugin.zsh at repo root)
yoga-plugin install my-plugin https://github.com/user/my-plugin.git

# enable/disable (writes into config.yaml -> plugins.enabled)
yoga-plugin enable my-plugin
yoga-plugin disable my-plugin
```

Como um plugin funciona:

- Arquivo: `~/.yoga/plugins/<nome>/plugin.zsh`
- Opcional: funcao `yoga_plugin_init <nome>` (executa apos carregar)

## Editor (LazyVim)

O installer clona o starter do LazyVim e copia overlays do yoga-files:

- Overlays: `~/.yoga/editor/nvim/`
- Destino: `~/.config/nvim/`

Plugins adicionais do yoga-files:

- `editor/nvim/lua/plugins/yoga-js.lua` (Biome/TS)
- `editor/nvim/lua/plugins/yoga-ai.lua` (atalhos para `yoga-ai`)

## Observabilidade (opt-in)

Por padrao fica desligado.

```yaml
observability:
  enabled: false
```

Quando ligado, escreve logs minimos em `~/.yoga/logs/yoga.jsonl`.

## Desinstalar

Remove a pasta e as linhas no `~/.zshrc`.

```bash
rm -rf ~/.yoga
```

## Release

Checklist: `docs/RELEASE_CHECKLIST.md`
