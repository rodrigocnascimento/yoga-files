#!/bin/zsh
# 🦜 Yoga 3.0 - Lôro Barizon Edition - Initialization Script
# @name: yoga-init
# @desc: Simplified initialization - NO DASHBOARD, NO TRAPS
# @version: 3.0.0

# Definir YOGA_HOME
export YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"

# Verificar se YOGA está instalado
if [ ! -d "$YOGA_HOME" ]; then
	echo "🔥 YOGA FILES não está instalado!"
	echo "Execute: curl -fsSL https://raw.githubusercontent.com/rodrigocnascimento/yoga-files/main/install.sh | zsh"
	return 1
fi

# Carregar funções core (sem dashboard!)
source "$YOGA_HOME/core/utils.sh"
source "$YOGA_HOME/core/aliases.sh"
source "$YOGA_HOME/core/functions.sh"

# ❌ REMOVIDO: dashboard.sh (não existe mais na 3.0)
# ❌ REMOVIDO: alias yoga='yoga_dashboard' (trap removido!)

# Configurar PATH
export PATH="$YOGA_HOME/bin:$PATH"

# ASDF
if [ -f "$HOME/.asdf/asdf.sh" ]; then
	. "$HOME/.asdf/asdf.sh"
fi

# Mensagem silenciosa (opcional)
if [ -z "${YOGA_SILENT:-}" ] && [ -z "${YOGA_WELCOMED:-}" ]; then
	export YOGA_WELCOMED=1
	# Silencioso por padrão (ninja mode)
fi

# 🦜 Lôro Barizon Edition - Ninja Mode Activated
# O sistema trabalha under the hood
# Use: yoga cc, yoga workspace, yoga tunnel, yoga docs search, etc.
