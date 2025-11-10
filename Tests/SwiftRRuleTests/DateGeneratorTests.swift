//
//  DateGeneratorTests.swift
//  SwiftRRuleTests
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import XCTest
@testable import SwiftRRule

final class DateGeneratorTests: XCTestCase {
    
    var calendar: Calendar!
    var startDate: Date!
    
    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        startDate = calendar.date(from: components)!
    }
    
    // MARK: - Basic Daily Tests
    
    func testDailyBasic() {
        let rrule = RRule(frequency: .daily, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate)
        
        XCTAssertEqual(dates.count, 5)
        XCTAssertEqual(dates[0], startDate)
    }
    
    func testDailyWithInterval() {
        let rrule = RRule(frequency: .daily, interval: 2, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate)
        
        XCTAssertEqual(dates.count, 5)
        
        // Проверяем, что даты идут с интервалом 2 дня
        for i in 1..<dates.count {
            let days = calendar.dateComponents([.day], from: dates[i-1], to: dates[i]).day ?? 0
            XCTAssertEqual(days, 2, "Date at index \(i) should be 2 days after previous")
        }
    }
    
    // MARK: - Weekly Tests
    
    func testWeeklyBasic() {
        let rrule = RRule(frequency: .weekly, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate)
        
        XCTAssertEqual(dates.count, 5)
    }
    
    func testWeeklyWithByDay() {
        // Понедельник, среда, пятница
        let rrule = RRule(frequency: .weekly, count: 9, byDay: [.monday, .wednesday, .friday])
        let dates = rrule.generateDates(startingFrom: startDate)
        
        XCTAssertEqual(dates.count, 9)
        
        // Проверяем, что все даты - понедельник, среда или пятница
        for date in dates {
            let weekday = calendar.component(.weekday, from: date)
            // 2 = Monday, 4 = Wednesday, 6 = Friday
            XCTAssertTrue([2, 4, 6].contains(weekday), "Date should be Monday, Wednesday, or Friday")
        }
    }
    
    // MARK: - Monthly Tests
    
    func testMonthlyBasic() {
        let rrule = RRule(frequency: .monthly, count: 12)
        let dates = rrule.generateDates(startingFrom: startDate)
        
        XCTAssertEqual(dates.count, 12)
    }
    
    func testMonthlyWithByMonthDay() {
        // Первое и 15-е число каждого месяца
        let rrule = RRule(frequency: .monthly, count: 6, byMonthDay: [1, 15])
        let dates = rrule.generateDates(startingFrom: startDate)
        
        XCTAssertEqual(dates.count, 6)
        
        // Проверяем, что все даты - 1-е или 15-е число
        for date in dates {
            let day = calendar.component(.day, from: date)
            XCTAssertTrue([1, 15].contains(day), "Date should be 1st or 15th of month")
        }
    }
    
    // MARK: - Yearly Tests
    
    func testYearlyBasic() {
        let rrule = RRule(frequency: .yearly, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate)
        
        XCTAssertEqual(dates.count, 5)
    }
    
    // MARK: - Count Tests
    
    func testWithCount() {
        let rrule = RRule(frequency: .daily, count: 10)
        let dates = rrule.generateDates(startingFrom: startDate)
        
        XCTAssertEqual(dates.count, 10)
    }
    
    // MARK: - Until Tests
    
    func testWithUntil() {
        let untilDate = calendar.date(byAdding: .day, value: 10, to: startDate)!
        let rrule = RRule(frequency: .daily, until: untilDate)
        let dates = rrule.generateDates(startingFrom: startDate)
        
        XCTAssertLessThanOrEqual(dates.count, 11) // Может быть меньше из-за фильтрации
        if let lastDate = dates.last {
            XCTAssertLessThanOrEqual(lastDate, untilDate)
        }
    }
    
    // MARK: - Complex Tests
    
    func testComplexRule() {
        // Каждую неделю в понедельник, среду и пятницу, 10 раз
        let rrule = RRule(
            frequency: .weekly,
            count: 10,
            byDay: [.monday, .wednesday, .friday]
        )
        let dates = rrule.generateDates(startingFrom: startDate)
        
        XCTAssertEqual(dates.count, 10)
    }
}

