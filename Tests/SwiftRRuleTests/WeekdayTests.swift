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
}

