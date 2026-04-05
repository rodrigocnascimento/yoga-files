# 🧘‍♂️ Guia Completo de Testes: yoga-files

Este documento lista **absolutamente tudo** que você pode fazer com o `yoga-files`. Siga os comandos abaixo para testar cada funcionalidade do seu novo ambiente de desenvolvimento.

---

## 1. 🏥 Diagnóstico do Ambiente (Doctor)
O comando `yoga-doctor` verifica se todas as dependências do sistema estão instaladas corretamente.

```bash
# Executa um check-up completo (OS, dependências, conectividade)
yoga-doctor

# Testa permissões e conectividade de rede específicas
yoga-doctor --network
```

---

## 2. 🤖 Inteligência Artificial no Terminal (yoga-ai)
A CLI do `yoga-ai` possui vários modos de uso para te ajudar no dia a dia. Como você acabou de configurar o Gemini, ele usará a API do Google (lembre-se de exportar `GEMINI_API_KEY`).

```bash
# Ajuda geral (pergunta livre)
yoga-ai "Como listar todos os arquivos modificados nos últimos 2 dias em bash?"

# Modo Help (ajuda com comandos de terminal)
yoga-ai help "como encontrar a porta 5173 ocupada e matar o processo"

# Modo Fix (corrige um comando digitado errado)
yoga-ai fix "git comit -m 'mensagem'"

# Modo Explain (explica conceitos ou códigos)
yoga-ai explain "O que é o rebase interativo no git?"

# Modo Cmd (gera um comando que você só precisa colar)
yoga-ai cmd "listar portas ouvindo no linux"

# Modo Debug (ajuda a analisar mensagens de erro)
yoga-ai debug "ECONNREFUSED 127.0.0.1:5432"
```

---

## 3. 📦 Criação de Projetos (yoga-create & templates)
O `yoga-files` permite scaffolding rápido de novos projetos.

```bash
# 1. Lista todos os templates disponíveis
yoga-templates list

# 2. Criação rápida de projetos (scaffolding oficial)
yoga-create react meu-projeto-react
yoga-create next meu-site-next
yoga-create express minha-api-express
yoga-create node meu-app-node
yoga-create ts meulib-ts

# 3. Utilizar templates mantidos pela comunidade
yoga-create community react-vite meu-vite-app
```

---

## 4. 🔀 Gerenciamento Git Multi-Perfil (git-wizard)
Se você usa contas diferentes no Git (ex: Pessoal vs Trabalho), o wizard facilita a alternância de perfis e chaves SSH/GPG.

```bash
# Inicia o Wizard interativo do Git
git-wizard

# O que testar dentro dele:
# - Crie um novo perfil ("Trabalho")
# - Alterne para o perfil "Pessoal"
# - Teste a geração/configuração de SSH integrada
```

---

## 5. 🛠️ Gestão de Ferramentas e Linguagens (ASDF)
O `yoga-files` integra o ASDF nativamente para você gerenciar versões de Node, Python, Ruby, etc.

```bash
# Menu interativo do ASDF (Interface visual)
asdf-menu

# Instala e gerencia plugins via terminal
yoga-plugin list
yoga-plugin add nodejs
yoga-plugin update all

# Verifica o status atual do ASDF no yoga-files
yoga-asdf status
```

---

## 6. ⚙️ Interface Visual e Setup Base (yoga)
O comando principal do sistema gerencia toda a sua instalação.

```bash
# Abre o menu principal do yoga
yoga

# Verifica o status da sua instalação
yoga-status

# Remove/Desinstala o yoga-files completamente (cuidado)
yoga-remove

# Atualiza o yoga-files para a versão mais recente
yoga-update
```

---

## 7. 🚀 Compilação de Regras de IA (OpenCode)
Como seu projeto usa a pasta `.opencode/` para regras de Inteligência Artificial para Cursor / OpenCode:

```bash
# Sempre que modificar regras em .opencode/, compile-as:
opencode-compile
# ou
npm run opencode:compile

# Teste: Modifique algo em .opencode/rules/10-no-pull-main.md e rode o comando acima.
# Depois, verifique o arquivo AGENTS.md para ver o resultado concatenado no final.
```

---

## 8. 📝 Testando os Projetos Gerados
O repositório já contém testes shell script para garantir o funcionamento do bash e do zsh.

```bash
# Rodar smoke tests do Yoga-files
cd tests/
./run-all.sh
```

---

## 9. 🌐 Subindo a Landing Page do Yoga-files
Você também tem um projeto React Vite de "Landing Page" integrado no monorepo!

```bash
# Entre na pasta
cd landing-page/

# Construa a página (usando Biome + TypeScript + Vite)
npm run build

# Suba a versão local de desenvolvimento para visualizar a página (UI React)
npm run dev
```

---

## 🚀 Resumo do Fluxo de Trabalho (O Teste Supremo)

1. Crie uma pasta de teste: `mkdir teste-geral && cd teste-geral`
2. Gere uma API: `yoga-create express api-teste`
3. Entre nela e veja se gerou os arquivos: `cd api-teste && ls -la`
4. Use a IA para gerar um código: `yoga-ai "crie um arquivo server.ts rodando express na porta 3000"`
5. Use a IA para analisar o código gerado: `yoga-ai explain "server.ts"`
6. Limpe seu ambiente se não quiser mais a API.

Aproveite seu **Yoga Development Environment** perfeitamente configurado! 🧘‍♂️✨