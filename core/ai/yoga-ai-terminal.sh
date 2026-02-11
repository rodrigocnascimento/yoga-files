#!/bin/zsh
# yoga-ai-terminal.sh - Ferramenta de IA direto no terminal

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"
source "$YOGA_HOME/core/utils.sh"

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
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-4\",
            \"messages\": [
                {\"role\": \"system\", \"content\": \"Você é um expert em linha de comando Linux/macOS/shell.\"},
                {\"role\": \"user\", \"content\": \"$prompt\"}
            ],
            \"temperature\": 0.3,
            \"max_tokens\": 500
        }" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content')
    
    yoga_fogo "🔥 Comando sugerido:"
    echo -e "${YOGA_AGUA}$response${YOGA_RESET}"
    
    # Perguntar se quer executar
    yoga_agua "💧 Deseja executar este comando? (s/N):"
    read -r execute
    if [[ "$execute" =~ ^[Ss]$ ]]; then
        eval "$response"
        yoga_terra "🌿 Comando executado!"
    fi
}

# Corrigir comando errado
ai_fix_command() {
    local wrong_cmd="$*"
    yoga_agua "💧 Analisando comando para correção..."
    
    local prompt="Corrija este comando shell que está errado ou com erro de digitação: '$wrong_cmd'
    Retorne APENAS o comando corrigido, sem explicação adicional."
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-4\",
            \"messages\": [
                {\"role\": \"system\", \"content\": \"Corrija comandos shell com erros.\"},
                {\"role\": \"user\", \"content\": \"$prompt\"}
            ],
            \"temperature\": 0.1,
            \"max_tokens\": 200
        }" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content')
    
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
    Se precisar de múltiplos comandos, use pipes ou && apropriadamente."
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-4\",
            \"messages\": [
                {\"role\": \"system\", \"content\": \"Gere comandos shell otimizados e seguros.\"},
                {\"role\": \"user\", \"content\": \"$prompt\"}
            ],
            \"temperature\": 0.3,
            \"max_tokens\": 500
        }" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content')
    
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
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-4\",
            \"messages\": [
                {\"role\": \"user\", \"content\": \"$prompt\"}
            ],
            \"temperature\": 0.5,
            \"max_tokens\": 800
        }" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content')
    
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
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-4\",
            \"messages\": [
                {\"role\": \"system\", \"content\": \"Debug expert em JavaScript/TypeScript.\"},
                {\"role\": \"user\", \"content\": \"$prompt\"}
            ],
            \"temperature\": 0.5,
            \"max_tokens\": 1000
        }" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content')
    
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
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-4\",
            \"messages\": [
                {\"role\": \"system\", \"content\": \"Especialista em otimização JavaScript/TypeScript.\"},
                {\"role\": \"user\", \"content\": \"$prompt\"}
            ],
            \"temperature\": 0.3,
            \"max_tokens\": 1000
        }" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content')
    
    yoga_terra "🌿 Código otimizado:"
    echo -e "${YOGA_ESPIRITO}$response${YOGA_RESET}"
}

# Gerar código
ai_generate_code() {
    local requirement="$*"
    yoga_fogo "🔥 Gerando código..."
    
    local prompt="Gere código JavaScript/TypeScript moderno para: $requirement
    Use TypeScript, async/await, boas práticas atuais.
    Inclua tipos e comentários explicativos."
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-4\",
            \"messages\": [
                {\"role\": \"system\", \"content\": \"Expert em JavaScript/TypeScript moderno.\"},
                {\"role\": \"user\", \"content\": \"$prompt\"}
            ],
            \"temperature\": 0.5,
            \"max_tokens\": 1500
        }" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content')
    
    yoga_espirito "🧘 Código gerado:"
    echo -e "${YOGA_AGUA}$response${YOGA_RESET}"
    
    # Opção de salvar em arquivo
    yoga_agua "💧 Deseja salvar em arquivo? (s/N):"
    read -r save
    if [[ "$save" =~ ^[Ss]$ ]]; then
        yoga_terra "🌿 Nome do arquivo:"
        read -r filename
        echo "$response" > "$filename"
        yoga_fogo "🔥 Salvo em: $filename"
    fi
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
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-4\",
            \"messages\": [
                {\"role\": \"system\", \"content\": \"Professor expert em JavaScript/TypeScript.\"},
                {\"role\": \"user\", \"content\": \"$prompt\"}
            ],
            \"temperature\": 0.7,
            \"max_tokens\": 2000
        }" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content')
    
    yoga_espirito "🧘 Material de estudo:"
    echo -e "${YOGA_TERRA}$response${YOGA_RESET}"
}

# Chat livre
ai_chat_free() {
    local query="$*"
    yoga_agua "💧 Conversando com IA..."
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"gpt-4\",
            \"messages\": [
                {\"role\": \"system\", \"content\": \"Assistente de desenvolvimento JavaScript/TypeScript.\"},
                {\"role\": \"user\", \"content\": \"$query\"}
            ],
            \"temperature\": 0.7,
            \"max_tokens\": 1500
        }" \
        https://api.openai.com/v1/chat/completions | jq -r '.choices[0].message.content')
    
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

# Mensagem de boas-vindas
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    yoga_espirito "🧘 Yoga AI Terminal Assistant"
    echo "=================================="
    yoga_fogo "🔥 Comandos disponíveis:"
    echo "  yai help 'descrição'    - Ajuda para escrever comando"
    echo "  yai fix 'comando'       - Corrigir comando errado"
    echo "  yai cmd 'objetivo'      - Gerar comando complexo"
    echo "  yai explain 'comando'   - Explicar o que faz"
    echo "  yai debug 'erro'        - Analisar e resolver erro"
    echo "  yai code 'requisito'    - Gerar código"
    echo "  yai learn 'tópico'      - Aprender sobre algo"
    echo "  yai 'pergunta livre'    - Chat livre com IA"
    echo ""
    yoga_agua "💧 Configure OPENAI_API_KEY para usar"
fi
