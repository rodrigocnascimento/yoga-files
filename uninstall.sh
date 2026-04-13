#!/usr/bin/env zsh
# 🧹 Yoga Uninstall - Script para limpar instalação antiga
# @usage: zsh /path/to/uninstall.sh

emulate -L zsh
set -euo pipefail

echo "🧹 Yoga Files Uninstall"
echo "========================"
echo ""

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"

# 🔍 Verificar se está instalado
if [[ ! -d "$YOGA_HOME" ]]; then
    echo "❌ Yoga não está instalado em $YOGA_HOME"
    exit 0
fi

echo "⚠️  Isso vai remover:"
echo "   📁 $YOGA_HOME"
echo "   📝 Referências no ~/.zshrc"
echo ""

read -q "REPLY?Tem certeza? [y/N] "
echo ""

if [[ "$REPLY" != "y" ]]; then
    echo "❌ Cancelado"
    exit 0
fi

# 🛑 Parar daemon se estiver rodando
if [[ -f "$YOGA_HOME/daemon.pid" ]]; then
    echo "🛑 Parando daemon..."
    kill $(cat "$YOGA_HOME/daemon.pid" 2>/dev/null) 2>/dev/null || true
fi

# 🗑️ Remover diretório
echo "🗑️  Removendo $YOGA_HOME..."
rm -rf "$YOGA_HOME"

# 🧹 Limpar .zshrc
echo "🧹 Limpando ~/.zshrc..."
sed -i '/# Yoga Files Integration/d' ~/.zshrc 2>/dev/null || true
sed -i '/export YOGA_HOME/d' ~/.zshrc 2>/dev/null || true
sed -i '/export PATH=.*YOGA_HOME/d' ~/.zshrc 2>/dev/null || true
sed -i '/source.*YOGA_HOME.*init.sh/d' ~/.zshrc 2>/dev/null || true

echo ""
echo "✅ Yoga removido com sucesso!"
echo ""
echo "📝 Para reinstalar o Yoga 2.0:"
echo "   curl -fsSL https://raw.githubusercontent.com/rodrigocnascimento/yoga-files/main/install.sh | zsh"
