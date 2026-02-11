#!/bin/bash
#
# 🔮 ASDF Interactive Manager
# User-friendly interface for ASDF version management
#

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"

# Source utilities
source "$YOGA_HOME/core/utils.sh"

# Note: keep function names ASCII for portability.

# Source ASDF
if [ -f "$HOME/.asdf/asdf.sh" ]; then
  source "$HOME/.asdf/asdf.sh"
else
  yoga_fogo "❌ ASDF not found at $HOME/.asdf/asdf.sh"
  return 1 2>/dev/null || exit 1
fi

# Common languages and their latest stable versions.
# Avoid associative arrays for macOS default bash (3.2).
get_default_version() {
    case "$1" in
        nodejs) echo "20.20.0" ;;
        python) echo "3.11.14" ;;
        ruby) echo "3.3.0" ;;
        golang) echo "1.22.0" ;;
        rust) echo "1.76.0" ;;
        java) echo "openjdk-21" ;;
        php) echo "8.3.0" ;;
        deno) echo "1.40.0" ;;
        bun) echo "1.0.30" ;;
        elixir) echo "1.16.0" ;;
        *) echo "" ;;
    esac
}

# Check if a plugin is installed
is_plugin_installed() {
    local plugin="$1"
    asdf plugin list 2>/dev/null | grep -q "^$plugin$"
}

# Check if a version is installed
is_version_installed() {
    local plugin="$1"
    local version="$2"
    asdf list "$plugin" 2>/dev/null | grep -q "$version"
}

# Get current version for a plugin
get_current_version() {
    local plugin="$1"
    asdf current "$plugin" 2>/dev/null | awk '{print $2}'
}

# List installed plugins with versions
list_installed() {
    yoga_espirito "📦 Installed Languages & Versions"
    echo ""
    
    local plugins=$(asdf plugin list 2>/dev/null)
    
    if [ -z "$plugins" ]; then
        yoga_agua "  No plugins installed yet"
        echo ""
        return
    fi
    
    while IFS= read -r plugin; do
        local current=$(get_current_version "$plugin")
        local versions=$(asdf list "$plugin" 2>/dev/null | sed 's/^[* ]*//' | tr '\n' ' ')
        
        if [ -n "$current" ]; then
            yoga_terra "  $plugin:"
            yoga_ar "    Current: $current"
            if [ -n "$versions" ]; then
                yoga_agua "    Available: $versions"
            fi
        else
            yoga_terra "  $plugin:"
            if [ -n "$versions" ]; then
                yoga_agua "    Installed: $versions"
                yoga_fogo "    No version set!"
            else
                yoga_fogo "    No versions installed"
            fi
        fi
    done <<< "$plugins"
    
    echo ""
}

# Install a new plugin
install_plugin() {
    local plugin="$1"
    
    if [ -z "$plugin" ]; then
    yoga_espirito "🔌 Available Plugins"
        echo ""
        
        # Show common plugins
        yoga_terra "Popular languages:"
        echo ""
        for lang in nodejs python ruby golang rust java php elixir; do
            if is_plugin_installed "$lang"; then
                yoga_agua "  ✓ $lang (installed)"
            else
                yoga_ar "  • $lang"
            fi
        done
        
        echo ""
        echo -n "$(yoga_ar 'Plugin name (or press Enter to search): ')"
        read -r plugin
        
        if [ -z "$plugin" ]; then
            # Search for plugins
                echo -n "$(yoga_ar 'Search for plugin: ')"
                read -r search_term
            
            if [ -n "$search_term" ]; then
                yoga_espirito "🔍 Searching for '$search_term'..."
                asdf plugin list all | grep -i "$search_term" | head -20
                echo ""
                echo -n "$(yoga_ar 'Enter plugin name to install: ')"
                read -r plugin
            fi
        fi
    fi
    
    if [ -z "$plugin" ]; then
        yoga_fogo "❌ No plugin specified"
        return 1
    fi
    
    if is_plugin_installed "$plugin"; then
        yoga_agua "✓ Plugin '$plugin' is already installed"
        return 0
    fi
    
    yoga_espirito "📥 Installing plugin: $plugin"
    
    if asdf plugin add "$plugin" 2>/dev/null; then
        yoga_terra "✅ Plugin '$plugin' installed successfully!"
        
        # Offer to install latest version
        echo ""
        echo -n "$(yoga_ar 'Install latest stable version? (y/n): ')"
        read -r install_latest
        
        if [[ "$install_latest" =~ ^[Yy] ]]; then
            install_version "$plugin" "latest"
        fi
    else
        yoga_fogo "❌ Failed to install plugin '$plugin'"
        yoga_agua "   The plugin might not exist or there was an error."
        return 1
    fi
}

# Install a specific version
install_version() {
    local plugin="$1"
    local version="$2"
    
    if [ -z "$plugin" ]; then
        list_installed
        echo -n "$(yoga_ar 'Plugin name: ')"
        read -r plugin
    fi
    
    if ! is_plugin_installed "$plugin"; then
        yoga_fogo "❌ Plugin '$plugin' is not installed"
        echo -n "$(yoga_ar 'Install it now? (y/n): ')"
        read -r install_plugin_now
        
        if [[ "$install_plugin_now" =~ ^[Yy] ]]; then
            install_plugin "$plugin"
        else
            return 1
        fi
    fi
    
    if [ -z "$version" ]; then
        # Show available versions
        yoga_espirito "📋 Available versions for $plugin:"
        echo ""
        
        # Get latest versions
        asdf list all "$plugin" 2>/dev/null | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | tail -10 | tac
        
        echo ""
        echo -n "$(yoga_ar 'Version to install (or "latest"): ')"
        read -r version
    fi
    
    if [ -z "$version" ]; then
        yoga_fogo "❌ No version specified"
        return 1
    fi
    
    # Handle "latest" keyword
    if [ "$version" = "latest" ]; then
        version=$(asdf latest "$plugin" 2>/dev/null)
        if [ -z "$version" ]; then
            yoga_fogo "❌ Could not determine latest version"
            return 1
        fi
        yoga_ar "Latest version: $version"
    fi
    
    if is_version_installed "$plugin" "$version"; then
        yoga_agua "✓ Version $version is already installed"
        
        echo -n "$(yoga_ar 'Set as current version? (y/n): ')"
        read -r set_current
        
        if [[ "$set_current" =~ ^[Yy] ]]; then
            set_version "$plugin" "$version" "global"
        fi
        return 0
    fi
    
    yoga_espirito "📦 Installing $plugin $version..."
    echo ""
    
    if asdf install "$plugin" "$version"; then
        yoga_terra "✅ Successfully installed $plugin $version"
        
        echo -n "$(yoga_ar 'Set as global default? (y/n): ')"
        read -r set_global
        
        if [[ "$set_global" =~ ^[Yy] ]]; then
            set_version "$plugin" "$version" "global"
        fi
    else
        yoga_fogo "❌ Failed to install $plugin $version"
        return 1
    fi
}

# Set version (global/local)
set_version() {
    local plugin="$1"
    local version="$2"
    local scope="${3:-global}"
    
    if [ -z "$plugin" ]; then
        list_installed
        echo -n "$(yoga_ar 'Plugin name: ')"
        read -r plugin
    fi
    
    if ! is_plugin_installed "$plugin"; then
        yoga_fogo "❌ Plugin '$plugin' is not installed"
        return 1
    fi
    
    if [ -z "$version" ]; then
        # Show installed versions
        yoga_espirito "📋 Installed versions for $plugin:"
        echo ""
        asdf list "$plugin" 2>/dev/null
        echo ""
        echo -n "$(yoga_ar 'Version to set: ')"
        read -r version
    fi
    
    if [ -z "$version" ]; then
        yoga_fogo "❌ No version specified"
        return 1
    fi
    
    if ! is_version_installed "$plugin" "$version"; then
        yoga_fogo "❌ Version $version is not installed"
        echo -n "$(yoga_ar 'Install it now? (y/n): ')"
        read -r install_now
        
        if [[ "$install_now" =~ ^[Yy] ]]; then
            install_version "$plugin" "$version"
        else
            return 1
        fi
    fi
    
    if [ "$scope" = "local" ]; then
        yoga_espirito "📁 Setting local version for current directory"
        asdf local "$plugin" "$version"
    else
        yoga_espirito "🌍 Setting global version"
        asdf global "$plugin" "$version"
    fi
    
    if [ $? -eq 0 ]; then
        yoga_terra "✅ Successfully set $plugin to $version ($scope)"
    else
        yoga_fogo "❌ Failed to set version"
        return 1
    fi
}

# Uninstall a version
uninstall_version() {
    local plugin="$1"
    local version="$2"
    
    if [ -z "$plugin" ]; then
        list_installed
        echo -n "$(yoga_ar 'Plugin name: ')"
        read -r plugin
    fi
    
    if ! is_plugin_installed "$plugin"; then
        yoga_fogo "❌ Plugin '$plugin' is not installed"
        return 1
    fi
    
    if [ -z "$version" ]; then
        # Show installed versions
        yoga_espirito "📋 Installed versions for $plugin:"
        echo ""
        asdf list "$plugin" 2>/dev/null
        echo ""
        echo -n "$(yoga_ar 'Version to uninstall: ')"
        read -r version
    fi
    
    if [ -z "$version" ]; then
        yoga_fogo "❌ No version specified"
        return 1
    fi
    
    yoga_agua "⚠️  This will uninstall $plugin $version"
    echo -n "$(yoga_ar 'Are you sure? (y/n): ')"
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy] ]]; then
        if asdf uninstall "$plugin" "$version"; then
            yoga_terra "✅ Successfully uninstalled $plugin $version"
        else
            yoga_fogo "❌ Failed to uninstall"
            return 1
        fi
    else
        yoga_agua "Cancelled"
    fi
}

# Update plugins
update_plugins() {
    yoga_espirito "🔄 Updating ASDF plugins..."
    echo ""
    
    local plugins=$(asdf plugin list 2>/dev/null)
    
    if [ -z "$plugins" ]; then
        yoga_agua "No plugins to update"
        return
    fi
    
    while IFS= read -r plugin; do
        yoga_ar "Updating $plugin..."
        asdf plugin update "$plugin" 2>/dev/null
    done <<< "$plugins"
    
    yoga_terra "✅ All plugins updated!"
}

# Quick setup for common languages
quick_setup() {
    yoga_espirito "⚡ Quick Setup - Common Development Languages"
    echo ""
    
    yoga_terra "Select languages to install:"
    echo ""
    
    local selections=()
    
    # Node.js
    if is_plugin_installed "nodejs"; then
        yoga_agua "  ✓ Node.js (already installed)"
    else
        echo -n "$(yoga_ar '  Install Node.js? (y/n): ')"
        read -r install_node
        [[ "$install_node" =~ ^[Yy] ]] && selections+=("nodejs")
    fi
    
    # Python
    if is_plugin_installed "python"; then
        yoga_agua "  ✓ Python (already installed)"
    else
        echo -n "$(yoga_ar '  Install Python? (y/n): ')"
        read -r install_python
        [[ "$install_python" =~ ^[Yy] ]] && selections+=("python")
    fi
    
    # Ruby
    if is_plugin_installed "ruby"; then
        yoga_agua "  ✓ Ruby (already installed)"
    else
        echo -n "$(yoga_ar '  Install Ruby? (y/n): ')"
        read -r install_ruby
        [[ "$install_ruby" =~ ^[Yy] ]] && selections+=("ruby")
    fi
    
    # Go
    if is_plugin_installed "golang"; then
        yoga_agua "  ✓ Go (already installed)"
    else
        echo -n "$(yoga_ar '  Install Go? (y/n): ')"
        read -r install_go
        [[ "$install_go" =~ ^[Yy] ]] && selections+=("golang")
    fi
    
    # Rust
    if is_plugin_installed "rust"; then
        yoga_agua "  ✓ Rust (already installed)"
    else
        echo -n "$(yoga_ar '  Install Rust? (y/n): ')"
        read -r install_rust
        [[ "$install_rust" =~ ^[Yy] ]] && selections+=("rust")
    fi
    
    if [ ${#selections[@]} -eq 0 ]; then
        yoga_agua "No new languages selected"
        return
    fi
    
    echo ""
    yoga_espirito "🚀 Installing selected languages..."
    echo ""
    
    for lang in "${selections[@]}"; do
        yoga_ar "Installing $lang..."
        
        # Add plugin
        if asdf plugin add "$lang" 2>/dev/null; then
            # Get latest stable version
            local version=$(asdf latest "$lang" 2>/dev/null)
            
            if [ -n "$version" ]; then
                yoga_ar "Installing $lang $version..."
                if asdf install "$lang" "$version"; then
                    asdf global "$lang" "$version"
                    yoga_terra "  ✅ $lang $version installed and set as global"
                else
                    yoga_fogo "  ❌ Failed to install $lang $version"
                fi
            else
                # Use predefined version (fallback)
                version="$(get_default_version "$lang")"
                yoga_ar "Installing $lang $version..."
                if asdf install "$lang" "$version"; then
                    asdf global "$lang" "$version"
                    yoga_terra "  ✅ $lang $version installed and set as global"
                else
                    yoga_fogo "  ❌ Failed to install $lang $version"
                fi
            fi
        else
            yoga_fogo "  ❌ Failed to add $lang plugin"
        fi
    done
    
    echo ""
    yoga_terra "✅ Quick setup complete!"
}

# Check for updates
check_updates() {
    yoga_espirito "🔍 Checking for updates..."
    echo ""
    
    local plugins=$(asdf plugin list 2>/dev/null)
    
    if [ -z "$plugins" ]; then
        yoga_agua "No plugins installed"
        return
    fi
    
    local updates_available=false
    
    while IFS= read -r plugin; do
        local current=$(get_current_version "$plugin")
        
        if [ -n "$current" ]; then
            local latest=$(asdf latest "$plugin" 2>/dev/null)
            
            if [ -n "$latest" ] && [ "$current" != "$latest" ]; then
                yoga_ar "  $plugin: $current → $latest available"
                updates_available=true
            else
                yoga_agua "  $plugin: $current (latest)"
            fi
        fi
    done <<< "$plugins"
    
    echo ""
    
    if [ "$updates_available" = true ]; then
        echo -n "$(yoga_ar 'Update all to latest versions? (y/n): ')"
        read -r update_all
        
        if [[ "$update_all" =~ ^[Yy] ]]; then
            while IFS= read -r plugin; do
                local latest=$(asdf latest "$plugin" 2>/dev/null)
                if [ -n "$latest" ]; then
                    yoga_ar "Updating $plugin to $latest..."
                    asdf install "$plugin" "$latest"
                    asdf global "$plugin" "$latest"
                fi
            done <<< "$plugins"
            yoga_terra "✅ All updates complete!"
        fi
    else
        yoga_terra "✅ Everything is up to date!"
    fi
}

# Main menu
main_menu() {
    while true; do
        clear
        yoga_fogo "═══════════════════════════════════════"
        yoga_espirito "       🔮 ASDF Version Manager"
        yoga_fogo "═══════════════════════════════════════"
        echo ""
        
        # Show brief status
        local plugin_count=$(asdf plugin list 2>/dev/null | wc -l | tr -d ' ')
        yoga_agua "  Plugins installed: $plugin_count"
        echo ""
        
        yoga_terra "Choose an option:"
        echo ""
        yoga_ar "  1) List installed languages"
        yoga_ar "  2) Quick setup (Node, Python, Ruby, Go, Rust)"
        yoga_ar "  3) Install new language/plugin"
        yoga_ar "  4) Install specific version"
        yoga_ar "  5) Set global/local version"
        yoga_ar "  6) Uninstall version"
        yoga_ar "  7) Check for updates"
        yoga_ar "  8) Update all plugins"
        yoga_ar "  9) Show ASDF info"
        yoga_agua "  0) Exit"
        echo ""
        echo -n "$(yoga_espirito 'Enter your choice: ')"
        read -r choice
        
        case "$choice" in
            1)
                clear
                list_installed
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            2)
                clear
                quick_setup
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            3)
                clear
                install_plugin
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            4)
                clear
                install_version
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            5)
                clear
                echo -n "$(yoga_ar 'Set global or local? (g/l): ')"
                read -r scope_choice
                
                if [[ "$scope_choice" =~ ^[Ll] ]]; then
                    set_version "" "" "local"
                else
                    set_version "" "" "global"
                fi
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            6)
                clear
                uninstall_version
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            7)
                clear
                check_updates
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            8)
                clear
                update_plugins
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            9)
                clear
                yoga_espirito "ℹ️  ASDF Information"
                echo ""
                yoga_ar "ASDF Version:"
                asdf version
                echo ""
                yoga_ar "ASDF Home:"
                echo "$ASDF_DIR"
                echo ""
                yoga_ar "Configuration:"
                echo "~/.tool-versions (global)"
                echo ".tool-versions (local)"
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            0)
                yoga_espirito "👋 Namaste! Your versions are in harmony."
                exit 0
                ;;
            *)
                yoga_fogo "Invalid option. Please try again."
                sleep 1
                ;;
        esac
    done
}

# CLI interface
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Being executed directly
    if [ $# -gt 0 ]; then
        case "$1" in
            list)
                list_installed
                ;;
            install)
                if [ -n "$2" ]; then
                    if [ -n "$3" ]; then
                        install_version "$2" "$3"
                    else
                        install_plugin "$2"
                    fi
                else
                    install_plugin
                fi
                ;;
            set)
                if [ -n "$2" ] && [ -n "$3" ]; then
                    set_version "$2" "$3" "${4:-global}"
                else
                    set_version
                fi
                ;;
            uninstall)
                uninstall_version "$2" "$3"
                ;;
            update)
                update_plugins
                ;;
            check)
                check_updates
                ;;
            quick)
                quick_setup
                ;;
            *)
                echo "Usage: $0 [list|install|set|uninstall|update|check|quick]"
                exit 1
                ;;
        esac
    else
        # No arguments, show interactive menu
        main_menu
    fi
fi
