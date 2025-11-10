//
//  RRuleParserTests.swift
//  SwiftRRuleTests
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import XCTest
@testable import SwiftRRule

final class RRuleParserTests: XCTestCase {
    
    // MARK: - Basic Parsing Tests
    
    func testParseBasicDaily() throws {
        let rrule = try RRule.parse("FREQ=DAILY")
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertNil(rrule.interval)
        XCTAssertNil(rrule.count)
        XCTAssertNil(rrule.until)
    }
    
    func testParseDailyWithInterval() throws {
        let rrule = try RRule.parse("FREQ=DAILY;INTERVAL=2")
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.interval, 2)
    }
    
    func testParseDailyWithCount() throws {
        let rrule = try RRule.parse("FREQ=DAILY;COUNT=10")
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.count, 10)
    }
    
    func testParseWeekly() throws {
        let rrule = try RRule.parse("FREQ=WEEKLY")
        
        XCTAssertEqual(rrule.frequency, .weekly)
    }
    
    func testParseMonthly() throws {
        let rrule = try RRule.parse("FREQ=MONTHLY")
        
        XCTAssertEqual(rrule.frequency, .monthly)
    }
    
    func testParseYearly() throws {
        let rrule = try RRule.parse("FREQ=YEARLY")
        
        XCTAssertEqual(rrule.frequency, .yearly)
    }
    
    // MARK: - Complex Parsing Tests
    
    func testParseWithAllBasicParameters() throws {
        let rrule = try RRule.parse("FREQ=DAILY;INTERVAL=2;COUNT=10")
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.interval, 2)
        XCTAssertEqual(rrule.count, 10)
    }
    
    func testParseWithByDay() throws {
        let rrule = try RRule.parse("FREQ=WEEKLY;BYDAY=MO,WE,FR")
        
        XCTAssertEqual(rrule.frequency, .weekly)
        XCTAssertNotNil(rrule.byDay)
        XCTAssertEqual(rrule.byDay?.count, 3)
        XCTAssertEqual(rrule.byDay?[0].dayOfWeek, 2) // MO
        XCTAssertEqual(rrule.byDay?[1].dayOfWeek, 4) // WE
        XCTAssertEqual(rrule.byDay?[2].dayOfWeek, 6) // FR
    }
    
    func testParseWithByDayWithPosition() throws {
        let rrule = try RRule.parse("FREQ=MONTHLY;BYDAY=2MO")
        
        XCTAssertEqual(rrule.frequency, .monthly)
        XCTAssertNotNil(rrule.byDay)
        XCTAssertEqual(rrule.byDay?.count, 1)
        XCTAssertEqual(rrule.byDay?[0].dayOfWeek, 2) // MO
        XCTAssertEqual(rrule.byDay?[0].position, 2)
    }
    
    func testParseWithByDayWithNegativePosition() throws {
        let rrule = try RRule.parse("FREQ=MONTHLY;BYDAY=-1FR")
        
        XCTAssertEqual(rrule.frequency, .monthly)
        XCTAssertNotNil(rrule.byDay)
        XCTAssertEqual(rrule.byDay?.count, 1)
        XCTAssertEqual(rrule.byDay?[0].dayOfWeek, 6) // FR
        XCTAssertEqual(rrule.byDay?[0].position, -1)
    }
    
    func testParseWithByMonthDay() throws {
        let rrule = try RRule.parse("FREQ=MONTHLY;BYMONTHDAY=1,15")
        
        XCTAssertEqual(rrule.frequency, .monthly)
        XCTAssertEqual(rrule.byMonthDay, [1, 15])
    }
    
    func testParseWithByMonth() throws {
        let rrule = try RRule.parse("FREQ=YEARLY;BYMONTH=1,6,12")
        
        XCTAssertEqual(rrule.frequency, .yearly)
        XCTAssertEqual(rrule.byMonth, [1, 6, 12])
    }
    
    func testParseWithByHour() throws {
        let rrule = try RRule.parse("FREQ=DAILY;BYHOUR=9,17")
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.byHour, [9, 17])
    }
    
    func testParseWithByMinute() throws {
        let rrule = try RRule.parse("FREQ=DAILY;BYMINUTE=0,15,30,45")
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.byMinute, [0, 15, 30, 45])
    }
    
    func testParseWithBySecond() throws {
        let rrule = try RRule.parse("FREQ=DAILY;BYSECOND=0,30")
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.bySecond, [0, 30])
    }
    
    func testParseWithWkst() throws {
        let rrule = try RRule.parse("FREQ=WEEKLY;WKST=SU")
        
        XCTAssertEqual(rrule.frequency, .weekly)
        XCTAssertEqual(rrule.wkst?.dayOfWeek, 1) // SU
    }
    
    func testParseWithUntil() throws {
        // Формат YYYYMMDD
        let rrule = try RRule.parse("FREQ=DAILY;UNTIL=20241231")
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertNotNil(rrule.until)
    }
    
    func testParseComplexRule() throws {
        let rrule = try RRule.parse("FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR;COUNT=10")
        
        XCTAssertEqual(rrule.frequency, .weekly)
        XCTAssertEqual(rrule.interval, 2)
        XCTAssertEqual(rrule.count, 10)
        XCTAssertNotNil(rrule.byDay)
        XCTAssertEqual(rrule.byDay?.count, 3)
    }
    
    // MARK: - Error Handling Tests
    
    func testParseEmptyString() {
        XCTAssertThrowsError(try RRule.parse("")) { error in
            XCTAssertEqual(error as? RRuleParseError, .emptyString)
        }
    }
    
    func testParseMissingFrequency() {
        XCTAssertThrowsError(try RRule.parse("INTERVAL=2;COUNT=10")) { error in
            XCTAssertEqual(error as? RRuleParseError, .missingFrequency)
        }
    }
    
    func testParseInvalidFrequency() {
        XCTAssertThrowsError(try RRule.parse("FREQ=INVALID")) { error in
            if case .invalidFrequency(let freq) = error as? RRuleParseError {
                XCTAssertEqual(freq, "INVALID")
            } else {
                XCTFail("Expected invalidFrequency error")
            }
        }
    }
    
    func testParseInvalidInterval() {
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;INTERVAL=invalid")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "invalid")
                XCTAssertEqual(key, "INTERVAL")
            } else {
                XCTFail("Expected invalidValue error for INTERVAL")
            }
        }
    }
    
    func testParseInvalidCount() {
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;COUNT=invalid")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "invalid")
                XCTAssertEqual(key, "COUNT")
            } else {
                XCTFail("Expected invalidValue error for COUNT")
            }
        }
    }
    
    func testParseInvalidWeekday() {
        XCTAssertThrowsError(try RRule.parse("FREQ=WEEKLY;BYDAY=INVALID")) { error in
            if case .invalidWeekday(let weekday) = error as? RRuleParseError {
                XCTAssertEqual(weekday, "INVALID")
            } else {
                XCTFail("Expected invalidWeekday error")
            }
        }
    }
    
    func testParseInvalidFormat() {
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;INVALID")) { error in
            if case .invalidFormat(let format) = error as? RRuleParseError {
                XCTAssertEqual(format, "INVALID")
            } else {
                XCTFail("Expected invalidFormat error")
            }
        }
    }
    
    // MARK: - Case Insensitive Tests
    
    func testParseCaseInsensitive() throws {
        let rrule1 = try RRule.parse("FREQ=DAILY")
        let rrule2 = try RRule.parse("freq=daily")
        let rrule3 = try RRule.parse("Freq=Daily")
        
        XCTAssertEqual(rrule1.frequency, rrule2.frequency)
        XCTAssertEqual(rrule1.frequency, rrule3.frequency)
    }
    
    // MARK: - Whitespace Handling Tests
    
    func testParseWithWhitespace() throws {
        let rrule = try RRule.parse("FREQ=DAILY; INTERVAL=2 ; COUNT=10")
        
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.interval, 2)
        XCTAssertEqual(rrule.count, 10)
    }
}

