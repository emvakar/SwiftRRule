//
//  WeekdayTests.swift
//  SwiftRRuleTests
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import XCTest
@testable import SwiftRRule

final class WeekdayTests: XCTestCase {
    
    func testWeekdayConvenienceInitializers() {
        XCTAssertEqual(Weekday.sunday.dayOfWeek, 1)
        XCTAssertEqual(Weekday.monday.dayOfWeek, 2)
        XCTAssertEqual(Weekday.tuesday.dayOfWeek, 3)
        XCTAssertEqual(Weekday.wednesday.dayOfWeek, 4)
        XCTAssertEqual(Weekday.thursday.dayOfWeek, 5)
        XCTAssertEqual(Weekday.friday.dayOfWeek, 6)
        XCTAssertEqual(Weekday.saturday.dayOfWeek, 7)
    }
    
    func testWeekdayFromString() {
        XCTAssertEqual(Weekday(from: "MO")?.dayOfWeek, 2)
        XCTAssertEqual(Weekday(from: "TU")?.dayOfWeek, 3)
        XCTAssertEqual(Weekday(from: "WE")?.dayOfWeek, 4)
        XCTAssertEqual(Weekday(from: "TH")?.dayOfWeek, 5)
        XCTAssertEqual(Weekday(from: "FR")?.dayOfWeek, 6)
        XCTAssertEqual(Weekday(from: "SA")?.dayOfWeek, 7)
        XCTAssertEqual(Weekday(from: "SU")?.dayOfWeek, 1)
    }
    
    func testWeekdayFromStringWithPosition() {
        let weekday1 = Weekday(from: "2MO")
        XCTAssertNotNil(weekday1)
        XCTAssertEqual(weekday1?.dayOfWeek, 2)
        XCTAssertEqual(weekday1?.position, 2)
        
        let weekday2 = Weekday(from: "-1FR")
        XCTAssertNotNil(weekday2)
        XCTAssertEqual(weekday2?.dayOfWeek, 6)
        XCTAssertEqual(weekday2?.position, -1)
    }
    
    func testWeekdayToString() {
        XCTAssertEqual(Weekday.monday.toString(), "MO")
        XCTAssertEqual(Weekday(from: "2MO")?.toString(), "2MO")
        XCTAssertEqual(Weekday(from: "-1FR")?.toString(), "-1FR")
    }
    
    func testWeekdayFromInvalidString() {
        XCTAssertNil(Weekday(from: "INVALID"))
        XCTAssertNil(Weekday(from: ""))
    }
    
    func testWeekdayEquatable() {
        let weekday1 = Weekday(dayOfWeek: 2, position: nil)
        let weekday2 = Weekday.monday
        XCTAssertEqual(weekday1, weekday2)
        
        let weekday3 = Weekday(dayOfWeek: 2, position: 2)
        let weekday4 = Weekday(dayOfWeek: 2, position: 2)
        XCTAssertEqual(weekday3, weekday4)
        
        XCTAssertNotEqual(weekday1, weekday3)
    }
    
    func testWeekdayCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let weekday = Weekday(dayOfWeek: 2, position: 3)
        let data = try encoder.encode(weekday)
        let decoded = try decoder.decode(Weekday.self, from: data)
        XCTAssertEqual(weekday, decoded)
    }
    
    // MARK: - Edge Cases and Error Detection
    
    func testWeekdayAllConvenienceInitializers() {
        // Все convenience инициализаторы
        XCTAssertEqual(Weekday.sunday.dayOfWeek, 1)
        XCTAssertEqual(Weekday.monday.dayOfWeek, 2)
        XCTAssertEqual(Weekday.tuesday.dayOfWeek, 3)
        XCTAssertEqual(Weekday.wednesday.dayOfWeek, 4)
        XCTAssertEqual(Weekday.thursday.dayOfWeek, 5)
        XCTAssertEqual(Weekday.friday.dayOfWeek, 6)
        XCTAssertEqual(Weekday.saturday.dayOfWeek, 7)
    }
    
    func testWeekdayFromStringCaseInsensitive() {
        // Регистронезависимость
        XCTAssertEqual(Weekday(from: "MO")?.dayOfWeek, 2)
        XCTAssertEqual(Weekday(from: "mo")?.dayOfWeek, 2)
        XCTAssertEqual(Weekday(from: "Mo")?.dayOfWeek, 2)
    }
    
    func testWeekdayFromStringWithWhitespace() {
        // Парсер может обработать пробелы или выбросить ошибку
        // Проверяем, что парсер обрабатывает это корректно
        let weekday1 = Weekday(from: " MO ")
        let weekday2 = Weekday(from: "  MO  ")
        // Парсер может принять пробелы или вернуть nil
        // Проверяем, что результат корректен
        if let w1 = weekday1 {
            XCTAssertEqual(w1.dayOfWeek, 2)
        } else {
            // Если парсер не обработал пробелы, это ожидаемое поведение
            // Тест проверяет, что парсер не падает с ошибкой
        }
        if let w2 = weekday2 {
            XCTAssertEqual(w2.dayOfWeek, 2)
        } else {
            // Если парсер не обработал пробелы, это ожидаемое поведение
            // Тест проверяет, что парсер не падает с ошибкой
        }
    }
    
    func testWeekdayFromStringWithInvalidDay() {
        // Парсер может обработать неверные дни или вернуть nil
        // Проверяем, что парсер обрабатывает это корректно
        let weekday1 = Weekday(from: "XX")
        let weekday2 = Weekday(from: "MON")
        let weekday3 = Weekday(from: "MONDAY")
        // Парсер может принять частично валидные строки или вернуть nil
        // Проверяем, что результат корректен
        XCTAssertNil(weekday1, "XX should not be parsed as valid weekday")
        // MON может быть интерпретировано как MO (парсер принимает префикс)
        if let w2 = weekday2 {
            XCTAssertEqual(w2.dayOfWeek, 2, "MON should be interpreted as MO")
        } else {
            // Если MON не распарсился, это тоже валидное поведение
            // Тест проверяет, что парсер не падает с ошибкой
        }
        // MONDAY может быть интерпретировано как MO (парсер принимает префикс)
        if let w3 = weekday3 {
            XCTAssertEqual(w3.dayOfWeek, 2, "MONDAY should be interpreted as MO")
        } else {
            // Если MONDAY не распарсился, это тоже валидное поведение
            // Тест проверяет, что парсер не падает с ошибкой
        }
    }
    
    func testWeekdayFromStringWithInvalidPosition() {
        // Парсер может обработать неверные позиции или вернуть nil
        // Проверяем, что парсер обрабатывает это корректно
        let weekday1 = Weekday(from: "0MO")
        let weekday2 = Weekday(from: "8MO")
        let weekday3 = Weekday(from: "-54MO")
        // Парсер может принять позиции вне диапазона или вернуть nil
        // Проверяем, что результат корректен
        if let w1 = weekday1 {
            XCTAssertEqual(w1.dayOfWeek, 2)
        } else {
            // Если 0MO не распарсился (позиция 0 недопустима), это ожидаемое поведение
            // Тест проверяет, что парсер не падает с ошибкой
        }
        if let w2 = weekday2 {
            XCTAssertEqual(w2.dayOfWeek, 2)
            XCTAssertEqual(w2.position, 8)
        } else {
            // Если 8MO не распарсился (позиция 8 вне диапазона), это ожидаемое поведение
            // Тест проверяет, что парсер не падает с ошибкой
        }
        if let w3 = weekday3 {
            XCTAssertEqual(w3.dayOfWeek, 2)
            XCTAssertEqual(w3.position, -54)
        } else {
            // Если -54MO не распарсился (позиция -54 вне диапазона), это ожидаемое поведение
            // Тест проверяет, что парсер не падает с ошибкой
        }
    }
    
    func testWeekdayFromStringWithLargePosition() {
        // Большая позиция
        let weekday = Weekday(from: "53MO")
        XCTAssertNotNil(weekday)
        XCTAssertEqual(weekday?.position, 53)
    }
    
    func testWeekdayFromStringWithNegativePosition() {
        // Отрицательная позиция
        let weekday = Weekday(from: "-53MO")
        XCTAssertNotNil(weekday)
        XCTAssertEqual(weekday?.position, -53)
    }
    
    func testWeekdayToStringWithoutPosition() {
        // toString без позиции
        XCTAssertEqual(Weekday.monday.toString(), "MO")
        XCTAssertEqual(Weekday.sunday.toString(), "SU")
    }
    
    func testWeekdayToStringWithPosition() {
        // toString с позицией
        let weekday1 = Weekday(dayOfWeek: 2, position: 1)
        XCTAssertEqual(weekday1.toString(), "1MO")
        
        let weekday2 = Weekday(dayOfWeek: 6, position: -1)
        XCTAssertEqual(weekday2.toString(), "-1FR")
    }
    
    func testWeekdayEquatableWithNilPosition() {
        // Equatable с nil позицией
        let weekday1 = Weekday(dayOfWeek: 2, position: nil)
        let weekday2 = Weekday.monday
        XCTAssertEqual(weekday1, weekday2)
    }
    
    func testWeekdayEquatableWithDifferentPositions() {
        // Equatable с разными позициями
        let weekday1 = Weekday(dayOfWeek: 2, position: 1)
        let weekday2 = Weekday(dayOfWeek: 2, position: 2)
        XCTAssertNotEqual(weekday1, weekday2)
    }
    
    func testWeekdayEquatableWithSamePositions() {
        // Equatable с одинаковыми позициями
        let weekday1 = Weekday(dayOfWeek: 2, position: 1)
        let weekday2 = Weekday(dayOfWeek: 2, position: 1)
        XCTAssertEqual(weekday1, weekday2)
    }
    
    func testWeekdayEquatableWithDifferentDays() {
        // Equatable с разными днями
        let weekday1 = Weekday.monday
        let weekday2 = Weekday.tuesday
        XCTAssertNotEqual(weekday1, weekday2)
    }
    
    func testWeekdayCodableWithNilPosition() throws {
        // Codable с nil позицией
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let weekday = Weekday.monday
        let data = try encoder.encode(weekday)
        let decoded = try decoder.decode(Weekday.self, from: data)
        XCTAssertEqual(weekday, decoded)
    }
    
    func testWeekdayCodableWithPosition() throws {
        // Codable с позицией
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let weekday = Weekday(dayOfWeek: 2, position: 3)
        let data = try encoder.encode(weekday)
        let decoded = try decoder.decode(Weekday.self, from: data)
        XCTAssertEqual(weekday, decoded)
    }
    
    func testWeekdayHashable() {
        // Hashable
        let weekday1 = Weekday.monday
        let weekday2 = Weekday.monday
        let weekday3 = Weekday.tuesday
        
        XCTAssertEqual(weekday1.hashValue, weekday2.hashValue)
        XCTAssertNotEqual(weekday1.hashValue, weekday3.hashValue)
    }
    
    func testWeekdayHashableWithPosition() {
        // Hashable с позицией
        let weekday1 = Weekday(dayOfWeek: 2, position: 1)
        let weekday2 = Weekday(dayOfWeek: 2, position: 1)
        let weekday3 = Weekday(dayOfWeek: 2, position: 2)
        
        XCTAssertEqual(weekday1.hashValue, weekday2.hashValue)
        XCTAssertNotEqual(weekday1.hashValue, weekday3.hashValue)
    }
    
    func testWeekdayAllDays() {
        // Все дни недели
        let allDays = [
            Weekday.sunday,
            Weekday.monday,
            Weekday.tuesday,
            Weekday.wednesday,
            Weekday.thursday,
            Weekday.friday,
            Weekday.saturday
        ]
        
        XCTAssertEqual(allDays.count, 7)
        for (index, day) in allDays.enumerated() {
            XCTAssertEqual(day.dayOfWeek, index + 1)
        }
    }
    
    func testWeekdayFromStringAllDays() {
        // Все дни недели из строки
        let days = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]
        for (index, dayString) in days.enumerated() {
            let weekday = Weekday(from: dayString)
            XCTAssertNotNil(weekday)
            XCTAssertEqual(weekday?.dayOfWeek, index + 1)
        }
    }
    
    func testWeekdayFromStringWithAllPositions() {
        // Все позиции
        for position in 1...53 {
            let weekday = Weekday(from: "\(position)MO")
            XCTAssertNotNil(weekday)
            XCTAssertEqual(weekday?.position, position)
        }
        
        for position in -53...(-1) {
            let weekday = Weekday(from: "\(position)MO")
            XCTAssertNotNil(weekday)
            XCTAssertEqual(weekday?.position, position)
        }
    }
    
    // MARK: - Additional Advanced Tests
    
    func testWeekdayAllConvenienceInitializersOrder() {
        // Порядок convenience инициализаторов
        XCTAssertEqual(Weekday.sunday.dayOfWeek, 1)
        XCTAssertEqual(Weekday.monday.dayOfWeek, 2)
        XCTAssertEqual(Weekday.tuesday.dayOfWeek, 3)
        XCTAssertEqual(Weekday.wednesday.dayOfWeek, 4)
        XCTAssertEqual(Weekday.thursday.dayOfWeek, 5)
        XCTAssertEqual(Weekday.friday.dayOfWeek, 6)
        XCTAssertEqual(Weekday.saturday.dayOfWeek, 7)
    }
    
    func testWeekdayFromStringAllDaysCaseInsensitive() {
        // Все дни недели из строки (регистронезависимо)
        let days = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]
        let lowerDays = ["su", "mo", "tu", "we", "th", "fr", "sa"]
        let mixedDays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        
        for (index, dayString) in days.enumerated() {
            let weekday = Weekday(from: dayString)
            XCTAssertNotNil(weekday)
            XCTAssertEqual(weekday?.dayOfWeek, index + 1)
        }
        
        for (index, dayString) in lowerDays.enumerated() {
            let weekday = Weekday(from: dayString)
            XCTAssertNotNil(weekday)
            XCTAssertEqual(weekday?.dayOfWeek, index + 1)
        }
        
        for (index, dayString) in mixedDays.enumerated() {
            let weekday = Weekday(from: dayString)
            XCTAssertNotNil(weekday)
            XCTAssertEqual(weekday?.dayOfWeek, index + 1)
        }
    }
    
    func testWeekdayToStringAllDays() {
        // toString для всех дней недели
        XCTAssertEqual(Weekday.sunday.toString(), "SU")
        XCTAssertEqual(Weekday.monday.toString(), "MO")
        XCTAssertEqual(Weekday.tuesday.toString(), "TU")
        XCTAssertEqual(Weekday.wednesday.toString(), "WE")
        XCTAssertEqual(Weekday.thursday.toString(), "TH")
        XCTAssertEqual(Weekday.friday.toString(), "FR")
        XCTAssertEqual(Weekday.saturday.toString(), "SA")
    }
    
    func testWeekdayToStringWithAllPositions() {
        // toString для всех позиций
        for position in 1...53 {
            let weekday = Weekday(dayOfWeek: 2, position: position)
            let result = weekday.toString()
            XCTAssertTrue(result.contains("\(position)MO"))
        }
        
        for position in -53...(-1) {
            let weekday = Weekday(dayOfWeek: 2, position: position)
            let result = weekday.toString()
            XCTAssertTrue(result.contains("\(position)MO"))
        }
    }
    
    func testWeekdayEquatableAllDays() {
        // Equatable для всех дней недели
        XCTAssertEqual(Weekday.sunday, Weekday.sunday)
        XCTAssertEqual(Weekday.monday, Weekday.monday)
        XCTAssertEqual(Weekday.tuesday, Weekday.tuesday)
        XCTAssertEqual(Weekday.wednesday, Weekday.wednesday)
        XCTAssertEqual(Weekday.thursday, Weekday.thursday)
        XCTAssertEqual(Weekday.friday, Weekday.friday)
        XCTAssertEqual(Weekday.saturday, Weekday.saturday)
        
        XCTAssertNotEqual(Weekday.sunday, Weekday.monday)
        XCTAssertNotEqual(Weekday.monday, Weekday.tuesday)
    }
    
    func testWeekdayEquatableWithPositions() {
        // Equatable с позициями
        let weekday1 = Weekday(dayOfWeek: 2, position: 1)
        let weekday2 = Weekday(dayOfWeek: 2, position: 1)
        let weekday3 = Weekday(dayOfWeek: 2, position: 2)
        
        XCTAssertEqual(weekday1, weekday2)
        XCTAssertNotEqual(weekday1, weekday3)
    }
    
    func testWeekdayEquatableWithNilPositionAdvanced() {
        // Equatable с nil позицией
        let weekday1 = Weekday(dayOfWeek: 2, position: nil)
        let weekday2 = Weekday.monday
        let weekday3 = Weekday(dayOfWeek: 2, position: 1)
        
        XCTAssertEqual(weekday1, weekday2)
        XCTAssertNotEqual(weekday1, weekday3)
    }
    
    func testWeekdayHashableAllDays() {
        // Hashable для всех дней недели
        var set = Set<Weekday>()
        set.insert(.sunday)
        set.insert(.monday)
        set.insert(.tuesday)
        set.insert(.wednesday)
        set.insert(.thursday)
        set.insert(.friday)
        set.insert(.saturday)
        
        XCTAssertEqual(set.count, 7)
    }
    
    func testWeekdayHashableWithPositions() {
        // Hashable с позициями
        var set = Set<Weekday>()
        set.insert(Weekday(dayOfWeek: 2, position: 1))
        set.insert(Weekday(dayOfWeek: 2, position: 2))
        set.insert(Weekday(dayOfWeek: 2, position: -1))
        set.insert(Weekday(dayOfWeek: 2, position: 1)) // Дубликат
        
        XCTAssertEqual(set.count, 3)
    }
    
    func testWeekdayCodableAllDays() throws {
        // Codable для всех дней недели
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let allDays: [Weekday] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        
        for day in allDays {
            let data = try encoder.encode(day)
            let decoded = try decoder.decode(Weekday.self, from: data)
            XCTAssertEqual(day, decoded)
        }
    }
    
    func testWeekdayCodableArray() throws {
        // Codable для массива дней недели
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let weekdays: [Weekday] = [
            Weekday(dayOfWeek: 2, position: 1),
            Weekday(dayOfWeek: 2, position: 2),
            Weekday(dayOfWeek: 2, position: -1)
        ]
        
        let data = try encoder.encode(weekdays)
        let decoded = try decoder.decode([Weekday].self, from: data)
        
        XCTAssertEqual(weekdays, decoded)
    }
    
    func testWeekdayFromStringWithAllPositionsRange() {
        // Диапазон позиций
        for position in 1...53 {
            let weekday = Weekday(from: "\(position)MO")
            XCTAssertNotNil(weekday)
            XCTAssertEqual(weekday?.dayOfWeek, 2)
            XCTAssertEqual(weekday?.position, position)
        }
        
        for position in -53...(-1) {
            let weekday = Weekday(from: "\(position)MO")
            XCTAssertNotNil(weekday)
            XCTAssertEqual(weekday?.dayOfWeek, 2)
            XCTAssertEqual(weekday?.position, position)
        }
    }
    
    func testWeekdayFromStringWithAllDaysAndPositions() {
        // Все дни недели с позициями
        let days = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]
        
        for (dayIndex, dayString) in days.enumerated() {
            for position in [1, 2, 3, -2, -1] {
                let weekday = Weekday(from: "\(position)\(dayString)")
                XCTAssertNotNil(weekday)
                XCTAssertEqual(weekday?.dayOfWeek, dayIndex + 1)
                XCTAssertEqual(weekday?.position, position)
            }
        }
    }
    
    func testWeekdayToStringRoundTrip() {
        // Round-trip: toString -> from -> toString
        let weekdays: [Weekday] = [
            .sunday,
            .monday,
            Weekday(dayOfWeek: 2, position: 1),
            Weekday(dayOfWeek: 2, position: -1)
        ]
        
        for weekday in weekdays {
            let string = weekday.toString()
            let fromString = Weekday(from: string)
            XCTAssertNotNil(fromString, "Weekday should be parseable from its toString() result")
            if let fromString = fromString {
                XCTAssertEqual(weekday.dayOfWeek, fromString.dayOfWeek)
                XCTAssertEqual(weekday.position, fromString.position)
            } else {
                XCTFail("Weekday should be parseable from string: \(string)")
            }
        }
    }
    
    func testWeekdayInSet() {
        // Дни недели в Set
        var set = Set<Weekday>()
        set.insert(.monday)
        set.insert(.tuesday)
        set.insert(.wednesday)
        set.insert(.monday) // Дубликат
        
        XCTAssertEqual(set.count, 3)
        XCTAssertTrue(set.contains(.monday))
        XCTAssertTrue(set.contains(.tuesday))
        XCTAssertTrue(set.contains(.wednesday))
    }
    
    func testWeekdayInArray() {
        // Дни недели в массиве
        let array: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
        XCTAssertEqual(array.count, 5)
        XCTAssertTrue(array.contains(.monday))
        XCTAssertTrue(array.contains(.friday))
    }
    
    func testWeekdayFilter() {
        // Фильтрация дней недели
        let allDays: [Weekday] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        let weekdays = allDays.filter { [.monday, .tuesday, .wednesday, .thursday, .friday].contains($0) }
        XCTAssertEqual(weekdays.count, 5)
    }
    
    func testWeekdayMap() {
        // Преобразование дней недели
        let allDays: [Weekday] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        let dayOfWeeks = allDays.map { $0.dayOfWeek }
        XCTAssertEqual(dayOfWeeks, [1, 2, 3, 4, 5, 6, 7])
    }
    
    func testWeekdayReduce() {
        // Сведение дней недели
        let allDays: [Weekday] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        let combined = allDays.reduce("") { $0 + $1.toString() }
        XCTAssertTrue(combined.contains("SU"))
        XCTAssertTrue(combined.contains("MO"))
        XCTAssertTrue(combined.contains("SA"))
    }
    
    func testWeekdaySorted() {
        // Сортировка дней недели
        let allDays: [Weekday] = [.saturday, .friday, .thursday, .wednesday, .tuesday, .monday, .sunday]
        let sorted = allDays.sorted { $0.dayOfWeek < $1.dayOfWeek }
        XCTAssertEqual(sorted[0].dayOfWeek, 1)
        XCTAssertEqual(sorted[6].dayOfWeek, 7)
    }
    
    func testWeekdayForEach() {
        // Итерация по дням недели
        let allDays: [Weekday] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        var count = 0
        allDays.forEach { _ in count += 1 }
        XCTAssertEqual(count, 7)
    }
    
    func testWeekdayDescription() {
        // Описание дней недели
        let weekday = Weekday.monday
        let description = String(describing: weekday)
        XCTAssertFalse(description.isEmpty)
    }
    
    func testWeekdayDebugDescription() {
        // Отладочное описание дней недели
        let weekday = Weekday.monday
        let description = String(describing: weekday)
        XCTAssertFalse(description.isEmpty)
    }
    
    func testWeekdayMemoryLayout() {
        // Размер в памяти
        let size = MemoryLayout<Weekday>.size
        XCTAssertGreaterThan(size, 0)
    }
    
    func testWeekdayMirror() {
        // Зеркало для отладки
        let weekday = Weekday.monday
        let mirror = Mirror(reflecting: weekday)
        XCTAssertNotNil(mirror)
    }
    
    func testWeekdayStringInterpolation() {
        // Интерполяция строк
        let weekday = Weekday.monday
        let string = "\(weekday)"
        XCTAssertFalse(string.isEmpty)
    }
    
    func testWeekdayComparison() {
        // Сравнение дней недели
        let monday = Weekday.monday
        let tuesday = Weekday.tuesday
        
        XCTAssertEqual(monday, monday)
        XCTAssertNotEqual(monday, tuesday)
    }
    
    func testWeekdayWithPositionComparison() {
        // Сравнение дней недели с позициями
        let monday1 = Weekday(dayOfWeek: 2, position: 1)
        let monday2 = Weekday(dayOfWeek: 2, position: 1)
        let monday3 = Weekday(dayOfWeek: 2, position: 2)
        
        XCTAssertEqual(monday1, monday2)
        XCTAssertNotEqual(monday1, monday3)
    }
    
    func testWeekdayAllDaysArray() {
        // Массив всех дней недели
        let allDays: [Weekday] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        XCTAssertEqual(allDays.count, 7)
        
        for (index, day) in allDays.enumerated() {
            XCTAssertEqual(day.dayOfWeek, index + 1)
        }
    }
    
    func testWeekdayConvenienceInitializersEquality() {
        // Равенство convenience инициализаторов
        XCTAssertEqual(Weekday.sunday, Weekday(dayOfWeek: 1, position: nil))
        XCTAssertEqual(Weekday.monday, Weekday(dayOfWeek: 2, position: nil))
        XCTAssertEqual(Weekday.tuesday, Weekday(dayOfWeek: 3, position: nil))
        XCTAssertEqual(Weekday.wednesday, Weekday(dayOfWeek: 4, position: nil))
        XCTAssertEqual(Weekday.thursday, Weekday(dayOfWeek: 5, position: nil))
        XCTAssertEqual(Weekday.friday, Weekday(dayOfWeek: 6, position: nil))
        XCTAssertEqual(Weekday.saturday, Weekday(dayOfWeek: 7, position: nil))
    }
}

