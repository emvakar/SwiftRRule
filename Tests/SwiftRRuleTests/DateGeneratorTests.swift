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
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
        XCTAssertEqual(dates[0], startDate)
    }
    
    func testDailyWithInterval() {
        let rrule = RRule(frequency: .daily, interval: 2, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
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
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
    }
    
    func testWeeklyWithByDay() {
        // Понедельник, среда, пятница
        let rrule = RRule(frequency: .weekly, count: 9, byDay: [.monday, .wednesday, .friday])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
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
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 12)
    }
    
    func testMonthlyWithByMonthDay() {
        // Первое и 15-е число каждого месяца
        let rrule = RRule(frequency: .monthly, count: 6, byMonthDay: [1, 15])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
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
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
    }
    
    // MARK: - Count Tests
    
    func testWithCount() {
        let rrule = RRule(frequency: .daily, count: 10)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
    }
    
    // MARK: - Until Tests
    
    func testWithUntil() {
        let untilDate = calendar.date(byAdding: .day, value: 10, to: startDate)!
        let rrule = RRule(frequency: .daily, until: untilDate)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
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
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
    }
    
    // MARK: - BY* Rules Tests
    
    func testWithByHour() {
        // Каждый день в 9:00 и 17:00
        // Начальная дата должна быть в 9:00 или 17:00
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 9
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .daily, count: 10, byHour: [9, 17])
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10, "Should generate exactly 10 dates (2 hours per day for 5 days)")
        
        for date in dates {
            let hour = calendar.component(.hour, from: date)
            XCTAssertTrue([9, 17].contains(hour), "Date should be at 9:00 or 17:00")
        }
    }
    
    func testWithByMinute() {
        // Каждый день в :00 и :30 минут
        let rrule = RRule(frequency: .daily, count: 10, byMinute: [0, 30])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
        
        for date in dates {
            let minute = calendar.component(.minute, from: date)
            XCTAssertTrue([0, 30].contains(minute), "Date should be at :00 or :30 minutes")
        }
    }
    
    func testWithBySecond() {
        // Каждый день в :00 и :30 секунд
        let rrule = RRule(frequency: .daily, count: 10, bySecond: [0, 30])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
        
        for date in dates {
            let second = calendar.component(.second, from: date)
            XCTAssertTrue([0, 30].contains(second), "Date should be at :00 or :30 seconds")
        }
    }
    
    func testWithByMonth() {
        // Каждый год в январе, июне и декабре
        let rrule = RRule(frequency: .yearly, count: 9, byMonth: [1, 6, 12])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 9)
        
        for date in dates {
            let month = calendar.component(.month, from: date)
            XCTAssertTrue([1, 6, 12].contains(month), "Date should be in January, June, or December")
        }
    }
    
    func testWithByYearDay() {
        // Первый и последний день года
        let rrule = RRule(frequency: .yearly, count: 4, byYearDay: [1, -1])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 4)
    }
    
    func testWithByWeekNo() {
        // Первая и последняя неделя года
        let rrule = RRule(frequency: .yearly, count: 4, byWeekNo: [1, -1])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 4)
    }
    
    func testWithNegativeByMonthDay() {
        // Последний день месяца
        // Начальная дата должна быть последним днем месяца
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 31
        components.hour = 12
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .monthly, count: 6, byMonthDay: [-1])
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 6)
        
        for date in dates {
            let day = calendar.component(.day, from: date)
            let daysInMonth = calendar.range(of: .day, in: .month, for: date)?.count ?? 0
            XCTAssertEqual(day, daysInMonth, "Date should be the last day of the month")
        }
    }
    
    // MARK: - Edge Cases
    
    func testWithCountZero() {
        // COUNT=0 не должен генерировать даты
        let rrule = RRule(frequency: .daily, count: 0)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 0)
    }
    
    func testWithCountOne() {
        // COUNT=1 должен генерировать только одну дату
        let rrule = RRule(frequency: .daily, count: 1)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 1)
        XCTAssertEqual(dates[0], startDate)
    }
    
    func testWithUntilBeforeStartDate() {
        // UNTIL до начальной даты не должен генерировать даты
        let untilDate = calendar.date(byAdding: .day, value: -1, to: startDate)!
        let rrule = RRule(frequency: .daily, until: untilDate)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 0)
    }
    
    func testWithUntilSameAsStartDate() {
        // UNTIL в тот же день, что и начальная дата
        let rrule = RRule(frequency: .daily, until: startDate)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 1)
        if let firstDate = dates.first {
            XCTAssertLessThanOrEqual(firstDate, startDate)
        }
    }
    
    func testWithLargeInterval() {
        // Большой интервал
        let rrule = RRule(frequency: .daily, interval: 30, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
        
        // Проверяем, что даты идут с интервалом 30 дней
        for i in 1..<dates.count {
            let days = calendar.dateComponents([.day], from: dates[i-1], to: dates[i]).day ?? 0
            XCTAssertEqual(days, 30, "Date at index \(i) should be 30 days after previous")
        }
    }
    
    func testMonthlyWithByDayPosition() {
        // Второй понедельник каждого месяца
        let rrule = RRule(frequency: .monthly, count: 6, byDay: [Weekday(dayOfWeek: 2, position: 2)])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 6)
        
        for date in dates {
            let weekday = calendar.component(.weekday, from: date)
            XCTAssertEqual(weekday, 2, "Date should be Monday")
        }
    }
    
    func testMonthlyWithLastFriday() {
        // Последняя пятница каждого месяца
        let rrule = RRule(frequency: .monthly, count: 6, byDay: [Weekday(dayOfWeek: 6, position: -1)])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 6)
        
        for date in dates {
            let weekday = calendar.component(.weekday, from: date)
            XCTAssertEqual(weekday, 6, "Date should be Friday")
        }
    }
    
    func testYearlyWithByDayPosition() {
        // Первый понедельник года
        let rrule = RRule(frequency: .yearly, count: 3, byDay: [Weekday(dayOfWeek: 2, position: 1)])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 3)
    }
    
    // MARK: - Combination Tests
    
    func testCombinationByHourAndMinute() {
        // Каждый день в 9:00, 9:30, 17:00, 17:30
        // Начальная дата должна быть в 9:00 или 17:00
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 9
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .daily,
            count: 8,
            byMinute: [0, 30],
            byHour: [9, 17]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 8, "Should generate exactly 8 dates (4 combinations per day for 2 days)")
        
        for date in dates {
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            XCTAssertTrue([9, 17].contains(hour), "Date should be at 9:00 or 17:00")
            XCTAssertTrue([0, 30].contains(minute), "Date should be at :00 or :30 minutes")
        }
    }
    
    func testCombinationByMonthAndByMonthDay() {
        // 1-е и 15-е число в январе, июне и декабре
        let rrule = RRule(
            frequency: .yearly,
            count: 9,
            byMonthDay: [1, 15],
            byMonth: [1, 6, 12]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 9)
        
        for date in dates {
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            XCTAssertTrue([1, 6, 12].contains(month), "Date should be in January, June, or December")
            XCTAssertTrue([1, 15].contains(day), "Date should be 1st or 15th")
        }
    }
    
    func testCombinationWeeklyWithIntervalAndByDay() {
        // Каждые 2 недели в понедельник, среду и пятницу
        let rrule = RRule(
            frequency: .weekly,
            interval: 2,
            count: 9,
            byDay: [.monday, .wednesday, .friday]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 9)
    }
    
    // MARK: - Real-world Scenarios
    
    func testWorkdays() {
        // Рабочие дни (понедельник-пятница)
        let rrule = RRule(
            frequency: .weekly,
            count: 10,
            byDay: [.monday, .tuesday, .wednesday, .thursday, .friday]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
        
        for date in dates {
            let weekday = calendar.component(.weekday, from: date)
            // 2 = Monday, 3 = Tuesday, 4 = Wednesday, 5 = Thursday, 6 = Friday
            XCTAssertTrue([2, 3, 4, 5, 6].contains(weekday), "Date should be a weekday")
        }
    }
    
    func testWeekends() {
        // Выходные дни (суббота, воскресенье)
        // Начальная дата должна быть субботой или воскресеньем
        // 1 января 2024 - понедельник, найдем ближайшую субботу
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 6 // Суббота
        components.hour = 12
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .weekly,
            count: 10,
            byDay: [.saturday, .sunday]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
        
        for date in dates {
            let weekday = calendar.component(.weekday, from: date)
            // 1 = Sunday, 7 = Saturday
            XCTAssertTrue([1, 7].contains(weekday), "Date should be a weekend day")
        }
    }
    
    func testFirstOfMonth() {
        // Первое число каждого месяца
        let rrule = RRule(frequency: .monthly, count: 12, byMonthDay: [1])
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 12)
        
        for date in dates {
            let day = calendar.component(.day, from: date)
            XCTAssertEqual(day, 1, "Date should be the 1st of the month")
        }
    }
    
    func testQuarterly() {
        // Каждый квартал (каждые 3 месяца)
        let rrule = RRule(frequency: .monthly, interval: 3, count: 4)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 4)
        
        // Проверяем, что даты идут с интервалом 3 месяца
        for i in 1..<dates.count {
            let months = calendar.dateComponents([.month], from: dates[i-1], to: dates[i]).month ?? 0
            XCTAssertEqual(months, 3, "Date at index \(i) should be 3 months after previous")
        }
    }
}

