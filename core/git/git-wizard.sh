#!/bin/bash
#
# 🧙 Git Profile Wizard
# Interactive Git profile management for multi-account setups
#

YOGA_HOME="${YOGA_HOME:-$HOME/.yoga}"

# Source utilities
source "$YOGA_HOME/core/utils.sh"

# Git profiles storage
GIT_PROFILES_FILE="$YOGA_HOME/config/git-profiles.yaml"

# Create git profiles file if it doesn't exist
ensure_git_profiles_file() {
    if [ ! -f "$GIT_PROFILES_FILE" ]; then
        mkdir -p "$(dirname "$GIT_PROFILES_FILE")"
        cat > "$GIT_PROFILES_FILE" << 'EOF'
# Git Profiles Configuration
# Managed by yoga-files git wizard
profiles:
  personal:
    name: ""
    email: ""
    signingkey: ""
    default: true
  work:
    name: ""
    email: ""
    signingkey: ""
    default: false
EOF
        yoga_terra "🌱 Created git profiles configuration"
    fi
}

# Show current Git configuration
show_current_config() {
    yoga_espirito "🧘 Current Git Configuration"
    echo ""
    
    local name=$(git config --global user.name 2>/dev/null)
    local email=$(git config --global user.email 2>/dev/null)
    local signingkey=$(git config --global user.signingkey 2>/dev/null)
    
    if [ -n "$name" ]; then
        yoga_ar "  Name: $name"
    else
        yoga_agua "  Name: <not set>"
    fi
    
    if [ -n "$email" ]; then
        yoga_ar "  Email: $email"
    else
        yoga_agua "  Email: <not set>"
    fi
    
    if [ -n "$signingkey" ]; then
        yoga_ar "  Signing Key: $signingkey"
    else
        yoga_agua "  Signing Key: <not set>"
    fi
    
    echo ""
}

# List available profiles
list_profiles() {
    yoga_espirito "📋 Available Profiles"
    echo ""
    
    if [ -f "$GIT_PROFILES_FILE" ]; then
        # Parse YAML and show profiles
        while IFS= read -r line; do
            if [[ $line =~ ^[[:space:]]+name:[[:space:]]\"(.+)\" ]]; then
                local profile_name="${BASH_REMATCH[1]}"
                if [ -n "$profile_name" ]; then
                    yoga_ar "  • $profile_name"
                fi
            fi
        done < "$GIT_PROFILES_FILE"
    else
        yoga_agua "  No profiles configured yet"
    fi
    
    echo ""
}

# Add new profile
add_profile() {
    yoga_espirito "➕ Add New Git Profile"
    echo ""
    
    # Profile identifier
    echo -n "$(yoga_ar 'Profile name (e.g., personal, work, oss): ')"
    read -r profile_id
    
    if [ -z "$profile_id" ]; then
        yoga_fogo "❌ Profile name cannot be empty"
        return 1
    fi
    
    # Git name
    echo -n "$(yoga_ar 'Git name: ')"
    read -r git_name
    
    if [ -z "$git_name" ]; then
        yoga_fogo "❌ Git name cannot be empty"
        return 1
    fi
    
    # Git email
    echo -n "$(yoga_ar 'Git email: ')"
    read -r git_email
    
    if [ -z "$git_email" ]; then
        yoga_fogo "❌ Git email cannot be empty"
        return 1
    fi
    
    # Signing key (optional)
    echo -n "$(yoga_ar 'GPG signing key (optional, press Enter to skip): ')"
    read -r signing_key
    
    # Save to profiles file
    ensure_git_profiles_file
    
    # Append profile to YAML
    cat >> "$GIT_PROFILES_FILE" << EOF
  $profile_id:
    name: "$git_name"
    email: "$git_email"
    signingkey: "$signing_key"
    default: false
EOF
    
    yoga_terra "✅ Profile '$profile_id' added successfully!"
    
    # Ask if user wants to switch to this profile
    echo ""
    echo -n "$(yoga_ar 'Switch to this profile now? (y/n): ')"
    read -r switch_now
    
    if [[ "$switch_now" =~ ^[Yy] ]]; then
        switch_profile "$profile_id" "$git_name" "$git_email" "$signing_key"
    fi
}

# Switch to a profile
switch_profile() {
    local profile_id="$1"
    local git_name="$2"
    local git_email="$3"
    local signing_key="$4"
    
    if [ -z "$git_name" ]; then
        # Read from profiles file
        if [ -f "$GIT_PROFILES_FILE" ]; then
            # Parse the profile from YAML (simplified)
            local in_profile=false
            while IFS= read -r line; do
                if [[ $line =~ ^[[:space:]]+${profile_id}: ]]; then
                    in_profile=true
                elif [[ $line =~ ^[[:space:]]+[^[:space:]].*: ]] && [ "$in_profile" = true ]; then
                    if [[ ! $line =~ ^[[:space:]]{4,} ]]; then
                        break
                    fi
                elif [ "$in_profile" = true ]; then
                    if [[ $line =~ name:[[:space:]]\"(.+)\" ]]; then
                        git_name="${BASH_REMATCH[1]}"
                    elif [[ $line =~ email:[[:space:]]\"(.+)\" ]]; then
                        git_email="${BASH_REMATCH[1]}"
                    elif [[ $line =~ signingkey:[[:space:]]\"(.*)\" ]]; then
                        signing_key="${BASH_REMATCH[1]}"
                    fi
                fi
            done < "$GIT_PROFILES_FILE"
        fi
    fi
    
    if [ -z "$git_name" ] || [ -z "$git_email" ]; then
        yoga_fogo "❌ Profile '$profile_id' not found or incomplete"
        return 1
    fi
    
    yoga_espirito "🔄 Switching to profile: $profile_id"
    
    # Set global git config
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    
    if [ -n "$signing_key" ]; then
        git config --global user.signingkey "$signing_key"
        git config --global commit.gpgsign true
    else
        git config --global --unset user.signingkey 2>/dev/null
        git config --global commit.gpgsign false
    fi
    
    yoga_terra "✅ Switched to profile: $profile_id"
    yoga_ar "  Name: $git_name"
    yoga_ar "  Email: $git_email"
    if [ -n "$signing_key" ]; then
        yoga_ar "  Signing: Enabled"
    fi
}

# Interactive profile selector
select_profile() {
    yoga_espirito "🎯 Select Git Profile"
    echo ""
    
    # Get profiles from file
    local profiles=()
    local profile_names=()
    local profile_emails=()
    
    if [ -f "$GIT_PROFILES_FILE" ]; then
        local current_profile=""
        local current_name=""
        local current_email=""
        local current_key=""
        
        while IFS= read -r line; do
            if [[ $line =~ ^[[:space:]]+([^:]+): ]] && [[ ! $line =~ ^[[:space:]]{4,} ]]; then
                if [ -n "$current_profile" ] && [ -n "$current_name" ]; then
                    profiles+=("$current_profile")
                    profile_names+=("$current_name")
                    profile_emails+=("$current_email")
                fi
                current_profile="${BASH_REMATCH[1]}"
                current_name=""
                current_email=""
                current_key=""
            elif [[ $line =~ name:[[:space:]]\"(.+)\" ]]; then
                current_name="${BASH_REMATCH[1]}"
            elif [[ $line =~ email:[[:space:]]\"(.+)\" ]]; then
                current_email="${BASH_REMATCH[1]}"
            fi
        done < "$GIT_PROFILES_FILE"
        
        # Add the last profile
        if [ -n "$current_profile" ] && [ -n "$current_name" ]; then
            profiles+=("$current_profile")
            profile_names+=("$current_name")
            profile_emails+=("$current_email")
        fi
    fi
    
    if [ ${#profiles[@]} -eq 0 ]; then
        yoga_agua "No profiles available. Please add one first."
        return 1
    fi
    
    # Show profiles
    local i=1
    for profile in "${profiles[@]}"; do
        yoga_ar "  $i) $profile - ${profile_names[$i-1]} <${profile_emails[$i-1]}>"
        ((i++))
    done
    
    echo ""
    echo -n "$(yoga_ar 'Select profile (number): ')"
    read -r selection
    
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#profiles[@]} ]; then
        local selected_profile="${profiles[$selection-1]}"
        switch_profile "$selected_profile"
    else
        yoga_fogo "❌ Invalid selection"
        return 1
    fi
}

# Configure repository-specific profile
configure_repo_profile() {
    yoga_espirito "📁 Configure Repository-Specific Profile"
    echo ""
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        yoga_fogo "❌ Not in a git repository"
        return 1
    fi
    
    local repo_name=$(basename "$(git rev-parse --show-toplevel)")
    yoga_ar "Repository: $repo_name"
    echo ""
    
    # Show available profiles and let user select
    select_profile_for_repo() {
        local profiles=()
        if [ -f "$GIT_PROFILES_FILE" ]; then
            while IFS= read -r line; do
                if [[ $line =~ ^[[:space:]]+([^:]+): ]] && [[ ! $line =~ ^[[:space:]]{4,} ]]; then
                    profiles+=("${BASH_REMATCH[1]}")
                fi
            done < "$GIT_PROFILES_FILE"
        fi
        
        if [ ${#profiles[@]} -eq 0 ]; then
            yoga_agua "No profiles available"
            return 1
        fi
        
        local i=1
        for profile in "${profiles[@]}"; do
            yoga_ar "  $i) $profile"
            ((i++))
        done
        
        echo ""
        echo -n "$(yoga_ar 'Select profile for this repository: ')"
        read -r selection
        
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#profiles[@]} ]; then
            local selected_profile="${profiles[$selection-1]}"
            
            # Get profile details and set local config
            local git_name=""
            local git_email=""
            local signing_key=""
            local in_profile=false
            
            while IFS= read -r line; do
                if [[ $line =~ ^[[:space:]]+${selected_profile}: ]]; then
                    in_profile=true
                elif [[ $line =~ ^[[:space:]]+[^[:space:]].*: ]] && [ "$in_profile" = true ]; then
                    if [[ ! $line =~ ^[[:space:]]{4,} ]]; then
                        break
                    fi
                elif [ "$in_profile" = true ]; then
                    if [[ $line =~ name:[[:space:]]\"(.+)\" ]]; then
                        git_name="${BASH_REMATCH[1]}"
                    elif [[ $line =~ email:[[:space:]]\"(.+)\" ]]; then
                        git_email="${BASH_REMATCH[1]}"
                    elif [[ $line =~ signingkey:[[:space:]]\"(.*)\" ]]; then
                        signing_key="${BASH_REMATCH[1]}"
                    fi
                fi
            done < "$GIT_PROFILES_FILE"
            
            if [ -n "$git_name" ] && [ -n "$git_email" ]; then
                git config user.name "$git_name"
                git config user.email "$git_email"
                
                if [ -n "$signing_key" ]; then
                    git config user.signingkey "$signing_key"
                    git config commit.gpgsign true
                fi
                
                yoga_terra "✅ Repository configured with profile: $selected_profile"
                yoga_ar "  Name: $git_name"
                yoga_ar "  Email: $git_email"
            else
                yoga_fogo "❌ Failed to configure repository"
            fi
        else
            yoga_fogo "❌ Invalid selection"
        fi
    }
    
    select_profile_for_repo
}

# Main menu
main_menu() {
    while true; do
        clear
        yoga_fogo "═══════════════════════════════════════"
        yoga_espirito "       🧙 Git Profile Wizard"
        yoga_fogo "═══════════════════════════════════════"
        echo ""
        
        show_current_config
        
        yoga_terra "Choose an option:"
        echo ""
        yoga_ar "  1) List profiles"
        yoga_ar "  2) Switch profile"
        yoga_ar "  3) Add new profile"
        yoga_ar "  4) Configure repository profile"
        yoga_ar "  5) Edit profiles file"
        yoga_agua "  0) Exit"
        echo ""
        echo -n "$(yoga_espirito 'Enter your choice: ')"
        read -r choice
        
        case "$choice" in
            1)
                clear
                list_profiles
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            2)
                clear
                select_profile
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            3)
                clear
                add_profile
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            4)
                clear
                configure_repo_profile
                echo ""
                echo -n "$(yoga_agua 'Press Enter to continue...')"
                read -r
                ;;
            5)
                ensure_git_profiles_file
                ${EDITOR:-vim} "$GIT_PROFILES_FILE"
                ;;
            0)
                yoga_espirito "👋 Namaste! May your commits be meaningful."
                exit 0
                ;;
            *)
                yoga_fogo "Invalid option. Please try again."
                sleep 1
                ;;
        esac
    done
}

# Check if being sourced or executed
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Being executed directly

    # If arguments provided, handle them
    if [ $# -gt 0 ]; then
        case "$1" in
            list)
                ensure_git_profiles_file
                list_profiles
                ;;
            switch)
                ensure_git_profiles_file
                if [ -n "$2" ]; then
                    switch_profile "$2"
                else
                    select_profile
                fi
                ;;
            add)
                add_profile
                ;;
            repo)
                ensure_git_profiles_file
                configure_repo_profile
                ;;
            current)
                show_current_config
                ;;
            *)
                echo "Usage: $0 [list|switch|add|repo|current]"
                exit 1
                ;;
        esac
    else
        # No arguments, show interactive menu
        ensure_git_profiles_file
        main_menu
    fi
fi
