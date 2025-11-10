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
}

