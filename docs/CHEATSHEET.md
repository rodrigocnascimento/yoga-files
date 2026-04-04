# 🧘 Yoga Files - Cheatsheet

Um guia rápido com todos os comandos, aliases e atalhos disponíveis no seu ambiente.

---

## 🚀 Command Center & Navegação

- **`cc`** : Abre o Command Center. Busca interativa em histórico, branches, containers, aliases e scripts. Executa o selecionado.
  - `Enter`: Executa o comando
  - `Ctrl-y`: Copia o comando
  - `Ctrl-e`: Edita o script no Neovim
  - `Ctrl-x`: Ação especial (ex: checkout na branch, exec no docker)
- **`ccp`** : "Command Center Projects". Busca por projetos em `~/code` e abre/cria uma sessão do `tmux` dedicada.
- **`goto`** : Menu rápido para pular entre seus `projects` ou diretórios recentes (`gotodir`).
- **`projects`** : Busca rápida por pastas dentro do seu `~/code`.
- **`gotodir`** : Busca rápida pelo histórico de navegação (`dirs`).
- **`take <nome>`** : Cria uma pasta e entra nela no mesmo comando (`mkdir + cd`).

---

## 🤖 Inteligência Artificial (`yoga-ai`)

- **`ai`** (ou `yai`) : Inicia o assistente de IA.
- **`ai-chat`** : Inicia uma sessão de chat contínua.
- **`ai-code <pedido>`** : Pede para a IA gerar código específico.
- **`ai-fix <comando>`** : Pede ajuda para consertar um comando que falhou.
- **`ai-explain <comando>`** : Explica o que um comando complexo faz.
- **`ai-debug <erro>`** : Analisa e debuga mensagens de erro.

---

## 🌿 Atalhos Git

- **`g`** : `git`
- **`gs`** : `git status`
- **`gc` / `gca`** : `git commit` / `git commit -a`
- **`gcm "msg"`** : `git commit -m "msg"`
- **`gp` / `gpl`** : `git push` / `git pull`
- **`gb` / `gco`** : `git branch` / `git checkout`
- **`gd`** : `git diff`
- **`gl` / `gla`** : `git log` colorido em árvore (graph).

---

## 📦 Ecossistema JS/Node & ASDF

- **`ni` / `nid` / `nig`** : `npm install` / `--save-dev` / `-g`
- **`nr <script>`** : `npm run <script>`
- **`dev` / `build` / `test`** / `start` : Atalhos rápidos para rodar scripts do `npm` ou `package.json`.
- **`tsc` / `tsx`** : Executa os compiladores TypeScript locais via `npx`.
- **`asdf-update`** : Atualiza o ASDF e todos os plugins instalados.
- **`asdf-menu`** : Abre o menu interativo para gerenciar versões.
- **`yoga asdf`** : Wrapper para o menu interativo ASDF (equivalente a `asdf-menu`).
- **`yoga remove <lang>`** : Desinstala um runtime gerenciado pelo ASDF (ex: `yoga remove go`). Remove plugin, versões e entradas do `.tool-versions`.
- **`asdf-remove <lang>`** : Alias para `yoga remove`.

---

## 🐳 Docker

- **`d` / `dc`** : `docker` / `docker-compose`
- **`dps` / `dpsa`** : `docker ps` / `docker ps -a`
- **`di`** : `docker images`
- **`dex <container>`** : Executa uma shell no container ativo.
- **`dstop` / `drm` / `drmi`** : Para/Remove todos os containers/imagens ativos.
- **`docker_nukem_confirm`** : ☢️ Destrói **TODOS** os containers, volumes, redes e imagens de uma vez.

---

## 🛠️ Utilidades de Sistema e Terminal

- **`l` / `la` / `ll`** : Variações aprimoradas e bonitas do `ls` (usando `eza` quando possível).
- **`v` / `vi` / `vim` / `nv`** : Todos abrem o seu **Neovim** (LazyVim).
- **`please`** : Equivalente a "sudo !!". Roda o último comando como administrador.
- **`pid_port <porta>`** : Retorna qual processo (PID) está rodando na porta informada.
- **`kill_port <porta>`** : Derruba (kill -9) o processo que está segurando a porta.
- **`ports`** : Lista todos os processos abertos ouvindo em portas TCP.
- **`serve <porta>`** : Sobe um servidor estático rápido usando Python (padrão porta 8000).
- **`myip` / `weather` / `speedtest`** : Utilitários rápidos de rede (ip, clima, velocidade de internet).
- **`pbcopy` / `pbpaste`** : Copia e cola no clipboard (funciona no Mac e Linux!).
- **`mkcd <pasta>`** : Cria a pasta e já acessa.
- **`extract <arquivo>`** : Atalho rápido para extrair `.tar.gz`.

---

## 🧘 Ferramentas Core do Yoga

- **`yoga`** : Abre o Dashboard principal do ambiente.
- **`yoga-status`** : Status e check das ferramentas instaladas.
- **`yoga-doctor`** : Verifica a saúde do sistema e dependências.
- **`yoga-update`** : Atualiza todo o toolkit.
- **`yoga-create <tipo> <nome>`** : Cria rapidamente projetos base (ex: `yoga-create react my-app`).
- **`reload`** : Recarrega o seu terminal / `.zshrc`.