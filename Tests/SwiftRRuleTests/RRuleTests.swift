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
}

