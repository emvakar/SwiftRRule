# SwiftRRule

![Swift](https://img.shields.io/badge/Swift-6.0+-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-lightgrey.svg)
![Tests](https://github.com/emvakar/SwiftRRule/actions/workflows/test.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Status](https://img.shields.io/badge/status-active%20development-yellow.svg)

[English](README.md) | [Русский](README.ru.md)

Swift library for working with recurrence rules (RRule) according to RFC 5545 (iCalendar) standard.

## Description

SwiftRRule allows you to parse, generate, and calculate dates based on recurrence rules. The library is fully compatible with RFC 5545 standard and can be used in both iOS/macOS applications and server-side applications on Vapor 4.

## Features

- ✅ RRule string parsing
- ✅ RRule string generation
- ✅ Date calculation based on recurrence rules
- ✅ Support for all frequencies (DAILY, WEEKLY, MONTHLY, YEARLY)
- ✅ Support for all BY* rules
- ✅ Cross-platform (iOS, macOS, tvOS, watchOS, Linux)
- ✅ Swift Package Manager integration

## Requirements

### Platforms

- **iOS** 13.0+
- **macOS** 10.15+
- **tvOS** 13.0+
- **watchOS** 6.0+
- **Linux** (Ubuntu 18.04+)

### Language and Tools

- **Swift** 6.0+
- **Xcode** 16.0+ (for development on Apple platforms)
- **Swift Package Manager** (built into Swift 6.0+)

## Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/SwiftRRule.git", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Packages...
2. Enter the repository URL
3. Select the version

## Usage

### Basic Usage

```swift
import SwiftRRule

// Create RRule
let rrule = RRule(
    frequency: .daily,
    interval: 2,
    count: 10
)

// Parse RRule
let parsedRRule = try RRule.parse("FREQ=DAILY;INTERVAL=2;COUNT=10")

// Parse complex rules
let weeklyRule = try RRule.parse("FREQ=WEEKLY;BYDAY=MO,WE,FR;COUNT=10")
let monthlyRule = try RRule.parse("FREQ=MONTHLY;BYMONTHDAY=1,15")

// Generate dates
let dates = rrule.generateDates(startingFrom: Date())
// Result: array of dates matching the recurrence rule

// Generate RRule string
let rruleString = rrule.toString()
// Result: "FREQ=DAILY;INTERVAL=2;COUNT=10"
```

## Testing

The library has comprehensive test coverage:

- **Total tests**: 430
- **Status**: ✅ All tests pass successfully
- **Coverage**: 
  - RRule parsing (99 tests)
  - RRule string generation (91 tests)
  - Date generation (164 tests)
  - Core RRule structure (48 tests)
  - Frequency enum (28 tests)
  - Weekday structure (57 tests)

All tests verify:
- ✅ Basic functionality
- ✅ Edge cases
- ✅ Error handling
- ✅ Input validation
- ✅ Real-world usage scenarios
- ✅ Cross-platform compatibility

## Development Status

🚧 **Library is in active development**

Current status:
- ✅ Basic project structure
- ✅ Core data types (Frequency, Weekday, RRule)
- ✅ RRule parsing
- ✅ Date generation
- ✅ RRule string generation
- ✅ Comprehensive test coverage (430 tests)

## Documentation

- [English Documentation](docs/README.en.md)
- [Русская Документация](docs/README.ru.md)

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Authors

Created for use in Eskaria projects.

## Links

- [RFC 5545 - iCalendar](https://tools.ietf.org/html/rfc5545)
- [RFC 5546 - iCalendar Transport-Independent Interoperability Protocol](https://tools.ietf.org/html/rfc5546)
