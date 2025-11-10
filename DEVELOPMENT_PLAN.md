# План разработки библиотеки SwiftRRule

## Обзор проекта

SwiftRRule — это Swift-библиотека для работы с правилами повторения событий (RRule) согласно стандарту RFC 5545 (iCalendar). Библиотека будет поддерживать парсинг, генерацию и вычисление дат на основе правил повторения.

## Цели проекта

1. **Парсинг RRule**: Преобразование строк RRule в структурированные объекты
2. **Генерация RRule**: Создание строк RRule из Swift-объектов
3. **Вычисление дат**: Генерация списка дат на основе правил повторения
4. **Кросс-платформенность**: Поддержка iOS, macOS, tvOS, watchOS и Linux (для Vapor)
5. **SPM интеграция**: Подключение через Swift Package Manager

## Архитектура библиотеки

### Структура модулей

```
SwiftRRule/
├── Sources/
│   └── SwiftRRule/
│       ├── Core/
│       │   ├── RRule.swift          # Основная структура RRule
│       │   ├── Frequency.swift      # Enum для частоты (DAILY, WEEKLY, etc.)
│       │   ├── Weekday.swift        # Enum для дней недели
│       │   └── RRuleParser.swift    # Парсер строк RRule
│       ├── Generator/
│       │   ├── DateGenerator.swift  # Генератор дат на основе правил
│       │   └── RRuleGenerator.swift # Генератор строк RRule
│       ├── Utils/
│       │   ├── CalendarExtensions.swift
│       │   └── DateExtensions.swift
│       └── SwiftRRule.swift         # Публичный API
├── Tests/
│   └── SwiftRRuleTests/
│       ├── RRuleParserTests.swift
│       ├── DateGeneratorTests.swift
│       └── RRuleGeneratorTests.swift
├── Package.swift
└── README.md
```

## Этапы разработки

### Этап 1: Базовая структура проекта (Неделя 1)

#### 1.1 Инициализация SPM проекта
- [ ] Создать `Package.swift` с конфигурацией для iOS и Linux
- [ ] Настроить минимальные версии платформ
- [ ] Создать базовую структуру директорий

#### 1.2 Основные типы данных
- [ ] Создать `Frequency` enum (DAILY, WEEKLY, MONTHLY, YEARLY)
- [ ] Создать `Weekday` enum с поддержкой BYDAY
- [ ] Создать структуру `RRule` с основными свойствами:
  - `frequency: Frequency`
  - `interval: Int?`
  - `count: Int?`
  - `until: Date?`
  - `bySecond: [Int]?`
  - `byMinute: [Int]?`
  - `byHour: [Int]?`
  - `byDay: [Weekday]?`
  - `byMonthDay: [Int]?`
  - `byYearDay: [Int]?`
  - `byWeekNo: [Int]?`
  - `byMonth: [Int]?`
  - `bySetPos: [Int]?`
  - `wkst: Weekday?` (week start)

### Этап 2: Парсинг RRule (Неделя 2-3)

#### 2.1 Парсер строк
- [ ] Реализовать `RRuleParser` для парсинга строки RRule
- [ ] Поддержка всех параметров RRule (FREQ, INTERVAL, COUNT, UNTIL, BY*)
- [ ] Валидация входных данных
- [ ] Обработка ошибок парсинга

#### 2.2 Тестирование парсера
- [ ] Unit-тесты для всех типов правил
- [ ] Тесты на граничные случаи
- [ ] Тесты на некорректные входные данные

### Этап 3: Генерация дат (Неделя 4-6)

#### 3.1 Алгоритм генерации дат
- [ ] Реализовать `DateGenerator` для вычисления дат
- [ ] Поддержка всех частот (DAILY, WEEKLY, MONTHLY, YEARLY)
- [ ] Реализация BY* правил:
  - BYDAY (дни недели)
  - BYMONTHDAY (дни месяца)
  - BYYEARDAY (дни года)
  - BYWEEKNO (недели года)
  - BYMONTH (месяцы)
  - BYSETPOS (позиции в наборе)
- [ ] Обработка COUNT и UNTIL
- [ ] Обработка INTERVAL

#### 3.2 Оптимизация производительности
- [ ] Кэширование промежуточных вычислений
- [ ] Оптимизация для больших диапазонов дат
- [ ] Поддержка ленивой генерации (Iterator pattern)

#### 3.3 Тестирование генератора
- [ ] Тесты для всех типов частот
- [ ] Тесты для комбинаций BY* правил
- [ ] Тесты производительности
- [ ] Сравнение с эталонными реализациями

### Этап 4: Генерация RRule строк (Неделя 7)

#### 4.1 Генератор строк
- [ ] Реализовать `RRuleGenerator` для создания строк RRule
- [ ] Форматирование всех параметров
- [ ] Оптимизация (опускать значения по умолчанию)

#### 4.2 Тестирование генератора
- [ ] Round-trip тесты (parse -> generate -> parse)
- [ ] Тесты на корректность формата

### Этап 5: Интеграция и документация (Неделя 8)

#### 5.1 Публичный API
- [ ] Создать удобный публичный API
- [ ] Поддержка Codable для сериализации
- [ ] Расширения для Foundation.Calendar

#### 5.2 Документация
- [ ] README с примерами использования
- [ ] Документация API (DocC)
- [ ] Примеры для iOS и Vapor
- [ ] Миграционный гайд (если есть)

#### 5.3 Интеграционные тесты
- [ ] Тесты интеграции с Vapor 4
- [ ] Тесты на iOS проекте
- [ ] Тесты на Linux

### Этап 6: Продвинутые функции (Опционально)

#### 6.1 Дополнительные возможности
- [ ] Поддержка EXDATE (исключенные даты)
- [ ] Поддержка RDATE (добавленные даты)
- [ ] Поддержка EXRULE (исключенные правила)
- [ ] Валидация правил
- [ ] Оптимизация для больших наборов дат

#### 6.2 Производительность
- [ ] Бенчмарки
- [ ] Профилирование и оптимизация
- [ ] Поддержка асинхронной генерации

## Технические требования

### Минимальные версии платформ
- iOS 13.0+
- macOS 10.15+
- tvOS 13.0+
- watchOS 6.0+
- Linux (Ubuntu 18.04+)

### Зависимости
- Swift 5.5+
- Foundation (встроенная)
- XCTest (для тестов)

### Стандарты
- RFC 5545 (iCalendar)
- RFC 5546 (iCalendar Transport-Independent Interoperability Protocol)

## Примеры использования

### Базовое использование

```swift
import SwiftRRule

// Парсинг RRule
let rruleString = "FREQ=DAILY;INTERVAL=2;COUNT=10"
let rrule = try RRule.parse(rruleString)

// Генерация дат
let startDate = Date()
let dates = rrule.generateDates(startingFrom: startDate)
// Результат: массив из 10 дат с интервалом 2 дня

// Генерация RRule строки
let newRRule = RRule(
    frequency: .weekly,
    interval: 1,
    byDay: [.monday, .wednesday, .friday]
)
let rruleString = newRRule.toString()
// Результат: "FREQ=WEEKLY;BYDAY=MO,WE,FR"
```

### Использование в Vapor 4

```swift
import Vapor
import SwiftRRule

struct Event: Content {
    let title: String
    let rrule: String
    let startDate: Date
}

func getEventDates(_ req: Request) throws -> EventResponse {
    let event = try req.content.decode(Event.self)
    let rrule = try RRule.parse(event.rrule)
    let dates = rrule.generateDates(startingFrom: event.startDate)
    
    return EventResponse(dates: dates)
}
```

### Использование в iOS

```swift
import SwiftRRule
import EventKit

func createRecurringEvent() {
    let rrule = RRule(
        frequency: .monthly,
        byMonthDay: [1], // Первое число каждого месяца
        count: 12
    )
    
    let startDate = Date()
    let dates = rrule.generateDates(startingFrom: startDate)
    
    // Создание событий в EventKit
    let eventStore = EKEventStore()
    // ... создание событий
}
```

## Тестирование

### Стратегия тестирования
1. **Unit-тесты**: Все компоненты по отдельности
2. **Integration-тесты**: Взаимодействие компонентов
3. **Regression-тесты**: Тесты на известные баги
4. **Performance-тесты**: Бенчмарки производительности

### Источники тестовых данных
- RFC 5545 примеры
- Библиотека rrule.js (JavaScript)
- Библиотека dateutil (Python)
- Пользовательские кейсы

## CI/CD

### Автоматизация
- [ ] GitHub Actions / GitLab CI
- [ ] Автоматические тесты на всех платформах
- [ ] Автоматическая генерация документации
- [ ] Проверка кода (SwiftLint)
- [ ] Измерение покрытия тестами

## Лицензия

Рекомендуется: MIT License (для максимальной совместимости)

## Следующие шаги

1. Создать репозиторий и настроить SPM
2. Начать с Этапа 1: Базовая структура проекта
3. Постепенно реализовывать функциональность по этапам
4. Регулярно тестировать на целевых платформах

