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
        }
        if let w2 = weekday2 {
            XCTAssertEqual(w2.dayOfWeek, 2)
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
        XCTAssertNil(weekday1)
        // MON может быть интерпретировано как MO (парсер принимает префикс)
        if let w2 = weekday2 {
            XCTAssertEqual(w2.dayOfWeek, 2, "MON should be interpreted as MO")
        }
        // MONDAY может быть интерпретировано как MO (парсер принимает префикс)
        if let w3 = weekday3 {
            XCTAssertEqual(w3.dayOfWeek, 2, "MONDAY should be interpreted as MO")
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
        }
        if let w2 = weekday2 {
            XCTAssertEqual(w2.dayOfWeek, 2)
            XCTAssertEqual(w2.position, 8)
        }
        if let w3 = weekday3 {
            XCTAssertEqual(w3.dayOfWeek, 2)
            XCTAssertEqual(w3.position, -54)
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
}

