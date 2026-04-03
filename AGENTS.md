# AGENTS.md - Guidelines for AI Coding Agents in yoga-files Repository

## 🔧 Development Environment Overview

This repository contains the yoga-files development environment, which combines:
- ASDF for universal version management
- LazyVim (Neovim) as the primary editor
- Multiple AI provider integration (OpenAI, Gemini, GitHub Copilot, etc.)
- JavaScript/TypeScript focused tooling
- Yoga-themed UI/UX elements

## 🛠️ Build, Lint, and Test Commands

### JavaScript/TypeScript Projects
Based on config.yaml, the standard tools for JS/TS projects are:

```bash
# Development server
js-dev              # Equivalent to: npm run dev
npm run dev         # Alternative direct command

# Production build
js-build            # Equivalent to: npm run build
npm run build       # Alternative direct command

# Testing
js-test             # Equivalent to: npm run test
npm run test        # Alternative direct command
npm run test:watch  # Watch mode
npm run test:coverage # With coverage

# Code formatting and linting
js-fix              # Format code with Biome
npm run lint        # Lint with Biome
npm run format      # Format with Biome
npm run check       # Check formatting (CI)
```

### Running Individual Tests
To run a single test file or test case:

```bash
# Using Vitest (configured test runner)
npm test -- src/components/Button.test.tsx      # Specific file
npm test -- src/utils/math.test.ts -t "add"    # Specific test case
npm test -- --run src/services/                # Directory with --run flag
yoga-ai test "Button component"                # Yoga AI assisted test running
```

### Environment Setup Commands
```bash
# Initialize environment
source init.sh                  # Load yoga environment
yoga                            # Main dashboard
yoga-status                     # Environment status
yoga-doctor                     # Environment diagnostics

# Version management
asdf-menu                       # Interactive ASDF menu
node-version                    # Manage Node.js versions
typescript-version              # Manage TypeScript versions

# Yoga-specific commands
yoga-ai "help with command"     # AI assistance for command writing
yoga-ai fix "command"           # Fix incorrect commands
yoga-ai code "function"         # Generate code with AI
yoga-ai explain "code"          # Explain code functionality
yoga-ai debug "error"           # Debug error messages
```

## 📝 Code Style Guidelines

### File Organization
- Place JavaScript/TypeScript files in `src/` directory
- Components: `src/components/`
- Utilities: `src/utils/`
- Services: `src/services/`
- Styles: `src/styles/` or CSS-in-JS
- Tests: Same directory as source with `.test.*` suffix
- Configuration: Root directory or `config/`

### Import Order
Following Biome/TypeScript conventions:

```typescript
// 1. Type definitions and interfaces
import type { UserProps } from './types';

// 2. External libraries (alphabetical)
import React from 'react';
import { useState, useEffect } from 'react';
import axios from 'axios';

// 3. Internal modules (alphabetical by path)
import { useApi } from '@/hooks/useApi';
import { Button } from '@/components/ui/Button';
import { formatDate } from '@/utils/date';

// 4. Styles and assets
import './styles.css';
import logo from './logo.png';
```

### TypeScript Guidelines
- Enable strict mode in `tsconfig.json` (already configured)
- Prefer interfaces for object shapes, types for unions/primitives
- Use explicit return types for exported functions
- Avoid `any` type; use `unknown` when type is uncertain
- Prefer const assertions for literal objects: `const config = { ... } as const`

### Naming Conventions
- **Files**: kebab-case (`user-profile.component.tsx`)
- **Components**: PascalCase (`UserProfile`)
- **Functions/variables**: camelCase (`getUserData`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRY_ATTEMPTS`)
- **Types/Interfaces**: PascalCase (`UserProps`, `ApiResponse`)
- **Hooks**: Prefix with `use` (`useFetchData`, `useFormValidation`)
- **Events**: Prefix with `handle` (`handleClick`, `handleSubmit`)
- **Boolean variables**: Prefix with `is/has/can/should` (`isLoading`, `hasError`)

### Formatting (Biome Configuration)
- **Indent**: 2 spaces (no tabs)
- **Line width**: 100 characters
- **Semicolons**: Required
- **Quotes**: Single quotes for strings, template literals for interpolation
- **Commas**: Trailing commas in multi-line arrays/objects
- **Braces**: Same-line for blocks, multi-line for complex objects
- **Imports**: One per line, grouped as shown above
- **JSX**: Self-closing when no children, space before closing slash

### Error Handling
- **Async functions**: Use try/catch or `.catch()` for Promises
- **API calls**: Check for network errors and HTTP status codes
- **Validation**: Validate inputs early with descriptive error messages
- **Logging**: Use console.error for unexpected states, console.warn for recoverable issues
- **User feedback**: Provide clear, actionable error messages to users
- **Type safety**: Use discriminated unions for error states rather than throwing

### React-Specific Guidelines
- **Components**: Prefer function components with hooks
- **Props**: Destructure in function signature with defaults
- **State**: Use useState for primitive values, useReducer for complex objects
- **Effects**: Always include dependency array, clean up subscriptions/timers
- **Performance**: Use useMemo/useCallback for expensive computations
- **Keys**: Use stable, predictable keys in lists (not array indices)
- **Fragments**: Use `<>` for simple wrappers, `<Fragment>` when needing key

### Git Commit Conventions
Following the yoga-theme commit style from CONTRIBUTING.md:
- 🔥 feat: New feature
- 🐛 fix: Bug fix
- 🌿 docs: Documentation changes
- 💄 style: Formatting, missing semicolons, etc.
- ⚡ perf: Performance improvements
- 🧪 test: Adding or updating tests
- 🤖 chore: Build process, CI, dependencies
- ♻️ refactor: Code restructuring without behavior change
- 🚜 ci: CI configuration changes
- 📦 build: Build system changes
- 🎉 init: Initial commit
- 🔒 security: Security-related fixes

### Yoga-Specific Conventions
- Use yoga-themed comments for section headers: `# 🔥 Fire Section`, `# 💧 Water Section`
- Terminal output should use yoga color scheme when possible
- Error messages should include appropriate yoga emojis:
  - 🔥 for errors/action items
  - 💧 for informational messages
  - 🌿 for success/positive feedback
  - 🌬️ for process/flow indicators
  - 🧘 for completion/peace indicators

## 🤖 AI Agent Specific Guidelines

### When Assisted by AI Agents
- The yoga-files environment supports multiple AI providers including OpenAI, Gemini, GitHub Copilot, Claude, and others
- You can specify your preferred AI provider in the config.yaml file under preferences.ai_provider
- Supported providers: openai, gemini, copilot, claude
- There are no Cursor-specific rules (.cursor/rules/ or .cursorrules) in this repository
- There are no GitHub Copilot-specific instructions (.github/copilot-instructions.md) in this repository
- AI provider selection is managed through config.yaml preferences
- Leverage `yoga-ai explain` for understanding existing code
- Use `yoga-ai fix` for correcting command syntax
- Employ `yoga-ai code` for generating boilerplate or standard patterns
- Apply `yoga-ai review` for code quality checks before submitting
- Utilize `yoga-ai optimize` for performance improvements

### Code Generation Standards
When generating code, ensure:
1. Follows established import/order conventions
2. Includes proper TypeScript typing
3. Handles errors appropriately
4. Includes JSDoc comments for exported functions
5. Follows naming conventions for the repository
6. Includes test cases when applicable
7. Respects file size limits (prefer smaller, focused modules)

### Documentation Requirements
- All public functions must have JSDoc comments
- Complex algorithms should include explanatory comments
- Configuration changes require README/docs updates
- New features should update relevant documentation files
- Examples should be provided for non-obvious APIs

## 🧪 Testing Practices

### Unit Tests
- Test file naming: `[name].test.[tj]sx`
- Place tests alongside source files
- Follow AAA pattern: Arrange, Act, Assert
- Mock external dependencies
- Test both success and failure cases
- Use descriptive test names that explain behavior

### Test Utilities
- Custom renderers for React components with providers
- Test data factories for consistent mock data
- Utility functions for common test operations
- Mock implementations for external services

### Coverage Thresholds
- Aim for >90% coverage on new code
- Critical paths (auth, payment, data validation) should be >95%
- Configuration and simple wrappers may be exempt with justification

## 🔍 Debugging Guidelines

### Logging
- Use appropriate log levels (debug, info, warn, error)
- Include contextual information in logs
- Avoid logging sensitive data (tokens, passwords)
- Use structured logging when possible for production debugging

### Developer Experience
- Keep console.log to minimum in production code
- Remove debugging statements before committing
- Use yoga-ai debug for error analysis
- Leverage browser devtools and source maps effectively

## 🚫 Things to Avoid

### Code Quality
- ❌ Magic numbers/names without explanation
- ❌ Long functions (>50 lines) without clear separation
- ❌ Deeply nested conditionals (>3 levels)
- ❌ Duplicate code (extract to utilities)
- ❌ Blocking operations in async contexts
- ❌ Ignoring returned Promises
- ❌ Mutable data in Redux/state contexts (use immer or immutability helpers)

### Performance
- ❌ Heavy computations in render loops
- ❌ Unnecessary re-renders (missing useMemo/useCallback)
- ❌ Large bundle imports (use dynamic import when appropriate)
- ❌ Synchronous operations in event listeners
- ❌ Memory leaks (unsubscribe from events, clear intervals)

### Security
- ❌ Hardcoded secrets or API keys
- ❌ Direct DOM manipulation when framework alternatives exist
- ❌ XSS vulnerabilities (use dangerouslySetInnerHTML sparingly)
- ❌ CSRF unprotected endpoints
- ❌ Insecure HTTP usage (always prefer HTTPS)

## 📚 Reference Files

Key files to consult for specifics:
- `config.yaml` - Primary configuration for tools and preferences
- `README.md` - Comprehensive usage guide and command reference
- `docs/` directory - Detailed guides for each subsystem
- `tests/` directory - Examples of testing patterns
- `core/` directory - Internal yoga-files implementations
- `bin/` directory - Executable yoga commands

## 🔄 Workflow Recommendations

1. **Start**: `source init.sh` to load environment
2. **Explore**: `yoga-status` to see current state
3. **Develop**: Use `js-dev` for frontend work
4. **Test Frequently**: `js-test` with watch mode during development
5. **Format**: `js-fix` before committing
6. **Review**: `yoga-ai review` for AI-assisted code review
7. **Commit**: Use emoji-prefixed commit messages per guidelines
8. **Push**: Ensure CI passes before merging

This environment emphasizes developer experience with intelligent tooling, consistent formatting, and yoga-themed feedback to promote mindful, productive coding sessions.