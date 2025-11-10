# Security Policy

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------- |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                 |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it via email to [contact email] instead of using the public issue tracker.

### What to Include in Your Report

Please include the following information in your report:

- Type of vulnerability (e.g., XSS, SQL injection, etc.)
- Full path to the affected file
- Minimal code required to reproduce the issue
- Steps to reproduce
- Potential impact of the vulnerability
- Suggestions for fixes (if any)

### Process

1. We will acknowledge receipt of your report within 48 hours
2. We will assess the vulnerability and inform you of our findings within 7 days
3. If the vulnerability is confirmed, we will:
   - Work on a fix
   - Prepare a release with the fix
   - Publish the fix and acknowledge your contribution (if you wish)

### Recognition

We value the efforts of security researchers and would be happy to acknowledge your contribution in the project's security section if you agree.

## Security Best Practices

When using SwiftRRule:

1. **Input Validation**: Always validate input data before parsing RRule
2. **Error Handling**: Handle parsing errors appropriately
3. **Updates**: Regularly update the library to the latest version
4. **Resource Limits**: When generating large sets of dates, use limits (COUNT, UNTIL)

## Known Limitations

- The library does not validate input data for potentially dangerous strings
- Generating very large sets of dates may lead to performance issues

## Contact

For security questions: [contact email]

---

**Thank you for helping keep SwiftRRule secure!**

---

[Русская версия](SECURITY.ru.md)
