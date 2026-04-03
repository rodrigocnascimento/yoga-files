# TDD: Interactive TUI Menus

## 1. Objective & Scope
**Objective:** Replace the existing `read`-based numeric menus across the Yoga Files shell scripts with a beautiful, modern, and interactive Text User Interface (TUI). This aligns with the Yoga philosophy of "Clarity" and "Aesthetics", providing a fluid navigation experience.

**Scope:**
- Create a reusable wrapper function (`yoga_menu` ou similar) that handles menu generation.
- Utilize `gum` as the primary TUI engine for beautiful selections (colors, cursors, descriptions).
- Implement a graceful fallback to `fzf` (if `gum` is missing) and finally to the traditional numeric `read` (if neither is available), ensuring zero breakage for users on minimal environments.
- Update `core/dashboard.sh` and related menus (like the project creator and git wizard) to use the new interactive menu wrapper.
- Add an installation command/check for `gum` inside the `yoga-doctor` or `install.sh` if appropriate.

## 2. Proposed Technical Strategy
**Tooling:**
- **Primary:** `gum` (by Charmbracelet). Provides aesthetic menus, spinners, and inputs.
- **Fallback 1:** `fzf`. Already available and standard for fast fuzzy-finding and selection.
- **Fallback 2:** Standard bash/zsh `read` with numeric mapping.

**Implementation Details:**
- **Core Wrapper:** Create a new file or add to `core/utils.sh` a function `yoga_interactive_menu`. 
  - Parameters: Title, list of options (can be separated by newline or array).
  - Return: The selected string or an exit code corresponding to the selection.
- **Graceful Degradation:**
  ```bash
  if command -v gum &> /dev/null; then
      # use gum choose
  elif command -v fzf &> /dev/null; then
      # use fzf
  else
      # fallback to read and echo numbers
  fi
  ```
- **Refactoring:** Map the `case` blocks in `core/dashboard.sh` from numeric keys (`1`, `2`) to the actual string values or maintain an associative array for matching strings to actions.

## 3. Implementation Plan
1. **Scaffold the Wrapper:** Implement the `yoga_interactive_menu` function in a core library (e.g., `core/tui.sh` or `core/utils.sh`).
2. **Test Fallbacks:** Ensure the fallback logic correctly routes to `gum`, `fzf`, and `read` depending on their availability in the `PATH`.
3. **Refactor Dashboard:** Update `yoga_dashboard` in `core/dashboard.sh` to pass the options to the new wrapper and process the string output instead of numbers.
4. **Refactor Sub-menus:** Update `yoga_create_project`, `yoga_docs`, and `yoga_ai_menu` to utilize the new TUI approach.
5. **Update Documentation / Doctor:** Advise the user to install `gum` (via homebrew: `brew install gum`) if it's missing to get the best experience, possibly adding a check in `yoga_doctor`.
