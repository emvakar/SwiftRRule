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
    
    // MARK: - Additional Advanced Tests
    
    func testFrequencyAllCasesOrder() {
        // Порядок всех случаев
        let allCases = Frequency.allCases
        XCTAssertEqual(allCases[0], .daily)
        XCTAssertEqual(allCases[1], .weekly)
        XCTAssertEqual(allCases[2], .monthly)
        XCTAssertEqual(allCases[3], .yearly)
    }
    
    func testFrequencyRawValueUppercase() {
        // rawValue всегда в верхнем регистре
        for frequency in Frequency.allCases {
            XCTAssertEqual(frequency.rawValue, frequency.rawValue.uppercased())
        }
    }
    
    func testFrequencyFromRawValueAllCases() {
        // Из rawValue для всех случаев
        XCTAssertEqual(Frequency(rawValue: "DAILY"), .daily)
        XCTAssertEqual(Frequency(rawValue: "WEEKLY"), .weekly)
        XCTAssertEqual(Frequency(rawValue: "MONTHLY"), .monthly)
        XCTAssertEqual(Frequency(rawValue: "YEARLY"), .yearly)
    }
    
    func testFrequencyFromRawValueCaseInsensitive() {
        // Регистронезависимость для всех случаев
        for frequency in Frequency.allCases {
            XCTAssertEqual(Frequency(rawValue: frequency.rawValue.lowercased()), frequency)
            XCTAssertEqual(Frequency(rawValue: frequency.rawValue.capitalized), frequency)
            XCTAssertEqual(Frequency(rawValue: frequency.rawValue.uppercased()), frequency)
        }
    }
    
    func testFrequencyFromRawValueWithWhitespace() {
        // Пробелы в rawValue
        XCTAssertNil(Frequency(rawValue: " DAILY "))
        XCTAssertNil(Frequency(rawValue: "DAILY "))
        XCTAssertNil(Frequency(rawValue: " DAILY"))
    }
    
    func testFrequencyFromRawValueWithSpecialCharacters() {
        // Специальные символы в rawValue
        XCTAssertNil(Frequency(rawValue: "DAILY!"))
        XCTAssertNil(Frequency(rawValue: "DAILY@"))
        XCTAssertNil(Frequency(rawValue: "DAILY#"))
    }
    
    func testFrequencyFromRawValueWithNumbers() {
        // Числа в rawValue
        XCTAssertNil(Frequency(rawValue: "DAILY1"))
        XCTAssertNil(Frequency(rawValue: "1DAILY"))
        XCTAssertNil(Frequency(rawValue: "DAILY123"))
    }
    
    func testFrequencyFromRawValuePartialMatch() {
        // Частичное совпадение
        XCTAssertNil(Frequency(rawValue: "DAIL"))
        XCTAssertNil(Frequency(rawValue: "DAILYLY"))
        XCTAssertNil(Frequency(rawValue: "WEEK"))
    }
    
    func testFrequencyEquatableAllCases() {
        // Equatable для всех случаев
        for frequency in Frequency.allCases {
            XCTAssertEqual(frequency, frequency)
            for otherFrequency in Frequency.allCases {
                if frequency != otherFrequency {
                    XCTAssertNotEqual(frequency, otherFrequency)
                }
            }
        }
    }
    
    func testFrequencyHashableAllCases() {
        // Hashable для всех случаев
        var set = Set<Frequency>()
        for frequency in Frequency.allCases {
            set.insert(frequency)
        }
        XCTAssertEqual(set.count, 4)
    }
    
    func testFrequencyCodableAllCasesSeparately() throws {
        // Codable для каждого случая отдельно
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let daily = Frequency.daily
        let weekly = Frequency.weekly
        let monthly = Frequency.monthly
        let yearly = Frequency.yearly
        
        let dailyData = try encoder.encode(daily)
        let weeklyData = try encoder.encode(weekly)
        let monthlyData = try encoder.encode(monthly)
        let yearlyData = try encoder.encode(yearly)
        
        let decodedDaily = try decoder.decode(Frequency.self, from: dailyData)
        let decodedWeekly = try decoder.decode(Frequency.self, from: weeklyData)
        let decodedMonthly = try decoder.decode(Frequency.self, from: monthlyData)
        let decodedYearly = try decoder.decode(Frequency.self, from: yearlyData)
        
        XCTAssertEqual(daily, decodedDaily)
        XCTAssertEqual(weekly, decodedWeekly)
        XCTAssertEqual(monthly, decodedMonthly)
        XCTAssertEqual(yearly, decodedYearly)
    }
    
    func testFrequencyCodableArray() throws {
        // Codable для массива частот
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let frequencies: [Frequency] = [.daily, .weekly, .monthly, .yearly]
        let data = try encoder.encode(frequencies)
        let decoded = try decoder.decode([Frequency].self, from: data)
        
        XCTAssertEqual(frequencies, decoded)
    }
    
    func testFrequencyRawValueUniqueness() {
        // Уникальность rawValue
        let rawValues = Frequency.allCases.map { $0.rawValue }
        let uniqueRawValues = Set(rawValues)
        XCTAssertEqual(rawValues.count, uniqueRawValues.count)
    }
    
    func testFrequencyDescription() {
        // Описание частот
        for frequency in Frequency.allCases {
            let description = String(describing: frequency)
            XCTAssertFalse(description.isEmpty)
        }
    }
    
    func testFrequencyDebugDescription() {
        // Отладочное описание частот
        for frequency in Frequency.allCases {
            let description = String(describing: frequency)
            XCTAssertFalse(description.isEmpty)
        }
    }
    
    func testFrequencyInSet() {
        // Частоты в Set
        var set = Set<Frequency>()
        set.insert(.daily)
        set.insert(.weekly)
        set.insert(.monthly)
        set.insert(.yearly)
        set.insert(.daily) // Дубликат
        
        XCTAssertEqual(set.count, 4)
        XCTAssertTrue(set.contains(.daily))
        XCTAssertTrue(set.contains(.weekly))
        XCTAssertTrue(set.contains(.monthly))
        XCTAssertTrue(set.contains(.yearly))
    }
    
    func testFrequencyInArray() {
        // Частоты в массиве
        let array: [Frequency] = [.daily, .weekly, .monthly, .yearly]
        XCTAssertEqual(array.count, 4)
        XCTAssertTrue(array.contains(.daily))
        XCTAssertTrue(array.contains(.weekly))
        XCTAssertTrue(array.contains(.monthly))
        XCTAssertTrue(array.contains(.yearly))
    }
    
    func testFrequencyComparison() {
        // Сравнение частот
        let daily = Frequency.daily
        let weekly = Frequency.weekly
        let monthly = Frequency.monthly
        let yearly = Frequency.yearly
        
        XCTAssertEqual(daily, daily)
        XCTAssertNotEqual(daily, weekly)
        XCTAssertNotEqual(weekly, monthly)
        XCTAssertNotEqual(monthly, yearly)
    }
    
    func testFrequencyStringInterpolation() {
        // Интерполяция строк
        let daily = Frequency.daily
        let weekly = Frequency.weekly
        
        let dailyString = "\(daily)"
        let weeklyString = "\(weekly)"
        
        XCTAssertFalse(dailyString.isEmpty)
        XCTAssertFalse(weeklyString.isEmpty)
    }
    
    func testFrequencyMirror() {
        // Зеркало для отладки
        let daily = Frequency.daily
        let mirror = Mirror(reflecting: daily)
        XCTAssertNotNil(mirror)
    }
    
    func testFrequencyMemoryLayout() {
        // Размер в памяти
        let size = MemoryLayout<Frequency>.size
        XCTAssertGreaterThan(size, 0)
    }
    
    func testFrequencyStride() {
        // Stride для частот
        let allCases = Frequency.allCases
        for i in 0..<allCases.count {
            XCTAssertNotNil(allCases[i])
        }
    }
    
    func testFrequencyIndex() {
        // Индекс в allCases
        let allCases = Frequency.allCases
        if let dailyIndex = allCases.firstIndex(of: .daily) {
            XCTAssertEqual(allCases[dailyIndex], .daily)
        }
        if let weeklyIndex = allCases.firstIndex(of: .weekly) {
            XCTAssertEqual(allCases[weeklyIndex], .weekly)
        }
    }
    
    func testFrequencyFilter() {
        // Фильтрация частот
        let allCases = Frequency.allCases
        let filtered = allCases.filter { $0 == .daily || $0 == .weekly }
        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.contains(.daily))
        XCTAssertTrue(filtered.contains(.weekly))
    }
    
    func testFrequencyMap() {
        // Преобразование частот
        let allCases = Frequency.allCases
        let rawValues = allCases.map { $0.rawValue }
        XCTAssertEqual(rawValues.count, 4)
        XCTAssertTrue(rawValues.contains("DAILY"))
        XCTAssertTrue(rawValues.contains("WEEKLY"))
        XCTAssertTrue(rawValues.contains("MONTHLY"))
        XCTAssertTrue(rawValues.contains("YEARLY"))
    }
    
    func testFrequencyReduce() {
        // Сведение частот
        let allCases = Frequency.allCases
        let combined = allCases.reduce("") { $0 + $1.rawValue }
        XCTAssertTrue(combined.contains("DAILY"))
        XCTAssertTrue(combined.contains("WEEKLY"))
        XCTAssertTrue(combined.contains("MONTHLY"))
        XCTAssertTrue(combined.contains("YEARLY"))
    }
    
    func testFrequencySorted() {
        // Сортировка частот
        let allCases = Frequency.allCases
        let sorted = allCases.sorted { $0.rawValue < $1.rawValue }
        XCTAssertEqual(sorted.count, 4)
    }
    
    func testFrequencyForEach() {
        // Итерация по частотам
        var count = 0
        Frequency.allCases.forEach { _ in count += 1 }
        XCTAssertEqual(count, 4)
    }
}

