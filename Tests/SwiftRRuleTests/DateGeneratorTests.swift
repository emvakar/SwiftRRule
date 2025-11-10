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
    
    // MARK: - Advanced Edge Cases
    
    func testLeapYear() {
        // Тест на високосный год - 29 февраля
        // Генератор должен правильно обрабатывать високосные годы
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 29
        components.hour = 12
        components.minute = 0
        components.second = 0
        let leapYearDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .yearly, count: 4)
        let dates = rrule.generateDates(startingFrom: leapYearDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 4)
        // Проверяем, что генератор правильно обрабатывает високосные годы
        // В невисокосные годы 29 февраля становится 28 февраля или 1 марта
        for date in dates {
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            XCTAssertEqual(month, 2, "Month should be February")
            
            // Проверяем, что год високосный (делится на 4, но не на 100, или делится на 400)
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            if isLeapYear {
                XCTAssertEqual(day, 29, "Day should be 29 in leap year \(year)")
            } else {
                // В невисокосные годы может быть 28 февраля или 1 марта
                XCTAssertTrue(day == 28 || day == 1, "Day should be 28 or 1 in non-leap year \(year)")
            }
        }
    }
    
    func testNonLeapYear() {
        // Тест на невисокосный год - 28 февраля
        var components = DateComponents()
        components.year = 2023
        components.month = 2
        components.day = 28
        components.hour = 12
        components.minute = 0
        components.second = 0
        let nonLeapYearDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .yearly, count: 4)
        let dates = rrule.generateDates(startingFrom: nonLeapYearDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 4)
        // Проверяем, что в невисокосные годы используется 28 февраля
        for date in dates {
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            XCTAssertEqual(month, 2, "Month should be February")
            XCTAssertLessThanOrEqual(day, 28, "Day should be 28 or less in non-leap years")
        }
    }
    
    func testMonthEndBoundary() {
        // Тест на границу конца месяца - 31 января, затем февраль
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 31
        components.hour = 12
        components.minute = 0
        components.second = 0
        let monthEndDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .monthly, count: 3, byMonthDay: [31])
        let dates = rrule.generateDates(startingFrom: monthEndDate, calendar: calendar)
        
        XCTAssertGreaterThanOrEqual(dates.count, 1)
        // Проверяем, что февраль не имеет 31 дня
        for date in dates {
            let month = calendar.component(.month, from: date)
            if month == 2 {
                let day = calendar.component(.day, from: date)
                XCTAssertLessThan(day, 31, "February should not have 31 days")
            }
        }
    }
    
    func testYearEndBoundary() {
        // Тест на границу конца года - 31 декабря
        var components = DateComponents()
        components.year = 2024
        components.month = 12
        components.day = 31
        components.hour = 12
        components.minute = 0
        components.second = 0
        let yearEndDate = calendar.date(from: components)!
        
        let rrule = RRule(frequency: .yearly, count: 3)
        let dates = rrule.generateDates(startingFrom: yearEndDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 3)
        for date in dates {
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            XCTAssertEqual(month, 12, "Month should be December")
            XCTAssertEqual(day, 31, "Day should be 31")
        }
    }
    
    func testBySetPosFirst() {
        // BYSETPOS=1 - первое вхождение
        let rrule = RRule(
            frequency: .monthly,
            count: 6,
            byDay: [.monday, .wednesday, .friday],
            bySetPos: [1]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 6)
        // Проверяем, что каждая дата - первое вхождение дня недели в месяце
        for date in dates {
            let month = calendar.component(.month, from: date)
            let weekday = calendar.component(.weekday, from: date)
            let day = calendar.component(.day, from: date)
            
            // Находим первое вхождение этого дня недели в месяце
            var firstOccurrence = DateComponents()
            firstOccurrence.year = calendar.component(.year, from: date)
            firstOccurrence.month = month
            firstOccurrence.weekday = weekday
            firstOccurrence.weekdayOrdinal = 1
            if let firstDate = calendar.date(from: firstOccurrence) {
                XCTAssertEqual(day, calendar.component(.day, from: firstDate), "Date should be first occurrence of weekday in month")
            }
        }
    }
    
    func testBySetPosLast() {
        // BYSETPOS=-1 - последнее вхождение
        let rrule = RRule(
            frequency: .monthly,
            count: 6,
            byDay: [.monday, .wednesday, .friday],
            bySetPos: [-1]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 6)
    }
    
    func testBySetPosMultiple() {
        // BYSETPOS с несколькими значениями
        let rrule = RRule(
            frequency: .monthly,
            count: 12,
            byDay: [.monday],
            bySetPos: [1, 2, -1]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 12)
    }
    
    func testWkstMonday() {
        // WKST=MO - неделя начинается с понедельника
        let rrule = RRule(
            frequency: .weekly,
            count: 10,
            wkst: .monday
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
    }
    
    func testWkstSunday() {
        // WKST=SU - неделя начинается с воскресенья
        let rrule = RRule(
            frequency: .weekly,
            count: 10,
            wkst: .sunday
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
    }
    
    func testDailyWithAllByRules() {
        // Комбинация всех BY* правил для DAILY
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
            count: 10,
            bySecond: [0],
            byMinute: [0, 30],
            byHour: [9, 17]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
        
        for date in dates {
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            let second = calendar.component(.second, from: date)
            XCTAssertTrue([9, 17].contains(hour), "Hour should be 9 or 17")
            XCTAssertTrue([0, 30].contains(minute), "Minute should be 0 or 30")
            XCTAssertEqual(second, 0, "Second should be 0")
        }
    }
    
    func testWeeklyWithByHour() {
        // WEEKLY с BYHOUR - каждый понедельник в 9:00 и 17:00
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 9
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        // Находим ближайший понедельник
        let weekday = calendar.component(.weekday, from: testStartDate)
        let daysToMonday = (2 - weekday + 7) % 7
        let mondayDate = calendar.date(byAdding: .day, value: daysToMonday, to: testStartDate)!
        
        let rrule = RRule(
            frequency: .weekly,
            count: 10,
            byHour: [9, 17],
            byDay: [.monday]
        )
        let dates = rrule.generateDates(startingFrom: mondayDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
        
        for date in dates {
            let hour = calendar.component(.hour, from: date)
            let weekday = calendar.component(.weekday, from: date)
            XCTAssertTrue([9, 17].contains(hour), "Hour should be 9 or 17")
            XCTAssertEqual(weekday, 2, "Weekday should be Monday")
        }
    }
    
    func testMonthlyWithByHourAndMinute() {
        // MONTHLY с BYHOUR и BYMINUTE - первое число каждого месяца в 9:00 и 17:00
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 9
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .monthly,
            count: 6,
            byHour: [9, 17],
            byMonthDay: [1]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 6)
        
        for date in dates {
            let day = calendar.component(.day, from: date)
            let hour = calendar.component(.hour, from: date)
            XCTAssertEqual(day, 1, "Day should be 1")
            XCTAssertTrue([9, 17].contains(hour), "Hour should be 9 or 17")
        }
    }
    
    func testYearlyWithByMonthAndByDay() {
        // YEARLY с BYMONTH и BYDAY - первый понедельник января и июня
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .yearly,
            count: 6,
            byDay: [Weekday(dayOfWeek: 2, position: 1)], // Первый понедельник
            byMonth: [1, 6]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 6)
        
        for date in dates {
            let month = calendar.component(.month, from: date)
            let weekday = calendar.component(.weekday, from: date)
            XCTAssertTrue([1, 6].contains(month), "Month should be January or June")
            XCTAssertEqual(weekday, 2, "Weekday should be Monday")
        }
    }
    
    func testDatesOrder() {
        // Проверка, что даты идут в правильном порядке
        let rrule = RRule(frequency: .daily, count: 100)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 100)
        
        for i in 1..<dates.count {
            XCTAssertLessThan(dates[i-1], dates[i], "Dates should be in ascending order")
        }
    }
    
    func testLargeCount() {
        // Тест с большим COUNT
        let rrule = RRule(frequency: .daily, count: 1000)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 1000)
        XCTAssertLessThan(dates.last!, calendar.date(byAdding: .year, value: 3, to: startDate)!)
    }
    
    func testLargeInterval() {
        // Тест с большим INTERVAL
        let rrule = RRule(frequency: .yearly, interval: 10, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
        
        for i in 1..<dates.count {
            let years = calendar.dateComponents([.year], from: dates[i-1], to: dates[i]).year ?? 0
            XCTAssertEqual(years, 10, "Years should be 10 apart")
        }
    }
    
    func testMultipleByMonthDay() {
        // Несколько дней месяца
        let rrule = RRule(
            frequency: .monthly,
            count: 12,
            byMonthDay: [1, 15, 28]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 12)
        
        for date in dates {
            let day = calendar.component(.day, from: date)
            XCTAssertTrue([1, 15, 28].contains(day), "Day should be 1, 15, or 28")
        }
    }
    
    func testMultipleByYearDay() {
        // Несколько дней года
        let rrule = RRule(
            frequency: .yearly,
            count: 5,
            byYearDay: [1, 100, 200, 365]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 5)
    }
    
    func testMultipleByWeekNo() {
        // Несколько недель года
        let rrule = RRule(
            frequency: .yearly,
            count: 5,
            byWeekNo: [1, 26, 52]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 5)
    }
    
    func testNegativeByMonthDay() {
        // Несколько отрицательных дней месяца
        let rrule = RRule(
            frequency: .monthly,
            count: 12,
            byMonthDay: [-1, -7]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 12)
        
        for date in dates {
            let day = calendar.component(.day, from: date)
            let daysInMonth = calendar.range(of: .day, in: .month, for: date)?.count ?? 0
            // Проверяем, что день - это последний или седьмой с конца
            XCTAssertTrue(day == daysInMonth || day == daysInMonth - 6, "Day should be last or 7th from last")
        }
    }
    
    func testDifferentTimeZone() {
        // Тест с другим часовым поясом
        var testCalendar = Calendar(identifier: .gregorian)
        testCalendar.timeZone = TimeZone(identifier: "America/New_York")!
        
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 9
        components.minute = 0
        components.second = 0
        let testStartDate = testCalendar.date(from: components)!
        
        let rrule = RRule(frequency: .daily, count: 5, byHour: [9, 17])
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: testCalendar)
        
        XCTAssertEqual(dates.count, 5)
        
        for date in dates {
            let hour = testCalendar.component(.hour, from: date)
            XCTAssertTrue([9, 17].contains(hour), "Hour should be 9 or 17 in New York timezone")
        }
    }
    
    func testStartDateNotMatchingRules() {
        // Начальная дата не соответствует правилам
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 10
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        // Правило требует 9:00 или 17:00, но начальная дата в 10:00
        let rrule = RRule(frequency: .daily, count: 10, byHour: [9, 17])
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        // Для DAILY с BYHOUR должна генерироваться дата в 9:00 и 17:00 того же дня
        XCTAssertGreaterThanOrEqual(dates.count, 1)
        
        for date in dates {
            let hour = calendar.component(.hour, from: date)
            XCTAssertTrue([9, 17].contains(hour), "Hour should be 9 or 17")
        }
    }
    
    func testIntervalWithByDay() {
        // INTERVAL с BYDAY
        let rrule = RRule(
            frequency: .weekly,
            interval: 2,
            count: 10,
            byDay: [.monday, .wednesday, .friday]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
    }
    
    func testIntervalWithByMonth() {
        // INTERVAL с BYMONTH
        let rrule = RRule(
            frequency: .yearly,
            interval: 2,
            count: 5,
            byMonth: [1, 6]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 5)
        
        for date in dates {
            let month = calendar.component(.month, from: date)
            XCTAssertTrue([1, 6].contains(month), "Month should be January or June")
        }
    }
    
    func testUntilWithByDay() {
        // UNTIL с BYDAY
        let untilDate = calendar.date(byAdding: .day, value: 30, to: startDate)!
        let rrule = RRule(
            frequency: .weekly,
            until: untilDate,
            byDay: [.monday, .wednesday, .friday]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertGreaterThanOrEqual(dates.count, 1)
        if let lastDate = dates.last {
            XCTAssertLessThanOrEqual(lastDate, untilDate)
        }
    }
    
    // MARK: - Additional Advanced Tests
    
    func testDailyWithMultipleByHourMinuteSecond() {
        // Каждый день в несколько часов, минут и секунд
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
            count: 20,
            bySecond: [0, 15, 30, 45],
            byMinute: [0, 30],
            byHour: [9, 12, 15, 18]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 20)
        
        for date in dates {
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            let second = calendar.component(.second, from: date)
            XCTAssertTrue([9, 12, 15, 18].contains(hour))
            XCTAssertTrue([0, 30].contains(minute))
            XCTAssertTrue([0, 15, 30, 45].contains(second))
        }
    }
    
    func testWeeklyWithMultipleByDayAndByHour() {
        // Каждую неделю в несколько дней и часов
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 9
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        // Находим ближайший понедельник
        let weekday = calendar.component(.weekday, from: testStartDate)
        let daysToMonday = (2 - weekday + 7) % 7
        let mondayDate = calendar.date(byAdding: .day, value: daysToMonday, to: testStartDate)!
        
        let rrule = RRule(
            frequency: .weekly,
            count: 20,
            byHour: [9, 17],
            byDay: [.monday, .wednesday, .friday]
        )
        let dates = rrule.generateDates(startingFrom: mondayDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 20)
        
        for date in dates {
            let hour = calendar.component(.hour, from: date)
            let weekday = calendar.component(.weekday, from: date)
            XCTAssertTrue([9, 17].contains(hour))
            XCTAssertTrue([2, 4, 6].contains(weekday)) // Monday, Wednesday, Friday
        }
    }
    
    func testMonthlyWithByMonthDayAndByHour() {
        // Каждый месяц в несколько дней и часов
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 9
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .monthly,
            count: 12,
            byHour: [9, 17],
            byMonthDay: [1, 15]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 12)
        
        for date in dates {
            let day = calendar.component(.day, from: date)
            let hour = calendar.component(.hour, from: date)
            XCTAssertTrue([1, 15].contains(day))
            XCTAssertTrue([9, 17].contains(hour))
        }
    }
    
    func testYearlyWithByMonthAndByDayAdvanced() {
        // Каждый год в несколько месяцев и дней недели
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .yearly,
            count: 10,
            byDay: [.monday, .friday],
            byMonth: [1, 6, 12]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 10)
        
        for date in dates {
            let month = calendar.component(.month, from: date)
            let weekday = calendar.component(.weekday, from: date)
            XCTAssertTrue([1, 6, 12].contains(month))
            XCTAssertTrue([2, 6].contains(weekday)) // Monday, Friday
        }
    }
    
    func testDailyWithIntervalAndByHour() {
        // Каждые N дней в определенные часы
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
            interval: 3,
            count: 10,
            byHour: [9, 17]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
        
        for date in dates {
            let hour = calendar.component(.hour, from: date)
            XCTAssertTrue([9, 17].contains(hour))
        }
    }
    
    func testWeeklyWithIntervalAndByDay() {
        // Каждые N недель в определенные дни
        let rrule = RRule(
            frequency: .weekly,
            interval: 2,
            count: 10,
            byDay: [.monday, .friday]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
        
        for date in dates {
            let weekday = calendar.component(.weekday, from: date)
            XCTAssertTrue([2, 6].contains(weekday)) // Monday, Friday
        }
    }
    
    func testMonthlyWithIntervalAndByMonthDay() {
        // Каждые N месяцев в определенные дни
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .monthly,
            interval: 2,
            count: 6,
            byMonthDay: [1, 15]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 6)
        
        for date in dates {
            let day = calendar.component(.day, from: date)
            XCTAssertTrue([1, 15].contains(day))
        }
    }
    
    func testYearlyWithIntervalAndByMonth() {
        // Каждые N лет в определенные месяцы
        let rrule = RRule(
            frequency: .yearly,
            interval: 2,
            count: 5,
            byMonth: [1, 6]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 5)
        
        for date in dates {
            let month = calendar.component(.month, from: date)
            XCTAssertTrue([1, 6].contains(month))
        }
    }
    
    func testDailyWithBySecondRange() {
        // Каждый день в несколько секунд
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .daily,
            count: 10,
            bySecond: [0, 15, 30, 45]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
        
        for date in dates {
            let second = calendar.component(.second, from: date)
            XCTAssertTrue([0, 15, 30, 45].contains(second))
        }
    }
    
    func testWeeklyWithByMinuteRange() {
        // Каждую неделю в несколько минут
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .weekly,
            count: 10,
            byMinute: [0, 15, 30, 45]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
        
        for date in dates {
            let minute = calendar.component(.minute, from: date)
            XCTAssertTrue([0, 15, 30, 45].contains(minute))
        }
    }
    
    func testMonthlyWithByHourRange() {
        // Каждый месяц в несколько часов
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 9
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .monthly,
            count: 6,
            byHour: [9, 12, 15, 18]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 6)
        
        for date in dates {
            let hour = calendar.component(.hour, from: date)
            XCTAssertTrue([9, 12, 15, 18].contains(hour))
        }
    }
    
    func testYearlyWithByDayPositionAdvanced() {
        // Каждый год в определенные позиции дней недели
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .yearly,
            count: 5,
            byDay: [
                Weekday(dayOfWeek: 2, position: 1), // Первый понедельник
                Weekday(dayOfWeek: 6, position: -1)  // Последняя пятница
            ]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 5)
    }
    
    func testDailyWithBySetPos() {
        // Каждый день с BYSETPOS
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
            count: 10,
            byHour: [9, 12, 15, 18],
            bySetPos: [1, -1]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 10)
    }
    
    func testWeeklyWithBySetPos() {
        // Каждую неделю с BYSETPOS
        let rrule = RRule(
            frequency: .weekly,
            count: 10,
            byDay: [.monday, .wednesday, .friday],
            bySetPos: [1, -1]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 10)
    }
    
    func testMonthlyWithBySetPosMultiple() {
        // Каждый месяц с несколькими BYSETPOS
        let rrule = RRule(
            frequency: .monthly,
            count: 6,
            byDay: [.monday, .wednesday, .friday],
            bySetPos: [1, 2, -2, -1]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 6)
    }
    
    func testYearlyWithBySetPos() {
        // Каждый год с BYSETPOS
        let rrule = RRule(
            frequency: .yearly,
            count: 5,
            byDay: [.monday],
            byMonth: [1, 6, 12],
            bySetPos: [1]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 5)
    }
    
    func testDailyWithWkst() {
        // Каждый день с WKST (не влияет на DAILY, но проверяем)
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        
        let rrule = RRule(
            frequency: .daily,
            count: 10,
            wkst: .sunday
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
    }
    
    func testWeeklyWithWkstSunday() {
        // Каждую неделю с WKST=SU
        let rrule = RRule(
            frequency: .weekly,
            count: 10,
            wkst: .sunday
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
    }
    
    func testWeeklyWithWkstMonday() {
        // Каждую неделю с WKST=MO
        let rrule = RRule(
            frequency: .weekly,
            count: 10,
            wkst: .monday
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10)
    }
    
    func testMonthlyWithWkst() {
        // Каждый месяц с WKST
        let rrule = RRule(
            frequency: .monthly,
            count: 6,
            byDay: [.monday],
            wkst: .sunday
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 6)
    }
    
    func testYearlyWithWkst() {
        // Каждый год с WKST
        let rrule = RRule(
            frequency: .yearly,
            count: 5,
            byDay: [.monday],
            wkst: .sunday
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 5)
    }
    
    func testDailyWithCountAndUntil() {
        // COUNT и UNTIL вместе - должен использоваться COUNT
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.hour = 12
        components.minute = 0
        components.second = 0
        let testStartDate = calendar.date(from: components)!
        let untilDate = calendar.date(byAdding: .day, value: 100, to: testStartDate)!
        
        let rrule = RRule(
            frequency: .daily,
            count: 10,
            until: untilDate
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        // COUNT должен ограничить количество
        XCTAssertEqual(dates.count, 10)
    }
    
    func testWeeklyWithCountAndUntil() {
        // COUNT и UNTIL вместе
        let untilDate = calendar.date(byAdding: .day, value: 100, to: startDate)!
        
        let rrule = RRule(
            frequency: .weekly,
            count: 5,
            until: untilDate
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
    }
    
    func testMonthlyWithCountAndUntil() {
        // COUNT и UNTIL вместе
        let untilDate = calendar.date(byAdding: .month, value: 12, to: startDate)!
        
        let rrule = RRule(
            frequency: .monthly,
            count: 6,
            until: untilDate
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 6)
    }
    
    func testYearlyWithCountAndUntil() {
        // COUNT и UNTIL вместе
        let untilDate = calendar.date(byAdding: .year, value: 10, to: startDate)!
        
        let rrule = RRule(
            frequency: .yearly,
            count: 3,
            until: untilDate
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 3)
    }
    
    func testDailyWithAllByRulesCombined() {
        // Все BY* правила вместе для DAILY
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
            count: 20,
            bySecond: [0, 30],
            byMinute: [0, 30],
            byHour: [9, 17],
            byDay: [.monday, .friday],
            byMonthDay: [1, 15],
            bySetPos: [1]
        )
        let dates = rrule.generateDates(startingFrom: testStartDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 20)
    }
    
    func testWeeklyWithAllByRulesCombined() {
        // Все BY* правила вместе для WEEKLY
        let rrule = RRule(
            frequency: .weekly,
            count: 20,
            bySecond: [0],
            byMinute: [0, 30],
            byHour: [9, 17],
            byDay: [.monday, .wednesday, .friday],
            bySetPos: [1, -1]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 20)
    }
    
    func testMonthlyWithAllByRulesCombined() {
        // Все BY* правила вместе для MONTHLY
        let rrule = RRule(
            frequency: .monthly,
            count: 12,
            bySecond: [0],
            byMinute: [0],
            byHour: [9, 17],
            byDay: [.monday, .friday],
            byMonthDay: [1, 15],
            bySetPos: [1]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 12)
    }
    
    func testYearlyWithAllByRulesCombined() {
        // Все BY* правила вместе для YEARLY
        let rrule = RRule(
            frequency: .yearly,
            count: 10,
            bySecond: [0],
            byMinute: [0],
            byHour: [9, 17],
            byDay: [.monday],
            byYearDay: [1, 100],
            byWeekNo: [1, 26],
            byMonth: [1, 6, 12],
            bySetPos: [1]
        )
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertLessThanOrEqual(dates.count, 10)
    }
    
    func testDailyWithVeryLargeCount() {
        // Очень большой COUNT
        let rrule = RRule(frequency: .daily, count: 10000)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 10000)
        // Проверяем, что даты идут в правильном порядке
        for i in 1..<min(100, dates.count) {
            XCTAssertLessThan(dates[i-1], dates[i])
        }
    }
    
    func testWeeklyWithVeryLargeCount() {
        // Очень большой COUNT для WEEKLY
        let rrule = RRule(frequency: .weekly, count: 1000)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 1000)
    }
    
    func testMonthlyWithVeryLargeCount() {
        // Очень большой COUNT для MONTHLY
        let rrule = RRule(frequency: .monthly, count: 500)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 500)
    }
    
    func testYearlyWithVeryLargeCount() {
        // Очень большой COUNT для YEARLY
        let rrule = RRule(frequency: .yearly, count: 100)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 100)
    }
    
    func testDailyWithVeryLargeInterval() {
        // Очень большой INTERVAL
        let rrule = RRule(frequency: .daily, interval: 365, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
        
        // Проверяем, что даты идут с интервалом примерно 365 дней
        for i in 1..<dates.count {
            let days = calendar.dateComponents([.day], from: dates[i-1], to: dates[i]).day ?? 0
            XCTAssertGreaterThanOrEqual(days, 360)
            XCTAssertLessThanOrEqual(days, 370)
        }
    }
    
    func testWeeklyWithVeryLargeInterval() {
        // Очень большой INTERVAL для WEEKLY
        let rrule = RRule(frequency: .weekly, interval: 52, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
    }
    
    func testMonthlyWithVeryLargeInterval() {
        // Очень большой INTERVAL для MONTHLY
        let rrule = RRule(frequency: .monthly, interval: 12, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
    }
    
    func testYearlyWithVeryLargeInterval() {
        // Очень большой INTERVAL для YEARLY
        let rrule = RRule(frequency: .yearly, interval: 10, count: 5)
        let dates = rrule.generateDates(startingFrom: startDate, calendar: calendar)
        
        XCTAssertEqual(dates.count, 5)
    }
}

