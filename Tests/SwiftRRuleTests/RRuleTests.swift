//
//  RRuleTests.swift
//  SwiftRRuleTests
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import XCTest
@testable import SwiftRRule

final class RRuleTests: XCTestCase {
    
    func testRRuleInitialization() {
        let rrule = RRule(
            frequency: .daily,
            interval: 2,
            count: 10
        )
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.interval, 2)
        XCTAssertEqual(rrule.count, 10)
        XCTAssertNil(rrule.until)
    }
    
    func testRRuleWithAllProperties() {
        let date = Date()
        let rrule = RRule(
            frequency: .weekly,
            interval: 1,
            count: 5,
            until: date,
            bySecond: [0, 30],
            byMinute: [0, 15, 30, 45],
            byHour: [9, 17],
            byDay: [.monday, .wednesday, .friday],
            byMonthDay: [1, 15],
            byYearDay: [1, 365],
            byWeekNo: [1, 52],
            byMonth: [1, 6, 12],
            bySetPos: [1, -1],
            wkst: .monday
        )
        
        XCTAssertEqual(rrule.frequency, .weekly)
        XCTAssertEqual(rrule.interval, 1)
        XCTAssertEqual(rrule.count, 5)
        XCTAssertEqual(rrule.until, date)
        XCTAssertEqual(rrule.bySecond, [0, 30])
        XCTAssertEqual(rrule.byMinute, [0, 15, 30, 45])
        XCTAssertEqual(rrule.byHour, [9, 17])
        XCTAssertEqual(rrule.byDay?.count, 3)
        XCTAssertEqual(rrule.byMonthDay, [1, 15])
        XCTAssertEqual(rrule.byYearDay, [1, 365])
        XCTAssertEqual(rrule.byWeekNo, [1, 52])
        XCTAssertEqual(rrule.byMonth, [1, 6, 12])
        XCTAssertEqual(rrule.bySetPos, [1, -1])
        XCTAssertEqual(rrule.wkst?.dayOfWeek, 2)
    }
    
    func testRRuleEquatable() {
        let rrule1 = RRule(frequency: .daily, interval: 2, count: 10)
        let rrule2 = RRule(frequency: .daily, interval: 2, count: 10)
        let rrule3 = RRule(frequency: .weekly, interval: 2, count: 10)
        
        XCTAssertEqual(rrule1, rrule2)
        XCTAssertNotEqual(rrule1, rrule3)
    }
    
    func testRRuleCodable() throws {
        let rrule = RRule(
            frequency: .monthly,
            interval: 1,
            count: 12,
            byDay: [.monday, .friday],
            wkst: .monday
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(rrule)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(RRule.self, from: data)
        
        XCTAssertEqual(rrule.frequency, decoded.frequency)
        XCTAssertEqual(rrule.interval, decoded.interval)
        XCTAssertEqual(rrule.count, decoded.count)
        XCTAssertEqual(rrule.byDay?.count, decoded.byDay?.count)
        XCTAssertEqual(rrule.wkst?.dayOfWeek, decoded.wkst?.dayOfWeek)
    }
    
    // MARK: - Edge Cases and Error Detection
    
    func testRRuleWithNilValues() {
        // Все опциональные значения nil
        let rrule = RRule(frequency: .daily)
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertNil(rrule.interval)
        XCTAssertNil(rrule.count)
        XCTAssertNil(rrule.until)
        XCTAssertNil(rrule.bySecond)
        XCTAssertNil(rrule.byMinute)
        XCTAssertNil(rrule.byHour)
        XCTAssertNil(rrule.byDay)
        XCTAssertNil(rrule.byMonthDay)
        XCTAssertNil(rrule.byYearDay)
        XCTAssertNil(rrule.byWeekNo)
        XCTAssertNil(rrule.byMonth)
        XCTAssertNil(rrule.bySetPos)
        XCTAssertNil(rrule.wkst)
    }
    
    func testRRuleWithEmptyArrays() {
        // Пустые массивы
        let rrule = RRule(
            frequency: .daily,
            bySecond: [],
            byMinute: [],
            byHour: []
        )
        XCTAssertNotNil(rrule.bySecond)
        XCTAssertNotNil(rrule.byMinute)
        XCTAssertNotNil(rrule.byHour)
    }
    
    func testRRuleWithZeroValues() {
        // Нулевые значения
        let rrule = RRule(frequency: .daily, interval: 0, count: 0)
        XCTAssertEqual(rrule.interval, 0)
        XCTAssertEqual(rrule.count, 0)
    }
    
    func testRRuleWithNegativeValues() {
        // Отрицательные значения
        let rrule = RRule(frequency: .daily, interval: -1, count: -1)
        XCTAssertEqual(rrule.interval, -1)
        XCTAssertEqual(rrule.count, -1)
    }
    
    func testRRuleWithLargeValues() {
        // Большие значения
        let rrule = RRule(frequency: .daily, interval: Int.max, count: Int.max)
        XCTAssertEqual(rrule.interval, Int.max)
        XCTAssertEqual(rrule.count, Int.max)
    }
    
    func testRRuleEquatableWithNilUntil() {
        // Equatable с nil UNTIL
        let rrule1 = RRule(frequency: .daily, until: nil)
        let rrule2 = RRule(frequency: .daily, until: nil)
        XCTAssertEqual(rrule1, rrule2)
    }
    
    func testRRuleEquatableWithDifferentUntil() {
        // Equatable с разными UNTIL
        let date1 = Date()
        let date2 = Date(timeIntervalSince1970: date1.timeIntervalSince1970 + 1)
        let rrule1 = RRule(frequency: .daily, until: date1)
        let rrule2 = RRule(frequency: .daily, until: date2)
        XCTAssertNotEqual(rrule1, rrule2)
    }
    
    func testRRuleEquatableWithDifferentArrays() {
        // Equatable с разными массивами
        let rrule1 = RRule(frequency: .daily, byHour: [9, 17])
        let rrule2 = RRule(frequency: .daily, byHour: [9, 18])
        XCTAssertNotEqual(rrule1, rrule2)
    }
    
    func testRRuleEquatableWithSameArrays() {
        // Equatable с одинаковыми массивами
        let rrule1 = RRule(frequency: .daily, byHour: [9, 17])
        let rrule2 = RRule(frequency: .daily, byHour: [9, 17])
        XCTAssertEqual(rrule1, rrule2)
    }
    
    func testRRuleEquatableWithDifferentOrderArrays() {
        // Equatable с массивами в разном порядке
        let rrule1 = RRule(frequency: .daily, byHour: [9, 17])
        let rrule2 = RRule(frequency: .daily, byHour: [17, 9])
        // Массивы в Swift равны только если элементы в одинаковом порядке
        // Поэтому rrule1 и rrule2 не равны, хотя семантически они одинаковы
        XCTAssertNotEqual(rrule1, rrule2, "RRule with different array order are not equal in Swift")
        // Но содержимое массивов одинаково
        XCTAssertEqual(Set(rrule1.byHour ?? []), Set(rrule2.byHour ?? []))
    }
    
    func testRRuleCodableWithUntil() throws {
        // Codable с UNTIL
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 12
        components.day = 31
        components.hour = 23
        components.minute = 59
        components.second = 59
        let untilDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .daily, until: untilDate)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(rrule)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(RRule.self, from: data)
        
        XCTAssertEqual(rrule.frequency, decoded.frequency)
        XCTAssertNotNil(decoded.until)
    }
    
    func testRRuleCodableWithAllProperties() throws {
        // Codable со всеми свойствами
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 12
        components.day = 31
        let untilDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .weekly,
            interval: 2,
            count: 10,
            until: untilDate,
            bySecond: [0, 30],
            byMinute: [0, 15, 30, 45],
            byHour: [9, 17],
            byDay: [.monday, .wednesday, .friday],
            byMonthDay: [1, 15],
            byYearDay: [1, 365],
            byWeekNo: [1, 52],
            byMonth: [1, 6, 12],
            bySetPos: [1, -1],
            wkst: .monday
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(rrule)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(RRule.self, from: data)
        
        XCTAssertEqual(rrule.frequency, decoded.frequency)
        XCTAssertEqual(rrule.interval, decoded.interval)
        XCTAssertEqual(rrule.count, decoded.count)
        XCTAssertEqual(rrule.bySecond, decoded.bySecond)
        XCTAssertEqual(rrule.byMinute, decoded.byMinute)
        XCTAssertEqual(rrule.byHour, decoded.byHour)
        XCTAssertEqual(rrule.byDay?.count, decoded.byDay?.count)
        XCTAssertEqual(rrule.byMonthDay, decoded.byMonthDay)
        XCTAssertEqual(rrule.byYearDay, decoded.byYearDay)
        XCTAssertEqual(rrule.byWeekNo, decoded.byWeekNo)
        XCTAssertEqual(rrule.byMonth, decoded.byMonth)
        XCTAssertEqual(rrule.bySetPos, decoded.bySetPos)
        XCTAssertEqual(rrule.wkst?.dayOfWeek, decoded.wkst?.dayOfWeek)
    }
    
    func testRRuleEquatableConsistency() {
        // Проверка согласованности Equatable
        let rrule1 = RRule(frequency: .daily, interval: 2, count: 10)
        let rrule2 = RRule(frequency: .daily, interval: 2, count: 10)
        let rrule3 = RRule(frequency: .weekly, interval: 2, count: 10)
        
        // rrule1 и rrule2 должны быть равны
        XCTAssertEqual(rrule1, rrule2)
        // rrule1 и rrule3 должны быть разными
        XCTAssertNotEqual(rrule1, rrule3)
    }
    
    func testRRuleGenerateDatesWithCalendar() {
        // generateDates с календарем
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let startDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .daily, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
    }
    
    func testRRuleToString() {
        // toString
        let rrule = RRule(frequency: .daily, interval: 2, count: 10)
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("FREQ=DAILY"))
        XCTAssertTrue(result.contains("INTERVAL=2"))
        XCTAssertTrue(result.contains("COUNT=10"))
    }
    
    func testRRuleParse() throws {
        // parse
        let rrule = try RRule.parse("FREQ=DAILY;INTERVAL=2;COUNT=10")
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.interval, 2)
        XCTAssertEqual(rrule.count, 10)
    }
}

