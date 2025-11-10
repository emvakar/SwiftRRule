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
    
    // MARK: - Edge Cases and Error Detection
    
    func testFrequencyAllCases() {
        // Все случаи Frequency
        let allCases = Frequency.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.daily))
        XCTAssertTrue(allCases.contains(.weekly))
        XCTAssertTrue(allCases.contains(.monthly))
        XCTAssertTrue(allCases.contains(.yearly))
    }
    
    func testFrequencyCaseInsensitive() {
        // Регистронезависимость
        XCTAssertEqual(Frequency(rawValue: "DAILY"), .daily)
        XCTAssertEqual(Frequency(rawValue: "daily"), .daily)
        XCTAssertEqual(Frequency(rawValue: "Daily"), .daily)
        XCTAssertEqual(Frequency(rawValue: "dAiLy"), .daily)
    }
    
    func testFrequencyFromEmptyString() {
        // Пустая строка
        XCTAssertNil(Frequency(rawValue: ""))
    }
    
    func testFrequencyFromWhitespace() {
        // Пробелы
        XCTAssertNil(Frequency(rawValue: "   "))
        XCTAssertNil(Frequency(rawValue: " DAILY "))
    }
    
    func testFrequencyEquatable() {
        // Equatable
        XCTAssertEqual(Frequency.daily, Frequency.daily)
        XCTAssertNotEqual(Frequency.daily, Frequency.weekly)
    }
    
    func testFrequencyHashable() {
        // Hashable
        let freq1 = Frequency.daily
        let freq2 = Frequency.daily
        let freq3 = Frequency.weekly
        
        XCTAssertEqual(freq1.hashValue, freq2.hashValue)
        XCTAssertNotEqual(freq1.hashValue, freq3.hashValue)
    }
    
    func testFrequencyCodableAllCases() throws {
        // Codable для всех случаев
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        for frequency in Frequency.allCases {
            let data = try encoder.encode(frequency)
            let decoded = try decoder.decode(Frequency.self, from: data)
            XCTAssertEqual(frequency, decoded)
        }
    }
    
    func testFrequencyRawValueConsistency() {
        // Согласованность rawValue
        for frequency in Frequency.allCases {
            let fromRaw = Frequency(rawValue: frequency.rawValue)
            XCTAssertEqual(frequency, fromRaw)
        }
    }
}

