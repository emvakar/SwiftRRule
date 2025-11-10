# История изменений

Все значительные изменения в этом проекте будут документироваться в этом файле.

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/),
и этот проект придерживается [Semantic Versioning](https://semver.org/lang/ru/).

## [Неопубликовано]

### Добавлено
- CONTRIBUTING.md - руководство для контрибьюторов
- CODE_OF_CONDUCT.md - кодекс поведения
- CHANGELOG.md - история изменений
- SECURITY.md - политика безопасности
- Шаблоны для issues и pull requests
- Dependabot конфигурация

## [1.0.0] - TBD

### Добавлено
- Базовая структура проекта
- Основные типы данных (Frequency, Weekday, RRule)
- Парсинг строк RRule согласно RFC 5545
- Генерация строк RRule
- Генерация дат на основе правил повторения
- Поддержка всех частот (DAILY, WEEKLY, MONTHLY, YEARLY)
- Поддержка всех BY* правил:
  - BYSECOND, BYMINUTE, BYHOUR
  - BYDAY, BYMONTHDAY, BYYEARDAY
  - BYWEEKNO, BYMONTH, BYSETPOS
- Поддержка WKST (день начала недели)
- Поддержка COUNT и UNTIL
- Кросс-платформенная поддержка (iOS, macOS, tvOS, watchOS, Linux)
- Swift Package Manager интеграция
- Полное покрытие тестами (430 тестов)
- Документация на английском и русском языках

### Технические детали
- Минимальная версия Swift: 6.0+
- Минимальные версии платформ:
  - iOS 13.0+
  - macOS 10.15+
  - tvOS 13.0+
  - watchOS 6.0+
  - Linux (Ubuntu 18.04+)

---

[Неопубликовано]: https://github.com/emvakar/SwiftRRule/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/emvakar/SwiftRRule/releases/tag/v1.0.0

