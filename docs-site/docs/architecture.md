---
id: architecture
title: Arquitetura do Projeto
sidebar_position: 1
---
# 🏛️ Arquitetura do Projeto: yoga-files

Este documento detalha o mapeamento arquitetural completo do projeto **yoga-files**. Ele descreve como os componentes se comunicam, quais são as responsabilidades de cada módulo, funções principais, bem como as entradas e saídas esperadas.

---

## 1. 🌟 Visão Geral do Sistema

O `yoga-files` é um framework de ambiente de desenvolvimento focado no ecossistema JavaScript/TypeScript, construído primordialmente em Bash/Zsh, com foco absoluto em Developer Experience (DX). 

O sistema é dividido em quatro pilares principais:
1. **Core / CLI:** Scripts utilitários de sistema e orquestração (bash).
2. **Setup Engine:** Gerenciadores de versão (ASDF) e Editor (LazyVim).
3. **AI Interface:** Ferramentas de terminal para conversar com LLMs (Gemini, OpenAI).
4. **Web UI:** Landing page (React/Vite) para apresentação do produto.
5. **Meta-Agent:** Compilador de regras para IAs (`.opencode` -> `AGENTS.md`).

---

## 2. 📂 Mapeamento de Diretórios

```text
/
├── bin/            # Executáveis principais (expostos no PATH do usuário via symlinks/exports)
├── core/           # Bibliotecas internas de bash (UI, wrappers, integrações)
├── docs/           # Documentação do projeto (Manuais, Guias de Teste)
├── landing-page/   # Aplicação Frontend React/Vite (apresentação do produto)
├── specs/          # TDDs e especificações técnicas geradas por IA
├── templates/      # Templates para o gerador de projetos (yoga-create)
├── tests/          # Testes de integração (Bash/Zsh smoke tests)
├── .opencode/      # Fonte de regras de IAs (Regras, Comandos, Agentes)
├── config.yaml     # Fonte da Verdade de configuração do usuário (YAML)
├── AGENTS.md       # Arquivo compilado com todas as regras (.opencode gerado)
├── init.sh         # Ponto de entrada do Shell do usuário (carregado no .zshrc)
└── install.sh      # Bootstrap inicial do ambiente na máquina limpa
```

---

## 3. ⚙️ Componentes Principais e Mapeamento de Funções

Nesta seção dissecamos os binários (`bin/`) e scripts core, suas funções, o que recebem e o que devolvem.

### 3.1. `bin/yoga-ai` (Assistente IA no Terminal)
O cérebro interativo do sistema. Conecta-se à API definida no `config.yaml` (ex: Gemini, OpenAI).

* **Como funciona:** Lê o `YOGA_HOME/core/ai/yoga-ai-terminal.sh`. Captura os argumentos, faz parse do modo escolhido (help, fix, cmd, etc.) e envia o payload cURL para a API do provedor (Lendo a API KEY do ambiente).
* **Entradas (Inputs):** `[modo] [query em texto]` (Ex: `yoga-ai fix "git statos"`)
* **Saídas (Outputs):** Texto renderizado no terminal em formato Markdown com syntax highlighting adaptado ou comando explícito pronto para rodar.
* **Modos Suportados:**
  * `help`: Responde dúvidas.
  * `fix`: Corrige comandos shell.
  * `explain`: Explica conceitos.
  * `cmd`: Retorna apenas o comando bash desejado.
  * `debug`: Analisa logs de erro.

### 3.2. `bin/yoga-create` (Motor de Scaffolding)
Cria estruturas base para novos projetos sem necessitar lembrar de configurações complexas.

* **Como funciona:** Processa parâmetros, valida templates e executa `npm create`, `npx` ou comandos `mkdir/touch` sequenciais com base no framework desejado.
* **Entradas:** `[template] [nome-do-projeto]` (Ex: `yoga-create react meu-app`).
* **Saídas:** Criação de um novo diretório com arquivos configurados (package.json, tsconfig, biome.json) prontos para uso.
* **Templates suportados:** `react`, `node`, `next`, `ts`, `express`, `community <tipo>`.

### 3.3. `bin/git-wizard` (Gestor Multi-Perfil Git)
Resolve a dor de misturar commits do trabalho e pessoais.

* **Como funciona:** Invoca o script `core/git/git-wizard.sh`. Lê as configurações em `config.yaml` sob a chave `git.profiles`. Realiza interações no terminal capturando input do usuário para trocar as configurações globais do `.gitconfig`.
* **Entradas:** Nenhuma (TUI interativa). Opcionalmente opções de menu.
* **Saídas:** Edição do arquivo `~/.gitconfig`, exportação de chaves SSH/GPG vinculadas e feedback visual de sucesso (`yoga_agua`).

### 3.4. `bin/opencode-compile` (Meta-Compilador)
Sincroniza as regras humanas com o cérebro das IAs.

* **Como funciona:** Lê recursivamente os arquivos Markdown e YAML dentro do diretório `.opencode/` (commands, rules, skills). Concatena de forma estruturada e escreve em `AGENTS.md` e num bloco auto-gerado do README se configurado.
* **Entradas:** Arquivos estáticos em `.opencode/`.
* **Saídas:** Arquivo `AGENTS.md` atualizado, servindo de System Prompt fixo para IAs do Cursor, Cline ou OpenCode operarem no repositório.

### 3.5. `bin/yoga-doctor` (Sistema de Saúde)
Verificador de integridade do ambiente.

* **Como funciona:** Executa uma série de testes condicionais no shell (`command -v`, `ping`, verificação de permissões de leitura/escrita, version matches).
* **Entradas:** Opcional `--network` para testar conexões SSH/HTTP com GitHub e provedores de IA.
* **Saídas:** Tabela/Lista visual no terminal com `[OK]` (Verde) ou `[FAIL]` (Vermelho). Se falhar, retorna `exit code 1`.

---

## 4. 🎨 Sistema de UI do Terminal (Filosofia Yoga)

O sistema central de design pattern em Bash (`core/utils.sh`) baseia-se em cores temáticas e padronização visual. Em vez de usar `echo`, o código usa funções semânticas.

**Mapeamento de Funções de UI (Output):**
| Função Shell | Elemento | Finalidade | Cor Hex Baseada | Output Esperado |
|--------------|----------|------------|-----------------|-----------------|
| `yoga_fogo` | 🔥 Fogo | Alertas, Erros, Ações Destrutivas | `#c8a09c` (Vermelho) | Texto em vermelho informando falha. Parada da execução. |
| `yoga_agua` | 💧 Água | Sucesso, Conclusões, Fluxo OK | `#7aa89f` (Ciano) | Texto azul/ciano com `✓` de check. |
| `yoga_terra` | 🌿 Terra | Informações de base, Estrutura | `#76946a` (Verde) | Texto verde para status de sistema/arquivos. |
| `yoga_ar` | 🌬️ Ar | Processamento em background, loadings | `#7e9cd8` (Azul céu)| Textos de progressão, reticências (ex: "Instalando..."). |

---

## 5. 🏗️ Arquitetura da Landing Page (`/landing-page`)

O `yoga-files` acompanha sua própria interface de marketing, configurada com as melhores práticas de Frontend modernas:

* **Stack:** React 18, Vite, TypeScript, TailwindCSS v4, Framer Motion (para animações de terminal e particles).
* **Como foi feito:** Foi criada uma SPA (Single Page Application) focada em conversão. Todo o layout usa a paleta de cores importada da filosofia "Yoga/Zen" traduzida em variáveis CSS (ex: `--color-sage`, `--color-zen-bg`).
* **Estrutura de Componentes:**
  * `src/components/ui/`: Componentes agnósticos e reutilizáveis (Botões de Copy, Efeitos Mouse Glow, Terminal simulado, Background de partículas).
  * `src/components/sections/`: Componentes organizacionais (Hero, TechStack, Comparison, FAQ, Features).
  * `src/i18n/`: Dicionário de tradução e textos (Atualmente `en.ts`).

---

## 6. 🧠 Arquitetura de Inteligência Artificial (`.opencode` e Gemini/OpenAI)

A arquitetura prevê que o Yoga-files não seja apenas uma ferramenta, mas seja *"IA-first"*. 

* **Configuração:** Gerenciada através do arquivo `config.yaml`.
* **Motor Base (`config.yaml`):** O usuário define o `ai_provider` (atualmente Gemini-1.5-pro configurado). O motor de bash lê essa configuração, intercepta a requisição do usuário via `yoga-ai` e converte para a estrutura JSON da REST API específica do provedor escolhido.
* **Governança do Repositório (`.opencode/`):** 
  Para evitar que o próprio repositório vire uma bagunça caso uma IA o modifique, existem restrições rígidas compiladas no `AGENTS.md`.
  * *Entrada:* Regras restritas em markdown (`.opencode/rules/10-no-pull-main.md`).
  * *Efeito Prático:* A IA é bloqueada via prompt (System Prompt) de comitar diretamente na `main`, forçada a gerar TDDs na pasta `specs/` antes de escrever código, e forçada a não usar `any` no TypeScript (`99-no-unsafetypes-policy.md`).

---

## 7. 📥 Configuração Global (`config.yaml`)

O arquivo raiz de comportamento do ecossistema inteiro.

* **Responsabilidade:** Atuar como a "Single Source of Truth" (Fonte única da verdade) para os bash scripts e IAs.
* **Fluxo de Leitura (Como foi feito):** No carregamento via `init.sh` no `.zshrc`, ferramentas como o `yq` (ou um parser simples bash) extraem dados do yaml para injetar as Variáveis de Ambiente locais na sessão atual (ex: Setando as versões default no ASDF, definindo qual IA será chamada, formatando atalhos Git).

---

## Conclusão de Design

O `yoga-files` foi arquitetado não para ser apenas uma coleção de dotfiles, mas uma **Engine de Desenvolvimento Abstraída**. Ele recebe **intencionalidade humana** através de comandos simples (CLI `yoga-`) ou perguntas naturais (`yoga-ai`) e orquestra a complexidade do sistema operacional, versionadores, e LLMs abaixo da superfície, devolvendo um ambiente zen, configurado e pronto para uso (`Saída: Ready-to-code state`).