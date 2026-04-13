# 🧘 Estudo de Mudança de Paradigma: Yoga-Files CLI

Este documento formaliza a proposta de transição do projeto **yoga-files** de um modelo baseado em funções de shell (Zsh-centric) para um modelo de **Sistema de Ferramental Binário (CLI-first)**.

---

## 1. 🎯 Objetivo da Transição

Mover a inteligência do ambiente de desenvolvimento das funções carregadas na memória do Shell (`init.sh` -> `functions.sh`) para executáveis independentes localizados em `bin/`. 

O objetivo final é transformar o `yoga-files` em uma **Engine de Desenvolvimento Abstraída** que funcione de forma consistente em qualquer shell e minimize o "overhead" de inicialização do terminal.

---

## 2. 🏛️ Análise do Paradigma Atual vs. Proposto

| Característica | Paradigma Atual (Shell Functions) | Paradigma Proposto (CLI Binaries) |
|----------------|----------------------------------|-----------------------------------|
| **Ponto de Entrada** | `source init.sh` no `.zshrc` | `$PATH` incluindo `yoga-files/bin` |
| **Performance** | Lento (carrega todo o código no startup) | Instantâneo (carrega apenas ao executar) |
| **Portabilidade** | Preso ao Zsh/Bash interativo | Funciona em Scripts, Cron, SSH e outros Shells |
| **Manutenção** | Arquivos `.sh` gigantes e monolíticos | Scripts modulares e independentes em `bin/` |
| **Configurações** | Links simbólicos (`~/.config/nvim`) | Wrappers com `XDG_CONFIG_HOME` dinâmico |

---

## 3. ⚖️ Tradeoffs (Vantagens e Desafios)

### ✅ Vantagens Técnicas
1. **Startup Zen:** O terminal abre instantaneamente, pois o Shell não precisa interpretar centenas de linhas de funções utilitárias no carregamento.
2. **Auto-Documentação:** Binários permitem flags como `--help` e `--version` de forma nativa.
3. **Isolamento de Configuração:** Ferramentas como Neovim e Tmux podem "carregar a própria mochila" de configurações diretamente do diretório do projeto, eliminando a necessidade de gerenciar links simbólicos manuais que podem quebrar.
4. **Testabilidade:** Scripts em `bin/` são mais fáceis de testar via CI/CD do que funções internas de shell.

### ⚠️ Desafios de Implementação
1. **Estado do Shell (`cd`):** Binários rodam em sub-shells e não podem alterar o diretório do terminal pai.
   - *Solução:* Manter pequenos "stubs" ou aliases apenas para comandos de navegação (ex: `ccp`, `take`).
2. **Dependências Externas:** Scripts em `bin/` precisam garantir que bibliotecas core (como `utils.sh`) sejam importadas corretamente usando caminhos absolutos baseados no `YOGA_HOME`.

---

## 4. 🛠️ Estratégia de Migração Recomendada

### Etapa 1: Migração de Utilitários Independentes
Mover funções que apenas processam dados ou executam comandos externos (ex: `cc`, `pid_port`, `docker_nukem`, `echo_ip`) para scripts em `bin/`.

### Etapa 2: Wrappers de Aplicação (O fim do Symlink)
Criar executáveis em `bin/` que atuam como "lançadores" para apps complexos:
- `bin/v` ou `bin/nv` -> Executa `nvim` injetando `XDG_CONFIG_HOME=$YOGA_HOME/editor`.
- `bin/tx` -> Executa `tmux` injetando a config do `yoga-files`.

### Etapa 3: Refatoração do `init.sh`
O `init.sh` será reduzido drasticamente para apenas:
1. Exportar o `PATH` com `YOGA_HOME/bin`.
2. Carregar o Prompt (P10k) e Aliases básicos.
3. Definir stubs de navegação (`ccp`).

---

## 5. 💡 Conclusão e Parecer Técnico

Dada a organização atual do `yoga-files`, a mudança para um paradigma CLI-first é não apenas viável, mas **altamente recomendada**. O projeto já possui uma estrutura de diretórios (`bin/`, `core/`, `specs/`) que suporta essa arquitetura. 

Essa evolução transformará o `yoga-files` de uma simples coleção de "dotfiles" em uma **plataforma de produtividade profissional**, robusta e independente de customizações manuais no sistema operacional.

---
**Autor:** Gemini CLI Agent
**Data:** 13 de Abril, 2026
