//
//  FrequencyTests.swift
//  SwiftRRuleTests
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import XCTest
@testable import SwiftRRule

final class FrequencyTests: XCTestCase {
    
    func testFrequencyRawValues() {
        XCTAssertEqual(Frequency.daily.rawValue, "DAILY")
        XCTAssertEqual(Frequency.weekly.rawValue, "WEEKLY")
        XCTAssertEqual(Frequency.monthly.rawValue, "MONTHLY")
        XCTAssertEqual(Frequency.yearly.rawValue, "YEARLY")
    }
    
    func testFrequencyFromString() {
        XCTAssertEqual(Frequency(rawValue: "DAILY"), .daily)
        XCTAssertEqual(Frequency(rawValue: "daily"), .daily)
        XCTAssertEqual(Frequency(rawValue: "Daily"), .daily)
        
        XCTAssertEqual(Frequency(rawValue: "WEEKLY"), .weekly)
        XCTAssertEqual(Frequency(rawValue: "MONTHLY"), .monthly)
        XCTAssertEqual(Frequency(rawValue: "YEARLY"), .yearly)
    }
    
    func testFrequencyFromInvalidString() {
        XCTAssertNil(Frequency(rawValue: "INVALID"))
        XCTAssertNil(Frequency(rawValue: ""))
    }
    
    func testFrequencyCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        for frequency in Frequency.allCases {
            let data = try encoder.encode(frequency)
            let decoded = try decoder.decode(Frequency.self, from: data)
            XCTAssertEqual(frequency, decoded)
        }
    }
}

