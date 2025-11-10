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
    
    // MARK: - Additional Advanced Tests
    
    func testRRuleWithAllFrequencies() {
        // Все частоты
        let daily = RRule(frequency: .daily)
        let weekly = RRule(frequency: .weekly)
        let monthly = RRule(frequency: .monthly)
        let yearly = RRule(frequency: .yearly)
        
        XCTAssertEqual(daily.frequency, .daily)
        XCTAssertEqual(weekly.frequency, .weekly)
        XCTAssertEqual(monthly.frequency, .monthly)
        XCTAssertEqual(yearly.frequency, .yearly)
    }
    
    func testRRuleWithAllByRules() {
        // Все BY* правила
        let rrule = RRule(
            frequency: .daily,
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
        
        XCTAssertNotNil(rrule.bySecond)
        XCTAssertNotNil(rrule.byMinute)
        XCTAssertNotNil(rrule.byHour)
        XCTAssertNotNil(rrule.byDay)
        XCTAssertNotNil(rrule.byMonthDay)
        XCTAssertNotNil(rrule.byYearDay)
        XCTAssertNotNil(rrule.byWeekNo)
        XCTAssertNotNil(rrule.byMonth)
        XCTAssertNotNil(rrule.bySetPos)
        XCTAssertNotNil(rrule.wkst)
    }
    
    func testRRuleWithNegativeValuesInByRules() {
        // Отрицательные значения в BY* правилах
        let rrule = RRule(
            frequency: .monthly,
            byMonthDay: [-7, -1],
            byYearDay: [-100, -1],
            byWeekNo: [-26, -1],
            bySetPos: [-2, -1]
        )
        
        XCTAssertNotNil(rrule.byMonthDay)
        XCTAssertNotNil(rrule.byYearDay)
        XCTAssertNotNil(rrule.byWeekNo)
        XCTAssertNotNil(rrule.bySetPos)
    }
    
    func testRRuleWithByDayPositions() {
        // BYDAY с позициями
        let rrule = RRule(
            frequency: .monthly,
            byDay: [
                Weekday(dayOfWeek: 2, position: 1),
                Weekday(dayOfWeek: 2, position: 2),
                Weekday(dayOfWeek: 2, position: -1)
            ]
        )
        
        XCTAssertNotNil(rrule.byDay)
        XCTAssertEqual(rrule.byDay?.count, 3)
    }
    
    func testRRuleWithWkstAllDays() {
        // Все возможные WKST
        let sunday = RRule(frequency: .weekly, wkst: .sunday)
        let monday = RRule(frequency: .weekly, wkst: .monday)
        let tuesday = RRule(frequency: .weekly, wkst: .tuesday)
        let wednesday = RRule(frequency: .weekly, wkst: .wednesday)
        let thursday = RRule(frequency: .weekly, wkst: .thursday)
        let friday = RRule(frequency: .weekly, wkst: .friday)
        let saturday = RRule(frequency: .weekly, wkst: .saturday)
        
        XCTAssertEqual(sunday.wkst?.dayOfWeek, 1)
        XCTAssertEqual(monday.wkst?.dayOfWeek, 2)
        XCTAssertEqual(tuesday.wkst?.dayOfWeek, 3)
        XCTAssertEqual(wednesday.wkst?.dayOfWeek, 4)
        XCTAssertEqual(thursday.wkst?.dayOfWeek, 5)
        XCTAssertEqual(friday.wkst?.dayOfWeek, 6)
        XCTAssertEqual(saturday.wkst?.dayOfWeek, 7)
    }
    
    func testRRuleWithUntilAtMidnight() {
        // UNTIL в полночь
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 12
        components.day = 31
        components.hour = 0
        components.minute = 0
        components.second = 0
        let untilDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .daily, until: untilDate)
        XCTAssertNotNil(rrule.until)
    }
    
    func testRRuleWithUntilAtEndOfDay() {
        // UNTIL в конец дня
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
        XCTAssertNotNil(rrule.until)
    }
    
    func testRRuleWithUntilInFuture() {
        // UNTIL в будущем
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2099
        components.month = 12
        components.day = 31
        components.hour = 12
        components.minute = 0
        components.second = 0
        let untilDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .daily, until: untilDate)
        XCTAssertNotNil(rrule.until)
    }
    
    func testRRuleWithUntilInPast() {
        // UNTIL в прошлом
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2000
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let untilDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .daily, until: untilDate)
        XCTAssertNotNil(rrule.until)
    }
    
    func testRRuleWithIntervalOne() {
        // INTERVAL=1
        let rrule = RRule(frequency: .daily, interval: 1)
        XCTAssertEqual(rrule.interval, 1)
    }
    
    func testRRuleWithIntervalMax() {
        // Максимальный INTERVAL
        let rrule = RRule(frequency: .daily, interval: Int.max)
        XCTAssertEqual(rrule.interval, Int.max)
    }
    
    func testRRuleWithCountMax() {
        // Максимальный COUNT
        let rrule = RRule(frequency: .daily, count: Int.max)
        XCTAssertEqual(rrule.count, Int.max)
    }
    
    func testRRuleWithLargeArrays() {
        // Большие массивы
        let rrule = RRule(
            frequency: .daily,
            bySecond: Array(0...59),
            byMinute: Array(0...59),
            byHour: Array(0...23),
            byMonthDay: Array(1...31),
            byMonth: Array(1...12)
        )
        
        XCTAssertEqual(rrule.bySecond?.count, 60)
        XCTAssertEqual(rrule.byMinute?.count, 60)
        XCTAssertEqual(rrule.byHour?.count, 24)
        XCTAssertEqual(rrule.byMonthDay?.count, 31)
        XCTAssertEqual(rrule.byMonth?.count, 12)
    }
    
    func testRRuleWithNegativeArrays() {
        // Отрицательные массивы
        let rrule = RRule(
            frequency: .monthly,
            byMonthDay: Array(-31...(-1)),
            byYearDay: Array(-366...(-1)),
            byWeekNo: Array(-53...(-1)),
            bySetPos: Array(-366...(-1))
        )
        
        XCTAssertNotNil(rrule.byMonthDay)
        XCTAssertNotNil(rrule.byYearDay)
        XCTAssertNotNil(rrule.byWeekNo)
        XCTAssertNotNil(rrule.bySetPos)
    }
    
    func testRRuleWithMixedArrays() {
        // Смешанные массивы (положительные и отрицательные)
        let rrule = RRule(
            frequency: .monthly,
            byMonthDay: [1, 15, -7, -1],
            bySetPos: [1, 2, -2, -1]
        )
        
        XCTAssertNotNil(rrule.byMonthDay)
        XCTAssertNotNil(rrule.bySetPos)
    }
    
    func testRRuleEquatableWithAllProperties() {
        // Equatable со всеми свойствами
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 12
        components.day = 31
        let untilDate = calendar.date(from: components)!
        
        let rrule1 = RRule(
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
        
        let rrule2 = RRule(
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
        
        XCTAssertEqual(rrule1, rrule2)
    }
    
    func testRRuleEquatableWithDifferentProperties() {
        // Equatable с разными свойствами
        let rrule1 = RRule(frequency: .daily, count: 10)
        let rrule2 = RRule(frequency: .daily, count: 20)
        let rrule3 = RRule(frequency: .weekly, count: 10)
        
        XCTAssertNotEqual(rrule1, rrule2)
        XCTAssertNotEqual(rrule1, rrule3)
    }
    
    func testRRuleCodableWithAllFrequencies() throws {
        // Codable для всех частот
        for frequency in [Frequency.daily, .weekly, .monthly, .yearly] {
            let rrule = RRule(frequency: frequency, count: 10)
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(rrule)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decoded = try decoder.decode(RRule.self, from: data)
            
            XCTAssertEqual(rrule.frequency, decoded.frequency)
            XCTAssertEqual(rrule.count, decoded.count)
        }
    }
    
    func testRRuleCodableWithNegativeValues() throws {
        // Codable с отрицательными значениями
        let rrule = RRule(
            frequency: .monthly,
            byMonthDay: [-7, -1],
            bySetPos: [-2, -1]
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(rrule)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(RRule.self, from: data)
        
        XCTAssertEqual(rrule.byMonthDay, decoded.byMonthDay)
        XCTAssertEqual(rrule.bySetPos, decoded.bySetPos)
    }
    
    func testRRuleCodableWithByDayPositions() throws {
        // Codable с BYDAY позициями
        let rrule = RRule(
            frequency: .monthly,
            byDay: [
                Weekday(dayOfWeek: 2, position: 1),
                Weekday(dayOfWeek: 2, position: -1)
            ]
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(rrule)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(RRule.self, from: data)
        
        XCTAssertEqual(rrule.byDay?.count, decoded.byDay?.count)
    }
    
    func testRRuleGenerateDatesWithAllFrequencies() {
        // generateDates для всех частот
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let startDate = calendar.date(from: components)!
        
        for frequency in [Frequency.daily, .weekly, .monthly, .yearly] {
            let rrule = RRule(frequency: frequency, count: 5)
            let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
            XCTAssertEqual(dates.count, 5)
        }
    }
    
    func testRRuleGenerateDatesWithInterval() {
        // generateDates с INTERVAL
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let startDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .daily, interval: 3, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        XCTAssertEqual(dates.count, 5)
    }
    
    func testRRuleGenerateDatesWithUntil() {
        // generateDates с UNTIL
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let startDate = calendar.date(from: components)!
        let untilDate = calendar.date(byAdding: .day, value: 10, to: startDate)!
        
        let rrule = RRule(frequency: .daily, until: untilDate)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        XCTAssertLessThanOrEqual(dates.count, 11)
    }
    
    func testRRuleGenerateDatesWithByRules() {
        // generateDates с BY* правилами
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 9
        components.minute = 0
        components.second = 0
        let startDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .daily, count: 10, byHour: [9, 17])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        XCTAssertEqual(dates.count, 10)
    }
    
    func testRRuleToStringWithAllFrequencies() {
        // toString для всех частот
        for frequency in [Frequency.daily, .weekly, .monthly, .yearly] {
            let rrule = RRule(frequency: frequency)
            let result = rrule.toString()
            XCTAssertTrue(result.contains("FREQ=\(frequency.rawValue)"))
        }
    }
    
    func testRRuleToStringWithAllProperties() {
        // toString со всеми свойствами
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
        
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=WEEKLY"))
        XCTAssertTrue(result.contains("INTERVAL=2"))
        XCTAssertTrue(result.contains("COUNT=10"))
        XCTAssertTrue(result.contains("UNTIL="))
    }
    
    func testRRuleParseWithAllFrequencies() throws {
        // parse для всех частот
        for frequency in [Frequency.daily, .weekly, .monthly, .yearly] {
            let rrule = try RRule.parse("FREQ=\(frequency.rawValue);COUNT=10")
            XCTAssertEqual(rrule.frequency, frequency)
            XCTAssertEqual(rrule.count, 10)
        }
    }
    
    func testRRuleParseWithAllByRules() throws {
        // parse со всеми BY* правилами
        let rrule = try RRule.parse("FREQ=DAILY;BYSECOND=0,30;BYMINUTE=0,15,30,45;BYHOUR=9,17;BYDAY=MO,WE,FR;BYMONTHDAY=1,15;BYMONTH=1,6,12;BYSETPOS=1,-1;WKST=MO")
        
        XCTAssertNotNil(rrule.bySecond)
        XCTAssertNotNil(rrule.byMinute)
        XCTAssertNotNil(rrule.byHour)
        XCTAssertNotNil(rrule.byDay)
        XCTAssertNotNil(rrule.byMonthDay)
        XCTAssertNotNil(rrule.byMonth)
        XCTAssertNotNil(rrule.bySetPos)
        XCTAssertNotNil(rrule.wkst)
    }
    
    func testRRuleRoundTrip() throws {
        // Round-trip: parse -> toString -> parse
        let original = "FREQ=WEEKLY;INTERVAL=2;COUNT=10;BYDAY=MO,WE,FR;BYHOUR=9,17"
        let rrule1 = try RRule.parse(original)
        let generated = rrule1.toString()
        let rrule2 = try RRule.parse(generated)
        
        XCTAssertEqual(rrule1.frequency, rrule2.frequency)
        XCTAssertEqual(rrule1.interval, rrule2.interval)
        XCTAssertEqual(rrule1.count, rrule2.count)
        XCTAssertEqual(rrule1.byDay?.count, rrule2.byDay?.count)
        XCTAssertEqual(rrule1.byHour, rrule2.byHour)
    }
}

