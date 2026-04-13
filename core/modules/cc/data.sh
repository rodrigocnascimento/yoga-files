#!/usr/bin/env zsh
# 🎯 core/modules/cc/data.sh
# @name: cc-data
# @desc: Coleta dados de múltiplas fontes para CC 🎯
# @usage: source "${YOGA_HOME}/core/modules/cc/data.sh"
# @author: Yoga 2.0 Efigenia Edition 🧘‍♂️

emulate -L zsh
set -euo pipefail

# 📦 Source
source "${YOGA_HOME}/core/utils/ui.sh"

# ═══════════════════════════════════════════════════════════
# 📊 DATA COLLECTION
# ═══════════════════════════════════════════════════════════

function cc_data_collect {
	local -a items=()

	# 📦 Aliases
	while IFS='=' read -r name value; do
		[[ -n "$name" ]] && items+=("alias|${name}|${value}")
	done < <(alias 2>/dev/null | sed "s/=/'/; s/'//")

	# 🔧 Funções
	for func in $(typeset +f 2>/dev/null | grep -v '^_'); do
		items+=("function|${func}|${func}")
	done

	# 🌿 Git branches (se em repo git)
	if git rev-parse --git-dir &>/dev/null; then
		while read -r branch; do
			[[ -n "$branch" ]] && items+=("git|${branch}|git checkout ${branch}")
		done < <(git branch -a 2>/dev/null | sed 's/^[* ]*//' | head -20)
	fi

	# 🐳 Docker containers
	if command -v docker &>/dev/null; then
		while IFS= read -r container; do
			[[ -n "$container" ]] && items+=("docker|${container}|docker exec -it ${container} bash")
		done < <(docker ps --format "{{.Names}}" 2>/dev/null | head -10)
	fi

	# 📜 Histórico
	while read -r cmd; do
		[[ -n "$cmd" ]] && items+=("history|${cmd:0:50}|${cmd}")
	done < <(history 2>/dev/null | tail -30 | sed 's/^ *[0-9]* *//' | sort -u)

	# 📤 Output
	printf '%s\n' "${items[@]}"
}
