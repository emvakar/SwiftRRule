# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CONTRIBUTING.md - contribution guide
- CODE_OF_CONDUCT.md - code of conduct
- CHANGELOG.md - changelog
- SECURITY.md - security policy
- Issue and pull request templates
- Dependabot configuration

## [1.0.0] - TBD

### Added
- Basic project structure
- Core data types (Frequency, Weekday, RRule)
- RRule string parsing according to RFC 5545
- RRule string generation
- Date generation based on recurrence rules
- Support for all frequencies (DAILY, WEEKLY, MONTHLY, YEARLY)
- Support for all BY* rules:
  - BYSECOND, BYMINUTE, BYHOUR
  - BYDAY, BYMONTHDAY, BYYEARDAY
  - BYWEEKNO, BYMONTH, BYSETPOS
- Support for WKST (week start day)
- Support for COUNT and UNTIL
- Cross-platform support (iOS, macOS, tvOS, watchOS, Linux)
- Swift Package Manager integration
- Comprehensive test coverage (430 tests)
- Documentation in English and Russian

### Technical Details
- Minimum Swift version: 6.0+
- Minimum platform versions:
  - iOS 13.0+
  - macOS 10.15+
  - tvOS 13.0+
  - watchOS 6.0+
  - Linux (Ubuntu 18.04+)

---

[Unreleased]: https://github.com/emvakar/SwiftRRule/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/emvakar/SwiftRRule/releases/tag/v1.0.0
