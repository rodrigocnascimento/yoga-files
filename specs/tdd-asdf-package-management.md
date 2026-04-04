# TDD: ASDF Package Management Integration

## 1. Objective & Scope
**Objective:** Enhance the existing ASDF integration in yoga-files to provide a seamless, yoga-themed experience for managing language runtimes (packages) through ASDF, following the user's preference for interactive menu-based interaction.

**Scope:**
- Create a yoga-specific wrapper command (`yoga asdf`) that provides easy access to ASDF package management functionality
- Add yoga-themed aliases for common ASDF operations (install, remove, list, set version, update, check)
- Enhance the existing ASDF interactive script with better yoga integration (colors, messaging, formatting)
- Provide clear examples and documentation for common package management operations
- Maintain compatibility with existing ASDF functionality while improving user experience

## 2. Proposed Technical Strategy
**Tooling:**
- Leverage existing ASDF installation and core functionality
- Utilize existing yoga color and utility functions from `core/utils.sh`
- Build upon the existing ASDF interactive manager at `core/version-managers/asdf/interactive.sh`

**Implementation Details:**
1. **Yoga ASDf Wrapper Command:** Create `bin/yoga-asdf` as a thin wrapper that delegates to the existing interactive script while ensuring proper yoga environment loading
2. **Yoga-Specific Aliases:** Add ASDF-related aliases to `config.yaml` for direct command access
3. **Enhanced Interactive Experience:** Modify the existing ASDF interactive script to use yoga color functions more consistently and provide better visual feedback
4. **Documentation & Examples:** Create clear usage examples for common operations (install, remove, list versions, etc.)

**Key Files to Modify/Create:**
- `bin/yoga-asdf` - New wrapper command
- `config.yaml` - Add ASDF aliases
- `core/version-managers/asdf/interactive.sh` - Enhance with better yoga integration (optional)
- `docs/` - Add usage examples (optional)

## 3. Implementation Plan
1. **Create Yoga ASDf Wrapper (`bin/yoga-asdf`):**
   - Create executable script that sources yoga environment and delegates to existing ASDF interactive script
   - Ensure proper error handling and environment setup

2. **Add ASDF Aliases to Configuration:**
   - Update `config.yaml` with aliases for common ASDF operations:
     - `asdf-list`: List installed languages/versions
     - `asdf-install`: Install new language/plugin
     - `asdf-remove`: Uninstall language version
     - `asdf-set`: Set global/local version
     - `asdf-update`: Update all plugins
     - `asdf-check`: Check for available updates

3. **Enhance ASDF Interactive Script (Optional):**
   - Improve use of yoga color functions for better visual consistency
   - Ensure yoga-themed messaging throughout the interactive experience

4. **Validation & Documentation:**
   - Verify all existing ASDF functionality continues to work
   - Create usage examples in documentation
   - Test the new yoga-asdf command and aliases

This approach leverages the existing robust ASDF integration while providing a more yoga-consistent interface for package management operations.