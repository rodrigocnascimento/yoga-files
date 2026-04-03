# Yoga Files Coding Standards

## Philosophy
Following the Yoga philosophy, our code should embody:
- 🧘 **Clarity and Simplicity**: Clean, readable solutions
- 🔥 **Energy and Performance**: Efficient, optimized code
- 💧 **Adaptability (Water)**: Flexible, maintainable implementations
- 🌿 **Stability (Earth)**: Robust, reliable functionality
- 🌬️ **Innovation (Air)**: Creative, forward-thinking approaches
- 🧘 **Spirit (Consciousness)**: Continuous learning and improvement

## Shell Script Standards

### General Principles
1. **Prefer explicit over implicit**
2. **Handle errors gracefully**
3. **Validate inputs rigorously**
4. **Avoid dangerous patterns (eval, unchecked sudo, etc.)**
5. **Check dependencies before use**
6. **Provide clear user feedback**
7. **Maintain backward compatibility**
8. **Keep functions small and focused**

### File Structure
1. **Shebang**: Use `#!/usr/bin/env zsh` for portability
2. **Header**: Include file description and version
3. **Sections**: Clearly separated with comments
4. **Order**: Constants → Functions → Main execution

### Naming Conventions
1. **Functions**: `snake_case` with descriptive names
2. **Variables**: `snake_case`, `UPPER_CASE` for constants
3. **Yoga Functions**: Prefix with `yoga_` for messaging functions
4. **Private Functions**: Prefix with `_` for internal use

### Error Handling
1. **Check return codes**: Always validate command success
2. **Provide meaningful errors**: Help users understand issues
3. **Fail gracefully**: Don't break the user's shell
4. **Use subshells**: For operations that change state

### Security Practices
1. **NEVER use eval** with untrusted input
2. **Avoid backticks** in favor of `$(command)`
3. **Validate all inputs**: Especially for system commands
4. **Use least privilege**: Avoid sudo when possible
5. **Sanitize outputs**: Prevent injection attacks

### Performance Considerations
1. **Cache expensive operations**: When appropriate
2. **Avoid unnecessary subshells**: They're expensive
3. **Use builtins**: Prefer shell builtins over external commands
4. **Limit external dependencies**: Only when they provide significant value

### Documentation
1. **Every function**: Should have a comment explaining purpose
2. **Complex logic**: Needs inline comments
3. **Public API**: Document parameters and return values
4. **Examples**: Provide usage examples when helpful

### Specific Patterns to Avoid
1. **Eval**: Especially with user input or variables
2. **Unchecked sudo**: Always validate what's being run with sudo
3. **Hardcoded paths**: Use variables or detect dynamically
4. **Assumed tools**: Always check for command availability
5. **Silent failures**: Always provide feedback on errors

### Yoga-Specific Standards
1. **Use yoga_* functions**: For consistent messaging and coloring
2. **Follow element semantics**: Match function purpose to yoga elements
3. **Maintain theme consistency**: Colors and emojis should align
4. **Provide flow states**: Help users feel in sync with their workflow

## Implementation Examples

### Good: Safe Function with Validation
```bash
function safe_port_killer {
  local port=$1
  
  # Input validation
  if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
    yoga_fogo "❌ Invalid port: $port (must be 1-65535)"
    return 1
  fi
  
  # Dependency check
  if ! command -v lsof &>/dev/null; then
    yoga_sol "⚠️ lsof not found. Install lsof for port management."
    return 1
  fi
  
  # Safe execution
  local pid=$(lsof -n -i :$port | grep LISTEN | awk '{print $2}')
  if [ -n "$pid" ]; then
    kill -9 "$pid"
    yoga_terra "✅ Killed process on port $port (PID: $pid)"
  else
    yoga_agua "ℹ️ No process found on port $port"
  fi
}
```

### Avoid: Unsafe Patterns
```bash
# DON'T: Unsafe eval with user input
function bad_example {
  eval "$1"  # Dangerous!
}

# DON'T: Unchecked sudo
function bad_sudo {
  sudo $(history -p !!)  # Could run anything with sudo
}

# DON'T: No input validation
function bad_port_func {
  lsof -i :$1  # No validation of $1
}
```

## Testing Guidelines
1. **Unit tests**: Test functions in isolation
2. **Integration tests**: Test workflows and interactions
3. **Edge cases**: Test invalid inputs, missing dependencies
4. **Error conditions**: Verify proper error handling
5. **Cleanup**: Ensure tests don't leave side effects

## Review Process
1. **Security first**: Check for vulns, unsafe patterns
2. **Functionality**: Does it solve the intended problem?
3. **Readability**: Is the code clear and maintainable?
4. **Performance**: Are there obvious inefficiencies?
5. **Standards compliance**: Does it follow these guidelines?
6. **Documentation**: Is it properly documented?
7. **Testing**: Are tests adequate and passing?

## Exceptions
Any deviation from these standards must be:
1. **Well justified**: Clear benefit outweighing risk
2. **Documented**: Explained in code comments
3. **Reviewed**: Approved during code review
4. **Limited in scope**: Minimal necessary deviation

---

*Last updated: $(date)*
*These standards evolve with our practice - revisit regularly.*