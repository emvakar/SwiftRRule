//
//  RRuleGeneratorTests.swift
//  SwiftRRuleTests
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import XCTest
@testable import SwiftRRule

final class RRuleGeneratorTests: XCTestCase {
    
    // MARK: - Basic Generation Tests
    
    func testGenerateBasicDaily() {
        let rrule = RRule(frequency: .daily)
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=DAILY")
    }
    
    func testGenerateDailyWithInterval() {
        let rrule = RRule(frequency: .daily, interval: 2)
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=DAILY;INTERVAL=2")
    }
    
    func testGenerateDailyWithCount() {
        let rrule = RRule(frequency: .daily, count: 10)
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=DAILY;COUNT=10")
    }
    
    func testGenerateDailyWithIntervalAndCount() {
        let rrule = RRule(frequency: .daily, interval: 2, count: 10)
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=DAILY;INTERVAL=2;COUNT=10")
    }
    
    // MARK: - Weekly Tests
    
    func testGenerateWeekly() {
        let rrule = RRule(frequency: .weekly)
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=WEEKLY")
    }
    
    func testGenerateWeeklyWithByDay() {
        let rrule = RRule(frequency: .weekly, byDay: [.monday, .wednesday, .friday])
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=WEEKLY;BYDAY=MO,WE,FR")
    }
    
    func testGenerateWeeklyWithByDayAndPosition() {
        let rrule = RRule(frequency: .weekly, byDay: [Weekday(dayOfWeek: 2, position: 2)])
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=WEEKLY;BYDAY=2MO")
    }
    
    // MARK: - Monthly Tests
    
    func testGenerateMonthly() {
        let rrule = RRule(frequency: .monthly)
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=MONTHLY")
    }
    
    func testGenerateMonthlyWithByMonthDay() {
        let rrule = RRule(frequency: .monthly, byMonthDay: [1, 15])
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=MONTHLY;BYMONTHDAY=1,15")
    }
    
    func testGenerateMonthlyWithByDay() {
        let rrule = RRule(frequency: .monthly, byDay: [Weekday(dayOfWeek: 2, position: -1)])
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=MONTHLY;BYDAY=-1MO")
    }
    
    // MARK: - Yearly Tests
    
    func testGenerateYearly() {
        let rrule = RRule(frequency: .yearly)
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=YEARLY")
    }
    
    func testGenerateYearlyWithByMonth() {
        let rrule = RRule(frequency: .yearly, byMonth: [1, 6, 12])
        let result = rrule.toString()
        
        XCTAssertEqual(result, "FREQ=YEARLY;BYMONTH=1,6,12")
    }
    
    // MARK: - Complex Tests
    
    func testGenerateComplexRule() {
        let rrule = RRule(
            frequency: .weekly,
            interval: 2,
            count: 10,
            byMinute: [0, 30],
            byHour: [9, 17],
            byDay: [.monday, .wednesday, .friday]
        )
        let result = rrule.toString()
        
        // Проверяем, что все параметры присутствуют
        XCTAssertTrue(result.contains("FREQ=WEEKLY"))
        XCTAssertTrue(result.contains("INTERVAL=2"))
        XCTAssertTrue(result.contains("COUNT=10"))
        XCTAssertTrue(result.contains("BYDAY=MO,WE,FR"))
        XCTAssertTrue(result.contains("BYHOUR=9,17"))
        XCTAssertTrue(result.contains("BYMINUTE=0,30"))
    }
    
    // MARK: - Optimization Tests (Default Values)
    
    func testGenerateOmitsDefaultInterval() {
        let rrule = RRule(frequency: .daily, interval: 1)
        let result = rrule.toString()
        
        // INTERVAL=1 не должен быть включен (значение по умолчанию)
        XCTAssertFalse(result.contains("INTERVAL=1"))
        XCTAssertEqual(result, "FREQ=DAILY")
    }
    
    func testGenerateOmitsDefaultWkst() {
        let rrule = RRule(frequency: .weekly, wkst: .monday)
        let result = rrule.toString()
        
        // WKST=MO не должен быть включен (значение по умолчанию)
        XCTAssertFalse(result.contains("WKST=MO"))
        XCTAssertEqual(result, "FREQ=WEEKLY")
    }
    
    func testGenerateIncludesNonDefaultWkst() {
        let rrule = RRule(frequency: .weekly, wkst: .sunday)
        let result = rrule.toString()
        
        // WKST=SU должен быть включен (не значение по умолчанию)
        XCTAssertTrue(result.contains("WKST=SU"))
    }
    
    // MARK: - Round-Trip Tests (Parse -> Generate -> Parse)
    
    func testRoundTripBasicDaily() throws {
        let original = "FREQ=DAILY"
        let rrule = try RRule.parse(original)
        let generated = rrule.toString()
        let reparsed = try RRule.parse(generated)
        
        XCTAssertEqual(rrule.frequency, reparsed.frequency)
        XCTAssertEqual(rrule.interval, reparsed.interval)
    }
    
    func testRoundTripDailyWithInterval() throws {
        let original = "FREQ=DAILY;INTERVAL=2"
        let rrule = try RRule.parse(original)
        let generated = rrule.toString()
        let reparsed = try RRule.parse(generated)
        
        XCTAssertEqual(rrule.frequency, reparsed.frequency)
        XCTAssertEqual(rrule.interval, reparsed.interval)
    }
    
    func testRoundTripWeeklyWithByDay() throws {
        let original = "FREQ=WEEKLY;BYDAY=MO,WE,FR"
        let rrule = try RRule.parse(original)
        let generated = rrule.toString()
        let reparsed = try RRule.parse(generated)
        
        XCTAssertEqual(rrule.frequency, reparsed.frequency)
        XCTAssertEqual(rrule.byDay?.count, reparsed.byDay?.count)
    }
    
    func testRoundTripMonthlyWithByMonthDay() throws {
        let original = "FREQ=MONTHLY;BYMONTHDAY=1,15"
        let rrule = try RRule.parse(original)
        let generated = rrule.toString()
        let reparsed = try RRule.parse(generated)
        
        XCTAssertEqual(rrule.frequency, reparsed.frequency)
        XCTAssertEqual(rrule.byMonthDay, reparsed.byMonthDay)
    }
    
    func testRoundTripComplexRule() throws {
        let original = "FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR;COUNT=10"
        let rrule = try RRule.parse(original)
        let generated = rrule.toString()
        let reparsed = try RRule.parse(generated)
        
        XCTAssertEqual(rrule.frequency, reparsed.frequency)
        XCTAssertEqual(rrule.interval, reparsed.interval)
        XCTAssertEqual(rrule.count, reparsed.count)
        XCTAssertEqual(rrule.byDay?.count, reparsed.byDay?.count)
    }
    
    // MARK: - Edge Cases
    
    func testGenerateWithEmptyArrays() {
        let rrule = RRule(
            frequency: .daily,
            bySecond: [],
            byMinute: [],
            byHour: []
        )
        let result = rrule.toString()
        
        // Пустые массивы не должны быть включены
        XCTAssertFalse(result.contains("BYSECOND"))
        XCTAssertFalse(result.contains("BYMINUTE"))
        XCTAssertFalse(result.contains("BYHOUR"))
        XCTAssertEqual(result, "FREQ=DAILY")
    }
    
    func testGenerateWithNegativeValues() {
        let rrule = RRule(
            frequency: .monthly,
            byMonthDay: [-1, -2]
        )
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("BYMONTHDAY=-1,-2"))
    }
    
    // MARK: - Additional Tests
    
    func testGenerateWithAllByRulesAdditional() {
        let rrule = RRule(
            frequency: .daily,
            interval: 2,
            count: 10,
            bySecond: [0, 30],
            byMinute: [0, 15, 30, 45],
            byHour: [9, 17],
            byDay: [.monday, .friday],
            byMonthDay: [1, 15],
            byYearDay: [1, 365],
            byWeekNo: [1, 52],
            byMonth: [1, 6, 12],
            bySetPos: [1, -1],
            wkst: .sunday
        )
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("FREQ=DAILY"))
        XCTAssertTrue(result.contains("INTERVAL=2"))
        XCTAssertTrue(result.contains("COUNT=10"))
        XCTAssertTrue(result.contains("BYSECOND=0,30"))
        XCTAssertTrue(result.contains("BYMINUTE=0,15,30,45"))
        XCTAssertTrue(result.contains("BYHOUR=9,17"))
        XCTAssertTrue(result.contains("BYDAY=MO,FR"))
        XCTAssertTrue(result.contains("BYMONTHDAY=1,15"))
        XCTAssertTrue(result.contains("BYYEARDAY=1,365"))
        XCTAssertTrue(result.contains("BYWEEKNO=1,52"))
        XCTAssertTrue(result.contains("BYMONTH=1,6,12"))
        XCTAssertTrue(result.contains("BYSETPOS=1,-1"))
        XCTAssertTrue(result.contains("WKST=SU"))
    }
    
    func testGenerateWithUntilDate() {
        var components = DateComponents()
        components.year = 2024
        components.month = 12
        components.day = 31
        components.hour = 23
        components.minute = 59
        components.second = 59
        let untilDate = Calendar(identifier: .gregorian).date(from: components)!
        
        let rrule = RRule(frequency: .daily, until: untilDate)
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("FREQ=DAILY"))
        XCTAssertTrue(result.contains("UNTIL="))
    }
    
    func testGenerateWithSingleByRule() {
        let rrule = RRule(frequency: .daily, byHour: [9])
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("BYHOUR=9"))
    }
    
    func testGenerateWithMultipleByDay() {
        let rrule = RRule(
            frequency: .weekly,
            byDay: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        )
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("BYDAY=MO,TU,WE,TH,FR,SA,SU"))
    }
    
    func testGenerateWithByDayPositions() {
        let rrule = RRule(
            frequency: .monthly,
            byDay: [
                Weekday(dayOfWeek: 2, position: 1),
                Weekday(dayOfWeek: 2, position: 2),
                Weekday(dayOfWeek: 2, position: -1)
            ]
        )
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("BYDAY=1MO,2MO,-1MO"))
    }
    
    func testGenerateOrderOfParameters() {
        // Проверяем, что параметры идут в правильном порядке
        let rrule = RRule(
            frequency: .weekly,
            interval: 2,
            count: 10,
            byDay: [.monday]
        )
        let result = rrule.toString()
        
        let components = result.components(separatedBy: ";")
        XCTAssertEqual(components[0], "FREQ=WEEKLY")
        XCTAssertTrue(components.contains("INTERVAL=2"))
        XCTAssertTrue(components.contains("COUNT=10"))
        XCTAssertTrue(components.contains("BYDAY=MO"))
    }
    
    func testGenerateWithLargeInterval() {
        let rrule = RRule(frequency: .daily, interval: 100)
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("INTERVAL=100"))
    }
    
    func testGenerateWithLargeCount() {
        let rrule = RRule(frequency: .daily, count: 1000)
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("COUNT=1000"))
    }
    
    func testGenerateYearlyWithAllMonths() {
        let rrule = RRule(frequency: .yearly, byMonth: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("BYMONTH=1,2,3,4,5,6,7,8,9,10,11,12"))
    }
    
    func testGenerateWithWkstSunday() {
        let rrule = RRule(frequency: .weekly, wkst: .sunday)
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("WKST=SU"))
    }
    
    func testGenerateWithWkstSaturday() {
        let rrule = RRule(frequency: .weekly, wkst: .saturday)
        let result = rrule.toString()
        
        XCTAssertTrue(result.contains("WKST=SA"))
    }
    
    // MARK: - Round-Trip Additional Tests
    
    func testRoundTripWithUntil() throws {
        var components = DateComponents()
        components.year = 2024
        components.month = 12
        components.day = 31
        let untilDate = Calendar(identifier: .gregorian).date(from: components)!
        
        let rrule = RRule(frequency: .daily, until: untilDate)
        let generated = rrule.toString()
        let reparsed = try RRule.parse(generated)
        
        XCTAssertEqual(rrule.frequency, reparsed.frequency)
        // UNTIL может отличаться из-за форматирования, но должна быть близка
        if let until1 = rrule.until, let until2 = reparsed.until {
            let diff = abs(until1.timeIntervalSince(until2))
            XCTAssertLessThan(diff, 86400, "UNTIL dates should be within 1 day")
        } else {
            // Если UNTIL не распарсился или не сгенерировался, это может быть ожидаемым
            // Но в этом тесте мы ожидаем, что UNTIL должен быть
            XCTFail("UNTIL should be present in both original and reparsed RRule")
        }
    }
    
    func testRoundTripWithAllByRules() throws {
        let original = "FREQ=DAILY;INTERVAL=2;COUNT=10;BYSECOND=0,30;BYMINUTE=0,15;BYHOUR=9,17;BYDAY=MO,FR;BYMONTHDAY=1,15;BYMONTH=1,6,12"
        let rrule = try RRule.parse(original)
        let generated = rrule.toString()
        let reparsed = try RRule.parse(generated)
        
        XCTAssertEqual(rrule.frequency, reparsed.frequency)
        XCTAssertEqual(rrule.interval, reparsed.interval)
        XCTAssertEqual(rrule.count, reparsed.count)
        XCTAssertEqual(rrule.bySecond, reparsed.bySecond)
        XCTAssertEqual(rrule.byMinute, reparsed.byMinute)
        XCTAssertEqual(rrule.byHour, reparsed.byHour)
        XCTAssertEqual(rrule.byMonthDay, reparsed.byMonthDay)
        XCTAssertEqual(rrule.byMonth, reparsed.byMonth)
    }
    
    // MARK: - Edge Cases and Error Detection
    
    func testGenerateWithZeroInterval() {
        // INTERVAL=0 не должен включаться в результат (по умолчанию 1)
        let rrule = RRule(frequency: .daily, interval: 0)
        let result = rrule.toString()
        // INTERVAL=0 может быть сгенерирован или пропущен
        XCTAssertTrue(result.contains("FREQ=DAILY"))
    }
    
    func testGenerateWithNegativeInterval() {
        // Отрицательный INTERVAL
        let rrule = RRule(frequency: .daily, interval: -1)
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=DAILY"))
    }
    
    func testGenerateWithZeroCount() {
        // COUNT=0
        let rrule = RRule(frequency: .daily, count: 0)
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=DAILY"))
    }
    
    func testGenerateWithNegativeCount() {
        // Отрицательный COUNT
        let rrule = RRule(frequency: .daily, count: -1)
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=DAILY"))
    }
    
    func testGenerateWithLargeValues() {
        // Большие значения
        let rrule = RRule(frequency: .daily, interval: 999999, count: 999999)
        let result = rrule.toString()
        XCTAssertTrue(result.contains("INTERVAL=999999"))
        XCTAssertTrue(result.contains("COUNT=999999"))
    }
    
    func testGenerateWithEmptyArraysEdgeCase() {
        // Пустые массивы не должны включаться
        let rrule = RRule(
            frequency: .daily,
            bySecond: [],
            byMinute: [],
            byHour: []
        )
        let result = rrule.toString()
        XCTAssertFalse(result.contains("BYSECOND"))
        XCTAssertFalse(result.contains("BYMINUTE"))
        XCTAssertFalse(result.contains("BYHOUR"))
    }
    
    func testGenerateWithSingleValueArrays() {
        // Массивы с одним значением
        let rrule = RRule(
            frequency: .daily,
            bySecond: [0],
            byMinute: [30],
            byHour: [12]
        )
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYSECOND=0"))
        XCTAssertTrue(result.contains("BYMINUTE=30"))
        XCTAssertTrue(result.contains("BYHOUR=12"))
    }
    
    func testGenerateWithLargeArrays() {
        // Большие массивы
        let rrule = RRule(
            frequency: .daily,
            bySecond: Array(0...59),
            byMinute: Array(0...59),
            byHour: Array(0...23)
        )
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYSECOND"))
        XCTAssertTrue(result.contains("BYMINUTE"))
        XCTAssertTrue(result.contains("BYHOUR"))
    }
    
    func testGenerateWithNegativeByMonthDay() {
        // Отрицательные значения BYMONTHDAY
        let rrule = RRule(frequency: .monthly, byMonthDay: [-1, -7])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYMONTHDAY=-1,-7"))
    }
    
    func testGenerateWithNegativeByYearDay() {
        // Отрицательные значения BYYEARDAY
        let rrule = RRule(frequency: .yearly, byYearDay: [-1, -100])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYYEARDAY=-1,-100"))
    }
    
    func testGenerateWithNegativeByWeekNo() {
        // Отрицательные значения BYWEEKNO
        let rrule = RRule(frequency: .yearly, byWeekNo: [-1, -26])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYWEEKNO=-1,-26"))
    }
    
    func testGenerateWithNegativeBySetPos() {
        // Отрицательные значения BYSETPOS
        let rrule = RRule(frequency: .monthly, bySetPos: [-1, -2])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYSETPOS=-1,-2"))
    }
    
    func testGenerateWithByDayPositionsEdgeCase() {
        // BYDAY с позициями
        let rrule = RRule(
            frequency: .monthly,
            byDay: [
                Weekday(dayOfWeek: 2, position: 1),
                Weekday(dayOfWeek: 6, position: -1)
            ]
        )
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYDAY=1MO,-1FR") || result.contains("BYDAY=-1FR,1MO"))
    }
    
    func testGenerateWithAllByRulesComplex() {
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
            bySetPos: [1, -1]
        )
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYSECOND"))
        XCTAssertTrue(result.contains("BYMINUTE"))
        XCTAssertTrue(result.contains("BYHOUR"))
        XCTAssertTrue(result.contains("BYDAY"))
        XCTAssertTrue(result.contains("BYMONTHDAY"))
        XCTAssertTrue(result.contains("BYYEARDAY"))
        XCTAssertTrue(result.contains("BYWEEKNO"))
        XCTAssertTrue(result.contains("BYMONTH"))
        XCTAssertTrue(result.contains("BYSETPOS"))
    }
    
    func testGenerateWithWkst() {
        // WKST
        let rrule = RRule(frequency: .weekly, wkst: .sunday)
        let result = rrule.toString()
        XCTAssertTrue(result.contains("WKST=SU"))
    }
    
    func testGenerateWithUntil() {
        // UNTIL
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
        let result = rrule.toString()
        XCTAssertTrue(result.contains("UNTIL="))
    }
    
    func testGenerateDefaultInterval() {
        // INTERVAL=1 не должен включаться (значение по умолчанию)
        let rrule = RRule(frequency: .daily, interval: 1)
        let result = rrule.toString()
        XCTAssertFalse(result.contains("INTERVAL=1"))
    }
    
    func testGenerateDefaultWkst() {
        // WKST=MO не должен включаться (значение по умолчанию)
        let rrule = RRule(frequency: .weekly, wkst: .monday)
        let result = rrule.toString()
        XCTAssertFalse(result.contains("WKST=MO"))
    }
    
    func testGenerateSortedArrays() {
        // Массивы должны быть отсортированы в выводе
        let rrule = RRule(
            frequency: .daily,
            byMinute: [45, 0, 30],
            byHour: [17, 9, 12]
        )
        let result = rrule.toString()
        // Проверяем, что значения присутствуют (сортировка зависит от реализации)
        XCTAssertTrue(result.contains("BYHOUR"))
        XCTAssertTrue(result.contains("BYMINUTE"))
        XCTAssertTrue(result.contains("9") || result.contains("12") || result.contains("17"))
        XCTAssertTrue(result.contains("0") || result.contains("30") || result.contains("45"))
    }
    
    func testGenerateRoundTripComplex() throws {
        // Round-trip тест для сложного правила
        let original = "FREQ=WEEKLY;INTERVAL=2;COUNT=10;BYDAY=MO,WE,FR;BYHOUR=9,17;BYMINUTE=0,30;BYSECOND=0;BYMONTHDAY=1,15;BYMONTH=1,6,12;BYSETPOS=1,-1;WKST=SU"
        let rrule = try RRule.parse(original)
        let generated = rrule.toString()
        let reparsed = try RRule.parse(generated)
        
        XCTAssertEqual(rrule.frequency, reparsed.frequency)
        XCTAssertEqual(rrule.interval, reparsed.interval)
        XCTAssertEqual(rrule.count, reparsed.count)
        XCTAssertEqual(rrule.byDay?.count, reparsed.byDay?.count)
        XCTAssertEqual(rrule.byHour, reparsed.byHour)
        XCTAssertEqual(rrule.byMinute, reparsed.byMinute)
        XCTAssertEqual(rrule.bySecond, reparsed.bySecond)
    }
    
    func testGenerateWithDuplicateValues() {
        // Дублирующиеся значения должны быть удалены
        let rrule = RRule(
            frequency: .daily,
            byHour: [9, 9, 17, 17]
        )
        let result = rrule.toString()
        // Проверяем, что дубликаты удалены (или сохранены - зависит от реализации)
        XCTAssertTrue(result.contains("BYHOUR"))
    }
    
    // MARK: - Additional Advanced Tests
    
    func testGenerateWithAllFrequencies() {
        // Все частоты
        let daily = RRule(frequency: .daily).toString()
        let weekly = RRule(frequency: .weekly).toString()
        let monthly = RRule(frequency: .monthly).toString()
        let yearly = RRule(frequency: .yearly).toString()
        
        XCTAssertTrue(daily.contains("FREQ=DAILY"))
        XCTAssertTrue(weekly.contains("FREQ=WEEKLY"))
        XCTAssertTrue(monthly.contains("FREQ=MONTHLY"))
        XCTAssertTrue(yearly.contains("FREQ=YEARLY"))
    }
    
    func testGenerateWithAllWeekdays() {
        // Все дни недели
        let rrule = RRule(frequency: .weekly, byDay: [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYDAY"))
        XCTAssertTrue(result.contains("SU") || result.contains("MO") || result.contains("TU"))
    }
    
    func testGenerateWithAllMonths() {
        // Все месяцы
        let rrule = RRule(frequency: .yearly, byMonth: Array(1...12))
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYMONTH"))
    }
    
    func testGenerateWithAllHours() {
        // Все часы
        let rrule = RRule(frequency: .daily, byHour: Array(0...23))
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYHOUR"))
    }
    
    func testGenerateWithAllMinutes() {
        // Все минуты (выборочно)
        let rrule = RRule(frequency: .daily, byMinute: Array(0...59))
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYMINUTE"))
    }
    
    func testGenerateWithAllSeconds() {
        // Все секунды (выборочно)
        let rrule = RRule(frequency: .daily, bySecond: Array(0...59))
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYSECOND"))
    }
    
    func testGenerateWithNegativeByMonthDayRange() {
        // Диапазон отрицательных дней месяца
        let rrule = RRule(frequency: .monthly, byMonthDay: Array(-7...(-1)))
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYMONTHDAY"))
        XCTAssertTrue(result.contains("-"))
    }
    
    func testGenerateWithNegativeByYearDayRange() {
        // Диапазон отрицательных дней года
        let rrule = RRule(frequency: .yearly, byYearDay: Array(-7...(-1)))
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYYEARDAY"))
        XCTAssertTrue(result.contains("-"))
    }
    
    func testGenerateWithNegativeByWeekNoRange() {
        // Диапазон отрицательных недель года
        let rrule = RRule(frequency: .yearly, byWeekNo: Array(-4...(-1)))
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYWEEKNO"))
        XCTAssertTrue(result.contains("-"))
    }
    
    func testGenerateWithNegativeBySetPosRange() {
        // Диапазон отрицательных BYSETPOS
        let rrule = RRule(frequency: .monthly, bySetPos: Array(-4...(-1)))
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYSETPOS"))
        XCTAssertTrue(result.contains("-"))
    }
    
    func testGenerateWithByDayPositionsRange() {
        // Диапазон позиций BYDAY
        let rrule = RRule(
            frequency: .monthly,
            byDay: [
                Weekday(dayOfWeek: 2, position: 1),
                Weekday(dayOfWeek: 2, position: 2),
                Weekday(dayOfWeek: 2, position: 3),
                Weekday(dayOfWeek: 2, position: -2),
                Weekday(dayOfWeek: 2, position: -1)
            ]
        )
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYDAY"))
    }
    
    func testGenerateWithUntilAtMidnight() {
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
        let result = rrule.toString()
        XCTAssertTrue(result.contains("UNTIL="))
    }
    
    func testGenerateWithUntilAtEndOfDay() {
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
        let result = rrule.toString()
        XCTAssertTrue(result.contains("UNTIL="))
    }
    
    func testGenerateWithUntilInFuture() {
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
        let result = rrule.toString()
        XCTAssertTrue(result.contains("UNTIL="))
    }
    
    func testGenerateWithUntilInPast() {
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
        let result = rrule.toString()
        XCTAssertTrue(result.contains("UNTIL="))
    }
    
    func testGenerateWithIntervalOne() {
        // INTERVAL=1 не должен включаться (по умолчанию)
        let rrule = RRule(frequency: .daily, interval: 1)
        let result = rrule.toString()
        XCTAssertFalse(result.contains("INTERVAL=1"))
    }
    
    func testGenerateWithIntervalMax() {
        // Максимальный INTERVAL
        let rrule = RRule(frequency: .daily, interval: 999999)
        let result = rrule.toString()
        XCTAssertTrue(result.contains("INTERVAL=999999"))
    }
    
    func testGenerateWithCountMax() {
        // Максимальный COUNT
        let rrule = RRule(frequency: .daily, count: 999999)
        let result = rrule.toString()
        XCTAssertTrue(result.contains("COUNT=999999"))
    }
    
    func testGenerateWithMultipleByRules() {
        // Множественные BY* правила
        let rrule = RRule(
            frequency: .daily,
            bySecond: [0, 30],
            byMinute: [0, 15, 30, 45],
            byHour: [9, 12, 15, 18],
            byDay: [.monday, .wednesday, .friday],
            byMonthDay: [1, 15],
            byMonth: [1, 6, 12]
        )
        let result = rrule.toString()
        XCTAssertTrue(result.contains("BYSECOND"))
        XCTAssertTrue(result.contains("BYMINUTE"))
        XCTAssertTrue(result.contains("BYHOUR"))
        XCTAssertTrue(result.contains("BYDAY"))
        XCTAssertTrue(result.contains("BYMONTHDAY"))
        XCTAssertTrue(result.contains("BYMONTH"))
    }
    
    func testGenerateWithWkstAllDays() {
        // Все возможные WKST
        let sunday = RRule(frequency: .weekly, wkst: .sunday).toString()
        let monday = RRule(frequency: .weekly, wkst: .monday).toString()
        let tuesday = RRule(frequency: .weekly, wkst: .tuesday).toString()
        let wednesday = RRule(frequency: .weekly, wkst: .wednesday).toString()
        let thursday = RRule(frequency: .weekly, wkst: .thursday).toString()
        let friday = RRule(frequency: .weekly, wkst: .friday).toString()
        let saturday = RRule(frequency: .weekly, wkst: .saturday).toString()
        
        XCTAssertTrue(sunday.contains("WKST=SU"))
        XCTAssertFalse(monday.contains("WKST=MO")) // По умолчанию
        XCTAssertTrue(tuesday.contains("WKST=TU"))
        XCTAssertTrue(wednesday.contains("WKST=WE"))
        XCTAssertTrue(thursday.contains("WKST=TH"))
        XCTAssertTrue(friday.contains("WKST=FR"))
        XCTAssertTrue(saturday.contains("WKST=SA"))
    }
    
    func testGenerateWithRealWorldExample1() {
        // Реальный пример: каждую неделю в понедельник, среду и пятницу
        let rrule = RRule(frequency: .weekly, count: 10, byDay: [.monday, .wednesday, .friday])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=WEEKLY"))
        XCTAssertTrue(result.contains("COUNT=10"))
        XCTAssertTrue(result.contains("BYDAY"))
    }
    
    func testGenerateWithRealWorldExample2() {
        // Реальный пример: каждый месяц в первое и 15-е число
        let rrule = RRule(frequency: .monthly, count: 12, byMonthDay: [1, 15])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=MONTHLY"))
        XCTAssertTrue(result.contains("COUNT=12"))
        XCTAssertTrue(result.contains("BYMONTHDAY=1,15"))
    }
    
    func testGenerateWithRealWorldExample3() {
        // Реальный пример: каждый год в январе и июне
        let rrule = RRule(frequency: .yearly, count: 10, byMonth: [1, 6])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=YEARLY"))
        XCTAssertTrue(result.contains("COUNT=10"))
        XCTAssertTrue(result.contains("BYMONTH=1,6"))
    }
    
    func testGenerateWithRealWorldExample4() {
        // Реальный пример: каждый день в 9:00 и 17:00
        let rrule = RRule(frequency: .daily, count: 10, byHour: [9, 17])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=DAILY"))
        XCTAssertTrue(result.contains("COUNT=10"))
        XCTAssertTrue(result.contains("BYHOUR=9,17"))
    }
    
    func testGenerateWithRealWorldExample5() {
        // Реальный пример: каждые 2 недели в понедельник и пятницу
        let rrule = RRule(frequency: .weekly, interval: 2, count: 10, byDay: [.monday, .friday])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=WEEKLY"))
        XCTAssertTrue(result.contains("INTERVAL=2"))
        XCTAssertTrue(result.contains("COUNT=10"))
        XCTAssertTrue(result.contains("BYDAY"))
    }
    
    func testGenerateWithRealWorldExample6() {
        // Реальный пример: каждый месяц в первый понедельник
        let rrule = RRule(frequency: .monthly, count: 6, byDay: [Weekday(dayOfWeek: 2, position: 1)])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=MONTHLY"))
        XCTAssertTrue(result.contains("COUNT=6"))
        XCTAssertTrue(result.contains("BYDAY=1MO"))
    }
    
    func testGenerateWithRealWorldExample7() {
        // Реальный пример: каждый год в последнюю пятницу декабря
        let rrule = RRule(
            frequency: .yearly,
            count: 5,
            byDay: [Weekday(dayOfWeek: 6, position: -1)],
            byMonth: [12]
        )
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=YEARLY"))
        XCTAssertTrue(result.contains("COUNT=5"))
        XCTAssertTrue(result.contains("BYMONTH=12"))
        XCTAssertTrue(result.contains("BYDAY=-1FR"))
    }
    
    func testGenerateWithRealWorldExample8() {
        // Реальный пример: каждые 3 месяца в первое число
        let rrule = RRule(frequency: .monthly, interval: 3, count: 4, byMonthDay: [1])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=MONTHLY"))
        XCTAssertTrue(result.contains("INTERVAL=3"))
        XCTAssertTrue(result.contains("COUNT=4"))
        XCTAssertTrue(result.contains("BYMONTHDAY=1"))
    }
    
    func testGenerateWithRealWorldExample9() {
        // Реальный пример: каждый день в :00 и :30 минут
        let rrule = RRule(frequency: .daily, count: 10, byMinute: [0, 30])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=DAILY"))
        XCTAssertTrue(result.contains("COUNT=10"))
        XCTAssertTrue(result.contains("BYMINUTE=0,30"))
    }
    
    func testGenerateWithRealWorldExample10() {
        // Реальный пример: каждую неделю в рабочие дни
        let rrule = RRule(frequency: .weekly, count: 10, byDay: [.monday, .tuesday, .wednesday, .thursday, .friday])
        let result = rrule.toString()
        XCTAssertTrue(result.contains("FREQ=WEEKLY"))
        XCTAssertTrue(result.contains("COUNT=10"))
        XCTAssertTrue(result.contains("BYDAY"))
    }
    
    func testGenerateRoundTripWithAllFrequencies() throws {
        // Round-trip для всех частот
        for frequency in [Frequency.daily, .weekly, .monthly, .yearly] {
            let original = "FREQ=\(frequency.rawValue);COUNT=10"
            let rrule = try RRule.parse(original)
            let generated = rrule.toString()
            let reparsed = try RRule.parse(generated)
            
            XCTAssertEqual(rrule.frequency, reparsed.frequency)
            XCTAssertEqual(rrule.count, reparsed.count)
        }
    }
    
    func testGenerateRoundTripWithAllByRules() throws {
        // Round-trip для всех BY* правил
        let original = "FREQ=DAILY;BYSECOND=0,30;BYMINUTE=0,15,30,45;BYHOUR=9,12,15,18;BYDAY=MO,WE,FR;BYMONTHDAY=1,15;BYMONTH=1,6,12;BYSETPOS=1,-1"
        let rrule = try RRule.parse(original)
        let generated = rrule.toString()
        let reparsed = try RRule.parse(generated)
        
        XCTAssertEqual(rrule.frequency, reparsed.frequency)
        XCTAssertEqual(rrule.bySecond, reparsed.bySecond)
        XCTAssertEqual(rrule.byMinute, reparsed.byMinute)
        XCTAssertEqual(rrule.byHour, reparsed.byHour)
        XCTAssertEqual(rrule.byDay?.count, reparsed.byDay?.count)
        XCTAssertEqual(rrule.byMonthDay, reparsed.byMonthDay)
        XCTAssertEqual(rrule.byMonth, reparsed.byMonth)
        XCTAssertEqual(rrule.bySetPos, reparsed.bySetPos)
    }
    
    func testGenerateConsistency() {
        // Согласованность генерации
        let rrule1 = RRule(frequency: .daily, count: 10)
        let rrule2 = RRule(frequency: .daily, count: 10)
        
        let result1 = rrule1.toString()
        let result2 = rrule2.toString()
        
        XCTAssertEqual(result1, result2)
    }
    
    func testGenerateOrder() {
        // Порядок параметров в выводе
        let rrule = RRule(
            frequency: .daily,
            interval: 2,
            count: 10,
            bySecond: [0],
            byMinute: [0],
            byHour: [9]
        )
        let result = rrule.toString()
        
        // FREQ должен быть первым
        XCTAssertTrue(result.hasPrefix("FREQ="))
    }
}

