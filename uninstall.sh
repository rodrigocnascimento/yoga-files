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

FAREWELL_MESSAGES=(
	"A vida é um ciclo... e o seu yoga também! 🔄🧘"
	"Namastê... até a próxima reinstalação! 🙏"
	"O yoga saiu, mas a paz interior ficou... ou não. 🧘💨"
	"Desinstalado com sucesso! Agora vá tocar a vida sem flexibilidade. 🦴"
	"Yoga foi embora, mas o tmux ainda te deve uma sessão. 🖥️👋"
	"Tchau! Que o ASDF esteja com você. 🌌"
	"O daemon fechou os olhos. Descanse em paz, processo. 🪦"
	"Desinstalado! Seu terminal já sente falta. 💔"
	"Namastê daqui, pessoal! 🚀"
	"Yoga: 0, Fresh install: 1. Sorte na próxima! 🎲"
	"Adeus! Volte quando o vscode te decepcionar... de novo. 🔄"
	"Yoga removido. Seu .zshrc ficou mais leve... e mais triste. 😢"
	"Desinstalado! Agora você é um desenvolvedor sem chakra. 🧘‍♂️❌"
	"Até mais! E lembre-se: sempre se pode reinstalar. 💫"
	"O caminho do ninja terminou. Volte quando quiser ser jedi. ⚔️✨"
	"Sayonara! O daemon já está com saudades. 🤖💧"
	"Desinstalação completa! Sua produtividade vai sentir falta. 📉"
	"Tchau! Que seus commits sejam sempre verdes sem o yoga. 🌿"
	"O yoga partiu, mas o espírito hacking permanece. 👻"
	"Adeus! O curl de instalação ainda te espera... sempre. 🔄🧘"
)

RANDOM_INDEX=$((RANDOM % ${#FAREWELL_MESSAGES[@]}))
SELECTED_MESSAGE="${FAREWELL_MESSAGES[$RANDOM_INDEX]}"

echo ""
echo "✅ Yoga removido com sucesso!"
echo ""
echo "🧘 ${SELECTED_MESSAGE}"
echo ""
echo "📝 Para reinstalar:"
echo "   curl -fsSL https://raw.githubusercontent.com/rodrigocnascimento/yoga-files/main/install.sh | zsh"
