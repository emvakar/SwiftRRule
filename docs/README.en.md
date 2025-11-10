# SwiftRRule Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Core Concepts](#core-concepts)
5. [API Reference](#api-reference)
6. [Examples](#examples)
7. [Best Practices](#best-practices)

## Introduction

SwiftRRule is a Swift library for parsing, generating, and calculating dates based on recurrence rules (RRule) according to the RFC 5545 (iCalendar) standard. It provides a type-safe, cross-platform solution for working with recurring events.

### Key Features

- **Type-safe**: All RRule components are represented as Swift types
- **Cross-platform**: Works on iOS, macOS, tvOS, watchOS, and Linux
- **RFC 5545 compliant**: Fully compatible with the iCalendar standard
- **Comprehensive**: Supports all frequencies and BY* rules
- **Well-tested**: 430+ tests covering all functionality

## Installation

### Swift Package Manager

Add SwiftRRule to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/emvakar/SwiftRRule.git", from: "1.0.0")
]
```

Then add it to your target:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["SwiftRRule"]
    )
]
```

### Xcode

1. File → Add Packages...
2. Enter: `https://github.com/emvakar/SwiftRRule.git`
3. Select version and add to your target

## Quick Start

### Basic Example

```swift
import SwiftRRule

// Create a daily recurrence rule
let dailyRule = RRule(
    frequency: .daily,
    interval: 2,
    count: 10
)

// Generate dates starting from today
let startDate = Date()
let dates = dailyRule.generateDates(startingFrom: startDate)

// Print the dates
for date in dates {
    print(date)
}
```

### Parse from String

```swift
// Parse an RRule string
let rruleString = "FREQ=WEEKLY;BYDAY=MO,WE,FR;COUNT=10"
let rrule = try RRule.parse(rruleString)

// Generate dates
let dates = rrule.generateDates(startingFrom: Date())
```

### Generate RRule String

```swift
// Create an RRule
let rrule = RRule(
    frequency: .monthly,
    byMonthDay: [1, 15],
    count: 12
)

// Convert to string
let rruleString = rrule.toString()
// Result: "FREQ=MONTHLY;BYMONTHDAY=1,15;COUNT=12"
```

## Core Concepts

### Frequency

The frequency determines how often the event repeats:

- `.daily` - Every day
- `.weekly` - Every week
- `.monthly` - Every month
- `.yearly` - Every year

### Interval

The interval specifies how often the recurrence repeats. For example, `interval: 2` with `.weekly` means every 2 weeks.

### Count and Until

You can limit the number of occurrences using:
- `count` - Maximum number of occurrences
- `until` - End date for the recurrence

### BY* Rules

BY* rules allow you to specify which occurrences match:

- `bySecond` - Specific seconds (0-59)
- `byMinute` - Specific minutes (0-59)
- `byHour` - Specific hours (0-23)
- `byDay` - Specific days of the week
- `byMonthDay` - Specific days of the month (1-31 or -31 to -1)
- `byYearDay` - Specific days of the year (1-366 or -366 to -1)
- `byWeekNo` - Specific weeks of the year (1-53 or -53 to -1)
- `byMonth` - Specific months (1-12)
- `bySetPos` - Specific positions in the set (-366 to 366)

## API Reference

### RRule

The main structure representing a recurrence rule.

#### Initialization

```swift
init(
    frequency: Frequency,
    interval: Int? = nil,
    count: Int? = nil,
    until: Date? = nil,
    bySecond: [Int]? = nil,
    byMinute: [Int]? = nil,
    byHour: [Int]? = nil,
    byDay: [Weekday]? = nil,
    byMonthDay: [Int]? = nil,
    byYearDay: [Int]? = nil,
    byWeekNo: [Int]? = nil,
    byMonth: [Int]? = nil,
    bySetPos: [Int]? = nil,
    wkst: Weekday? = nil
)
```

#### Methods

##### parse(_:)

Parse an RRule string into an `RRule` object.

```swift
static func parse(_ string: String) throws -> RRule
```

**Throws**: `RRuleParseError` if the string is invalid.

##### generateDates(startingFrom:calendar:)

Generate dates based on the recurrence rule.

```swift
func generateDates(startingFrom startDate: Date, calendar: Calendar = .current) -> [Date]
```

**Parameters**:
- `startDate`: The starting date for generation
- `calendar`: The calendar to use (defaults to `.current`)

**Returns**: Array of dates matching the recurrence rule.

##### toString()

Convert the RRule to a string representation.

```swift
func toString() -> String
```

**Returns**: RRule string in RFC 5545 format.

### Frequency

Enum representing the frequency of recurrence.

```swift
enum Frequency: String, Codable, CaseIterable {
    case daily = "DAILY"
    case weekly = "WEEKLY"
    case monthly = "MONTHLY"
    case yearly = "YEARLY"
}
```

### Weekday

Structure representing a day of the week with optional position.

```swift
struct Weekday: Codable, Equatable, Hashable {
    let dayOfWeek: Int  // 1 = Sunday, 2 = Monday, ..., 7 = Saturday
    let position: Int?  // Optional position (1-53 or -53 to -1)
}
```

#### Convenience Initializers

```swift
static let sunday: Weekday
static let monday: Weekday
static let tuesday: Weekday
static let wednesday: Weekday
static let thursday: Weekday
static let friday: Weekday
static let saturday: Weekday
```

#### Parsing

```swift
init?(from string: String)
```

Parse a weekday from a string (e.g., "MO", "1MO", "-1FR").

## Examples

### Daily Recurrence

```swift
// Every day
let daily = RRule(frequency: .daily)

// Every 2 days, 10 times
let everyTwoDays = RRule(
    frequency: .daily,
    interval: 2,
    count: 10
)

// Every day at 9 AM and 5 PM
let dailyWithHours = RRule(
    frequency: .daily,
    byHour: [9, 17]
)
```

### Weekly Recurrence

```swift
// Every Monday, Wednesday, Friday
let weekdays = RRule(
    frequency: .weekly,
    byDay: [.monday, .wednesday, .friday]
)

// Every 2 weeks on Monday and Friday
let biweekly = RRule(
    frequency: .weekly,
    interval: 2,
    byDay: [.monday, .friday]
)
```

### Monthly Recurrence

```swift
// First and 15th of every month
let monthly = RRule(
    frequency: .monthly,
    byMonthDay: [1, 15]
)

// First Monday of every month
let firstMonday = RRule(
    frequency: .monthly,
    byDay: [Weekday(dayOfWeek: 2, position: 1)]
)

// Last day of every month
let lastDay = RRule(
    frequency: .monthly,
    byMonthDay: [-1]
)
```

### Yearly Recurrence

```swift
// Every January and June
let yearly = RRule(
    frequency: .yearly,
    byMonth: [1, 6]
)

// Last Friday of December
let lastFridayDecember = RRule(
    frequency: .yearly,
    byMonth: [12],
    byDay: [Weekday(dayOfWeek: 6, position: -1)]
)
```

### Complex Examples

```swift
// Every weekday at 9 AM and 5 PM
let workHours = RRule(
    frequency: .daily,
    byDay: [.monday, .tuesday, .wednesday, .thursday, .friday],
    byHour: [9, 17]
)

// Every 3 months on the 1st, until end of 2025
let quarterly = RRule(
    frequency: .monthly,
    interval: 3,
    byMonthDay: [1],
    until: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 31))!
)
```

## Best Practices

### Use Explicit Calendar

When generating dates, always use an explicit calendar to avoid timezone issues:

```swift
let calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "UTC")!

let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
```

### Error Handling

Always handle parsing errors:

```swift
do {
    let rrule = try RRule.parse("FREQ=DAILY;COUNT=10")
    // Use rrule
} catch RRuleParseError.missingFrequency {
    // Handle missing frequency
} catch RRuleParseError.invalidValue(let value, let key) {
    // Handle invalid value
} catch {
    // Handle other errors
}
```

### Performance

For large date ranges, consider using `count` or `until` to limit the number of generated dates:

```swift
// Good: Limited to 100 dates
let rrule = RRule(frequency: .daily, count: 100)

// Avoid: May generate thousands of dates
let rrule = RRule(frequency: .daily)  // No limit
```

### Round-trip Testing

Always test round-trip conversion:

```swift
let original = "FREQ=WEEKLY;BYDAY=MO,WE,FR;COUNT=10"
let rrule = try RRule.parse(original)
let generated = rrule.toString()
let reparsed = try RRule.parse(generated)

// Verify properties match
XCTAssertEqual(rrule.frequency, reparsed.frequency)
XCTAssertEqual(rrule.count, reparsed.count)
```

## License

MIT License - see [LICENSE](../LICENSE) file for details.

