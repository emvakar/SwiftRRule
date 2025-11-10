# Документация SwiftRRule

## Содержание

1. [Введение](#введение)
2. [Установка](#установка)
3. [Быстрый старт](#быстрый-старт)
4. [Основные концепции](#основные-концепции)
5. [Справочник API](#справочник-api)
6. [Примеры](#примеры)
7. [Лучшие практики](#лучшие-практики)

## Введение

SwiftRRule — это Swift-библиотека для парсинга, генерации и вычисления дат на основе правил повторения (RRule) согласно стандарту RFC 5545 (iCalendar). Она предоставляет типобезопасное, кросс-платформенное решение для работы с повторяющимися событиями.

### Ключевые возможности

- **Типобезопасность**: Все компоненты RRule представлены как Swift-типы
- **Кросс-платформенность**: Работает на iOS, macOS, tvOS, watchOS и Linux
- **Соответствие RFC 5545**: Полная совместимость со стандартом iCalendar
- **Полнота**: Поддержка всех частот и BY* правил
- **Хорошо протестировано**: 430+ тестов, покрывающих всю функциональность

## Установка

### Swift Package Manager

Добавьте SwiftRRule в ваш `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/SwiftRRule.git", from: "1.0.0")
]
```

Затем добавьте в ваш target:

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
2. Введите: `https://github.com/your-username/SwiftRRule.git`
3. Выберите версию и добавьте в ваш target

## Быстрый старт

### Базовый пример

```swift
import SwiftRRule

// Создать правило ежедневного повторения
let dailyRule = RRule(
    frequency: .daily,
    interval: 2,
    count: 10
)

// Сгенерировать даты начиная с сегодня
let startDate = Date()
let dates = dailyRule.generateDates(startingFrom: startDate)

// Вывести даты
for date in dates {
    print(date)
}
```

### Парсинг из строки

```swift
// Распарсить строку RRule
let rruleString = "FREQ=WEEKLY;BYDAY=MO,WE,FR;COUNT=10"
let rrule = try RRule.parse(rruleString)

// Сгенерировать даты
let dates = rrule.generateDates(startingFrom: Date())
```

### Генерация строки RRule

```swift
// Создать RRule
let rrule = RRule(
    frequency: .monthly,
    byMonthDay: [1, 15],
    count: 12
)

// Преобразовать в строку
let rruleString = rrule.toString()
// Результат: "FREQ=MONTHLY;BYMONTHDAY=1,15;COUNT=12"
```

## Основные концепции

### Frequency (Частота)

Частота определяет, как часто событие повторяется:

- `.daily` - Каждый день
- `.weekly` - Каждую неделю
- `.monthly` - Каждый месяц
- `.yearly` - Каждый год

### Interval (Интервал)

Интервал указывает, как часто повторяется повторение. Например, `interval: 2` с `.weekly` означает каждые 2 недели.

### Count и Until

Вы можете ограничить количество повторений используя:
- `count` - Максимальное количество повторений
- `until` - Дата окончания повторения

### BY* Правила

BY* правила позволяют указать, какие повторения соответствуют:

- `bySecond` - Конкретные секунды (0-59)
- `byMinute` - Конкретные минуты (0-59)
- `byHour` - Конкретные часы (0-23)
- `byDay` - Конкретные дни недели
- `byMonthDay` - Конкретные дни месяца (1-31 или -31 до -1)
- `byYearDay` - Конкретные дни года (1-366 или -366 до -1)
- `byWeekNo` - Конкретные недели года (1-53 или -53 до -1)
- `byMonth` - Конкретные месяцы (1-12)
- `bySetPos` - Конкретные позиции в наборе (-366 до 366)

## Справочник API

### RRule

Основная структура, представляющая правило повторения.

#### Инициализация

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

#### Методы

##### parse(_:)

Распарсить строку RRule в объект `RRule`.

```swift
static func parse(_ string: String) throws -> RRule
```

**Throws**: `RRuleParseError` если строка невалидна.

##### generateDates(startingFrom:calendar:)

Сгенерировать даты на основе правила повторения.

```swift
func generateDates(startingFrom startDate: Date, calendar: Calendar = .current) -> [Date]
```

**Параметры**:
- `startDate`: Начальная дата для генерации
- `calendar`: Календарь для использования (по умолчанию `.current`)

**Возвращает**: Массив дат, соответствующих правилу повторения.

##### toString()

Преобразовать RRule в строковое представление.

```swift
func toString() -> String
```

**Возвращает**: Строку RRule в формате RFC 5545.

### Frequency

Enum, представляющий частоту повторения.

```swift
enum Frequency: String, Codable, CaseIterable {
    case daily = "DAILY"
    case weekly = "WEEKLY"
    case monthly = "MONTHLY"
    case yearly = "YEARLY"
}
```

### Weekday

Структура, представляющая день недели с опциональной позицией.

```swift
struct Weekday: Codable, Equatable, Hashable {
    let dayOfWeek: Int  // 1 = Воскресенье, 2 = Понедельник, ..., 7 = Суббота
    let position: Int?  // Опциональная позиция (1-53 или -53 до -1)
}
```

#### Удобные инициализаторы

```swift
static let sunday: Weekday
static let monday: Weekday
static let tuesday: Weekday
static let wednesday: Weekday
static let thursday: Weekday
static let friday: Weekday
static let saturday: Weekday
```

#### Парсинг

```swift
init?(from string: String)
```

Распарсить день недели из строки (например, "MO", "1MO", "-1FR").

## Примеры

### Ежедневное повторение

```swift
// Каждый день
let daily = RRule(frequency: .daily)

// Каждые 2 дня, 10 раз
let everyTwoDays = RRule(
    frequency: .daily,
    interval: 2,
    count: 10
)

// Каждый день в 9:00 и 17:00
let dailyWithHours = RRule(
    frequency: .daily,
    byHour: [9, 17]
)
```

### Еженедельное повторение

```swift
// Каждый понедельник, среду и пятницу
let weekdays = RRule(
    frequency: .weekly,
    byDay: [.monday, .wednesday, .friday]
)

// Каждые 2 недели в понедельник и пятницу
let biweekly = RRule(
    frequency: .weekly,
    interval: 2,
    byDay: [.monday, .friday]
)
```

### Ежемесячное повторение

```swift
// 1-е и 15-е число каждого месяца
let monthly = RRule(
    frequency: .monthly,
    byMonthDay: [1, 15]
)

// Первый понедельник каждого месяца
let firstMonday = RRule(
    frequency: .monthly,
    byDay: [Weekday(dayOfWeek: 2, position: 1)]
)

// Последний день каждого месяца
let lastDay = RRule(
    frequency: .monthly,
    byMonthDay: [-1]
)
```

### Ежегодное повторение

```swift
// Каждый январь и июнь
let yearly = RRule(
    frequency: .yearly,
    byMonth: [1, 6]
)

// Последняя пятница декабря
let lastFridayDecember = RRule(
    frequency: .yearly,
    byMonth: [12],
    byDay: [Weekday(dayOfWeek: 6, position: -1)]
)
```

### Сложные примеры

```swift
// Каждый рабочий день в 9:00 и 17:00
let workHours = RRule(
    frequency: .daily,
    byDay: [.monday, .tuesday, .wednesday, .thursday, .friday],
    byHour: [9, 17]
)

// Каждые 3 месяца 1-го числа, до конца 2025 года
let quarterly = RRule(
    frequency: .monthly,
    interval: 3,
    byMonthDay: [1],
    until: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 31))!
)
```

## Лучшие практики

### Используйте явный календарь

При генерации дат всегда используйте явный календарь, чтобы избежать проблем с часовыми поясами:

```swift
let calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "UTC")!

let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
```

### Обработка ошибок

Всегда обрабатывайте ошибки парсинга:

```swift
do {
    let rrule = try RRule.parse("FREQ=DAILY;COUNT=10")
    // Использовать rrule
} catch RRuleParseError.missingFrequency {
    // Обработать отсутствие частоты
} catch RRuleParseError.invalidValue(let value, let key) {
    // Обработать невалидное значение
} catch {
    // Обработать другие ошибки
}
```

### Производительность

Для больших диапазонов дат рассмотрите использование `count` или `until` для ограничения количества генерируемых дат:

```swift
// Хорошо: Ограничено 100 датами
let rrule = RRule(frequency: .daily, count: 100)

// Избегайте: Может сгенерировать тысячи дат
let rrule = RRule(frequency: .daily)  // Без ограничения
```

### Тестирование round-trip

Всегда тестируйте round-trip преобразование:

```swift
let original = "FREQ=WEEKLY;BYDAY=MO,WE,FR;COUNT=10"
let rrule = try RRule.parse(original)
let generated = rrule.toString()
let reparsed = try RRule.parse(generated)

// Проверить, что свойства совпадают
XCTAssertEqual(rrule.frequency, reparsed.frequency)
XCTAssertEqual(rrule.count, reparsed.count)
```

## Лицензия

MIT License - см. файл [LICENSE](../LICENSE) для деталей.

