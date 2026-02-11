#!/bin/zsh
# yoga-ai-terminal.sh - Ferramenta de IA direto no terminal

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"
source "$YOGA_HOME/core/utils.sh"

_yoga_ai_config_file() {
    if [ -f "$YOGA_HOME/config/config.yaml" ]; then
        echo "$YOGA_HOME/config/config.yaml"
        return 0
    fi
    if [ -f "$YOGA_HOME/config.yaml" ]; then
        echo "$YOGA_HOME/config.yaml"
        return 0
    fi
    echo ""
}

_yoga_ai_get_config_value() {
    # Very small YAML getter for simple keys.
    # Usage: _yoga_ai_get_config_value "preferences.ai_provider"
    local key="$1"
    local cfg
    cfg="$(_yoga_ai_config_file)"
    [ -n "$cfg" ] || return 0

    case "$key" in
        preferences.ai_provider)
            awk '/^[[:space:]]*preferences:[[:space:]]*$/ {p=1; next} p && /^[[:space:]]*ai_provider:[[:space:]]*/ {v=$0; sub(/^[^:]*:[[:space:]]*/, "", v); gsub(/"/, "", v); gsub(/[[:space:]]+$/, "", v); print v; exit} /^[^[:space:]]/ {p=0}' "$cfg" 2>/dev/null
            ;;
        tools.ai.model)
            awk '/^[[:space:]]*tools:[[:space:]]*$/ {t=1; next} t && /^[[:space:]]*ai:[[:space:]]*$/ {a=1; next} a && /^[[:space:]]*model:[[:space:]]*/ {v=$0; sub(/^[^:]*:[[:space:]]*/, "", v); gsub(/"/, "", v); gsub(/[[:space:]]+$/, "", v); print v; exit} /^[^[:space:]]/ {t=0; a=0}' "$cfg" 2>/dev/null
            ;;
        *)
            ;;
    esac
}

_yoga_ai_provider() {
    local provider
    provider="$(_yoga_ai_get_config_value "preferences.ai_provider")"
    provider="${provider:-openai}"
    echo "$provider"
}

_yoga_ai_model() {
    local model
    model="$(_yoga_ai_get_config_value "tools.ai.model")"
    model="${model:-gpt-4}"
    echo "$model"
}

_yoga_ai_openai_chat() {
    local system_msg="$1"
    local user_msg="$2"
    local temperature="${3:-0.3}"
    local max_tokens="${4:-800}"

    local model
    model="$(_yoga_ai_model)"

    local payload
    payload="$(
        jq -n \
            --arg model "$model" \
            --arg system "$system_msg" \
            --arg user "$user_msg" \
            --argjson temperature "$temperature" \
            --argjson max_tokens "$max_tokens" \
            '{
              model: $model,
              messages: [
                {role: "system", content: $system},
                {role: "user", content: $user}
              ],
              temperature: $temperature,
              max_tokens: $max_tokens
            }'
    )"

    curl -fsS -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "$payload" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content'
}

_yoga_ai_copilot_suggest() {
    local prompt="$1"
    if ! command -v gh >/dev/null 2>&1; then
        yoga_fogo "❌ gh not installed (required for copilot provider)"
        yoga_agua "💧 Install GitHub CLI: https://cli.github.com/"
        return 1
    fi

    # Note: `gh copilot` requires user auth in gh.
    gh copilot suggest -t shell "$prompt"
}

_yoga_ai_copilot_explain() {
    local prompt="$1"
    if ! command -v gh >/dev/null 2>&1; then
        yoga_fogo "❌ gh not installed (required for copilot provider)"
        yoga_agua "💧 Install GitHub CLI: https://cli.github.com/"
        return 1
    fi

    gh copilot explain "$prompt"
}

_yoga_ai_chat() {
    local system_msg="$1"
    local user_msg="$2"
    local temperature="${3:-0.3}"
    local max_tokens="${4:-800}"

    local provider
    provider="$(_yoga_ai_provider)"

    case "$provider" in
        openai)
            if [ -z "${OPENAI_API_KEY-}" ]; then
                yoga_fogo "❌ OPENAI_API_KEY não configurada"
                yoga_agua "💧 Configure: export OPENAI_API_KEY='...'."
                return 1
            fi
            _yoga_ai_openai_chat "$system_msg" "$user_msg" "$temperature" "$max_tokens"
            ;;
        copilot)
            # Copilot doesn't take system messages; include high-level instruction.
            _yoga_ai_copilot_suggest "$user_msg"
            ;;
        claude|gemini)
            yoga_fogo "❌ Provider not implemented yet: $provider"
            yoga_agua "💧 Use preferences.ai_provider: \"openai\" or \"copilot\""
            return 1
            ;;
        *)
            yoga_fogo "❌ Unknown provider: $provider"
            yoga_agua "💧 Use preferences.ai_provider: \"openai\" or \"copilot\""
            return 1
            ;;
    esac
}

# Função principal do assistente IA para terminal
yoga_ai_terminal() {
    local command="$1"
    shift
    local query="$*"
    
    case "$command" in
        help)
            ai_help_command "$query"
            ;;
        fix)
            ai_fix_command "$query"
            ;;
        cmd)
            ai_generate_command "$query"
            ;;
        explain)
            ai_explain_command "$query"
            ;;
        debug)
            ai_debug_error "$query"
            ;;
        optimize)
            ai_optimize_code "$query"
            ;;
        code)
            ai_generate_code "$query"
            ;;
        learn)
            ai_learn_topic "$query"
            ;;
        *)
            ai_chat_free "$command $query"
            ;;
    esac
}

# Ajuda para escrever comandos
ai_help_command() {
    local query="$*"
    yoga_breath "🫁 Consultando IA para ajudar com comando..."

    local prompt="Como desenvolvedor experiente, ajude a escrever o comando shell/terminal correto para: $query
    Forneça o comando exato e uma breve explicação.
    Se houver múltiplas opções, liste as melhores."

    local response
    response="$(_yoga_ai_chat \
        "You are an expert in macOS/Linux shell commands. Be precise. Never execute commands; only suggest." \
        "$prompt" \
        0.3 \
        500)"
    
    yoga_fogo "🔥 Comando sugerido:"
    echo -e "${YOGA_AGUA}$response${YOGA_RESET}"
    
    yoga_agua "💧 Nota: por segurança, o comando não é executado automaticamente."
}

# Corrigir comando errado
ai_fix_command() {
    local wrong_cmd="$*"
    yoga_agua "💧 Analisando comando para correção..."

    local prompt="Corrija este comando shell que está errado ou com erro de digitação: '$wrong_cmd'
    Retorne APENAS o comando corrigido, sem explicação adicional."

    local response
    response="$(_yoga_ai_chat \
        "Fix shell commands. Output ONLY the corrected command, no explanation. Don't add backticks." \
        "$prompt" \
        0.1 \
        200)"
    
    yoga_fogo "🔥 Comando corrigido:"
    echo -e "${YOGA_TERRA}❌ Errado: $wrong_cmd${YOGA_RESET}"
    echo -e "${YOGA_ESPIRITO}✅ Correto: $response${YOGA_RESET}"
    
    # Copiar para clipboard se disponível
    if command -v pbcopy &>/dev/null; then
        echo "$response" | pbcopy
        yoga_agua "📋 Comando copiado para clipboard!"
    elif command -v xclip &>/dev/null; then
        echo "$response" | xclip -selection clipboard
        yoga_agua "📋 Comando copiado para clipboard!"
    fi
}

# Gerar comando complexo
ai_generate_command() {
    local requirement="$*"
    yoga_ar "🌬️ Gerando comando para: $requirement"

    local prompt="Gere o comando shell/terminal exato para: $requirement
    Considere boas práticas, performance e segurança.
    Se precisar de múltiplos comandos, use pipes ou && apropriadamente.
    Evite comandos destrutivos por padrão (rm -rf, sudo) sem avisar claramente."

    local response
    response="$(_yoga_ai_chat \
        "Generate safe shell commands for macOS/Linux. Prefer non-destructive commands." \
        "$prompt" \
        0.3 \
        500)"
    
    yoga_espirito "🧘 Comando gerado:"
    echo -e "${YOGA_FOGO}$response${YOGA_RESET}"
}

# Explicar comando
ai_explain_command() {
    local cmd="$*"
    yoga_terra "🌿 Explicando comando..."
    
    local prompt="Explique em detalhes o que este comando faz: '$cmd'
    Quebre cada parte e explique os parâmetros.
    Use linguagem clara e técnica."
    
    local response
    response="$(_yoga_ai_chat \
        "Explain shell commands clearly and precisely." \
        "$prompt" \
        0.5 \
        800)"
    
    yoga_agua "💧 Explicação:"
    echo -e "${YOGA_ESPIRITO}$response${YOGA_RESET}"
}

# Debug de erro
ai_debug_error() {
    local error="$*"
    yoga_fogo "🔥 Analisando erro..."
    
    local prompt="Como desenvolvedor JavaScript/TypeScript experiente, analise este erro e forneça:
    1. Causa provável
    2. Solução recomendada
    3. Como prevenir no futuro
    
    Erro: $error"
    
    local response
    response="$(_yoga_ai_chat \
        "You are a senior JS/TS debugging assistant." \
        "$prompt" \
        0.5 \
        1000)"
    
    yoga_espirito "🧘 Análise do erro:"
    echo -e "${YOGA_AGUA}$response${YOGA_RESET}"
}

# Otimizar código
ai_optimize_code() {
    local code="$*"
    yoga_ar "🌬️ Otimizando código..."
    
    local prompt="Otimize este código JavaScript/TypeScript para melhor performance e legibilidade:
    $code
    
    Forneça a versão otimizada e explique as melhorias."
    
    local response
    response="$(_yoga_ai_chat \
        "You optimize JS/TS for performance and readability." \
        "$prompt" \
        0.3 \
        1000)"
    
    yoga_terra "🌿 Código otimizado:"
    echo -e "${YOGA_ESPIRITO}$response${YOGA_RESET}"
}

# Gerar código
ai_generate_code() {
    local requirement="$*"
    yoga_fogo "🔥 Gerando código..."

    local prompt="Gere código JavaScript/TypeScript moderno para: $requirement
    Use TypeScript, async/await, boas práticas atuais.
    Inclua tipos.
    Retorne apenas o código (sem markdown)."

    local response
    response="$(_yoga_ai_chat \
        "You are a senior TypeScript developer. Output only code." \
        "$prompt" \
        0.5 \
        1500)"
    
    yoga_espirito "🧘 Código gerado:"
    echo -e "${YOGA_AGUA}$response${YOGA_RESET}"
    
    yoga_agua "💧 Nota: por segurança, o código não é salvo automaticamente."
}

# Aprender tópico
ai_learn_topic() {
    local topic="$*"
    yoga_breath "🫁 Preparando material de aprendizado sobre: $topic"
    
    local prompt="Ensine sobre '$topic' no contexto de desenvolvimento JavaScript/TypeScript moderno.
    Inclua:
    1. Conceitos fundamentais
    2. Exemplos práticos
    3. Melhores práticas
    4. Armadilhas comuns
    5. Recursos para aprofundamento"
    
    local response
    response="$(_yoga_ai_chat \
        "You are a practical JS/TS teacher. Provide concise structure and examples." \
        "$prompt" \
        0.7 \
        2000)"
    
    yoga_espirito "🧘 Material de estudo:"
    echo -e "${YOGA_TERRA}$response${YOGA_RESET}"
}

# Chat livre
ai_chat_free() {
    local query="$*"
    yoga_agua "💧 Conversando com IA..."
    
    local response
    response="$(_yoga_ai_chat \
        "You are a helpful JS/TS development assistant." \
        "$query" \
        0.7 \
        1500)"
    
    yoga_espirito "🧘 Resposta:"
    echo -e "${YOGA_FOGO}$response${YOGA_RESET}"
}

# Aliases para acesso rápido
alias yai='yoga_ai_terminal'
alias ai='yoga_ai_terminal'
alias aihelp='yoga_ai_terminal help'
alias aifix='yoga_ai_terminal fix'
alias aicmd='yoga_ai_terminal cmd'
alias aiexplain='yoga_ai_terminal explain'
alias aidebug='yoga_ai_terminal debug'
alias aicode='yoga_ai_terminal code'
alias ailearn='yoga_ai_terminal learn'

# Note: this file is meant to be sourced.
