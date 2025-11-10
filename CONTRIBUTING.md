# Contributing to SwiftRRule

Thank you for your interest in SwiftRRule! We're happy to have your contribution. This guide will help you understand the process of contributing to the project.

## Code of Conduct

This project adheres to the [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold its terms.

## How to Contribute

### Reporting Bugs

If you found a bug:

1. Check if it has already been reported in [Issues](https://github.com/emvakar/SwiftRRule/issues)
2. If the bug hasn't been reported yet, create a new issue with:
   - What happened
   - What should have happened
   - Steps to reproduce
   - Swift version and platform
   - Code example (if possible)

### Suggesting New Features

If you have an idea for a new feature:

1. Check if it has already been suggested in [Issues](https://github.com/emvakar/SwiftRRule/issues)
2. Create a new issue describing:
   - What problem this feature solves
   - How you envision the implementation
   - Usage examples

### Pull Requests

We welcome pull requests! Here's the process:

1. **Fork the repository**
2. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```
3. **Make your changes** following the code standards (see below)
4. **Add tests** for new features or fixes
5. **Ensure all tests pass**:
   ```bash
   swift test
   ```
6. **Update documentation** if necessary
7. **Create a Pull Request** with a description of your changes

## Code Standards

### Code Style

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use formatting consistent with existing code
- All comments and documentation should be in Russian (for code comments)
- Use MARK comments to organize code

### Commit Structure

- Use clear commit messages
- Start the message with a capital letter
- Use imperative mood ("Add" not "Added")
- Examples:
  - `Add support for BYSETPOS`
  - `Fix parsing BYDAY with negative values`
  - `Update documentation`

### Testing

- All new features must have tests
- Tests should cover edge cases
- Ensure all tests pass before creating a PR
- Aim for test coverage of all public APIs

### Documentation

- Document all public APIs with `///` comments
- Update README.md if adding new features
- Update CHANGELOG.md for significant changes

## Development Process

### Setting Up the Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/emvakar/SwiftRRule.git
   cd SwiftRRule
   ```

2. Ensure you have Swift 6.0+ installed:
   ```bash
   swift --version
   ```

3. Build the project:
   ```bash
   swift build
   ```

4. Run tests:
   ```bash
   swift test
   ```

### Project Structure

```
SwiftRRule/
├── Sources/
│   └── SwiftRRule/
│       ├── Core/          # Core types and parsing
│       └── Generator/     # Date and string generation
├── Tests/
│   └── SwiftRRuleTests/   # Tests
└── docs/                  # Documentation
```

### Working with Branches

- `main` - stable version
- `develop` - development branch
- `feature/*` - new features
- `fix/*` - bug fixes

## Questions?

If you have questions, create an issue with the `question` label or contact the project maintainers.

## License

By contributing to the project, you agree that your changes will be licensed under the same MIT license as the project.

Thank you for your contribution! 🎉

---

[Русская версия](CONTRIBUTING.ru.md)
