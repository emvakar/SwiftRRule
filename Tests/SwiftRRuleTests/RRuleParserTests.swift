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
    
    // MARK: - Edge Cases and Error Detection
    
    func testParseEmptyStringEdgeCase() {
        XCTAssertThrowsError(try RRule.parse("")) { error in
            if case .emptyString = error as? RRuleParseError {
                // Expected
            } else {
                XCTFail("Expected emptyString error")
            }
        }
    }
    
    func testParseOnlyWhitespace() {
        // Парсер может обработать пробелы как валидную строку или выбросить ошибку
        // Проверяем, что парсер обрабатывает это корректно
        XCTAssertThrowsError(try RRule.parse("   ")) { error in
            // Может быть emptyString или missingFrequency
            XCTAssertTrue(error is RRuleParseError)
        }
    }
    
    func testParseMissingFrequencyEdgeCase() {
        XCTAssertThrowsError(try RRule.parse("INTERVAL=2;COUNT=10")) { error in
            if case .missingFrequency = error as? RRuleParseError {
                // Expected
            } else {
                XCTFail("Expected missingFrequency error")
            }
        }
    }
    
    func testParseInvalidFrequencyEdgeCase() {
        XCTAssertThrowsError(try RRule.parse("FREQ=INVALID")) { error in
            if case .invalidFrequency(let freq) = error as? RRuleParseError {
                XCTAssertEqual(freq, "INVALID")
            } else {
                XCTFail("Expected invalidFrequency error")
            }
        }
    }
    
    func testParseInvalidIntervalString() {
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;INTERVAL=abc")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "abc")
                XCTAssertEqual(key, "INTERVAL")
            } else {
                XCTFail("Expected invalidValue error for INTERVAL")
            }
        }
    }
    
    func testParseInvalidCountString() {
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;COUNT=abc")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "abc")
                XCTAssertEqual(key, "COUNT")
            } else {
                XCTFail("Expected invalidValue error for COUNT")
            }
        }
    }
    
    func testParseNegativeInterval() {
        // Отрицательный INTERVAL недопустим - парсер должен выбросить ошибку
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;INTERVAL=-1")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "-1")
                XCTAssertEqual(key, "INTERVAL")
            } else {
                XCTFail("Expected invalidValue error for INTERVAL")
            }
        }
    }
    
    func testParseZeroInterval() {
        // INTERVAL=0 недопустим - парсер должен выбросить ошибку
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;INTERVAL=0")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "0")
                XCTAssertEqual(key, "INTERVAL")
            } else {
                XCTFail("Expected invalidValue error for INTERVAL")
            }
        }
    }
    
    func testParseZeroCount() {
        // COUNT=0 недопустим - парсер должен выбросить ошибку
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;COUNT=0")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "0")
                XCTAssertEqual(key, "COUNT")
            } else {
                XCTFail("Expected invalidValue error for COUNT")
            }
        }
    }
    
    func testParseNegativeCount() {
        // Отрицательный COUNT недопустим - парсер должен выбросить ошибку
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;COUNT=-1")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "-1")
                XCTAssertEqual(key, "COUNT")
            } else {
                XCTFail("Expected invalidValue error for COUNT")
            }
        }
    }
    
    func testParseInvalidBySecond() {
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;BYSECOND=abc")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "abc")
                XCTAssertEqual(key, "BYSECOND")
            } else {
                XCTFail("Expected invalidValue error for BYSECOND")
            }
        }
    }
    
    func testParseInvalidByMinute() {
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;BYMINUTE=abc")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "abc")
                XCTAssertEqual(key, "BYMINUTE")
            } else {
                XCTFail("Expected invalidValue error for BYMINUTE")
            }
        }
    }
    
    func testParseInvalidByHour() {
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;BYHOUR=abc")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "abc")
                XCTAssertEqual(key, "BYHOUR")
            } else {
                XCTFail("Expected invalidValue error for BYHOUR")
            }
        }
    }
    
    func testParseInvalidByMonthDay() {
        XCTAssertThrowsError(try RRule.parse("FREQ=MONTHLY;BYMONTHDAY=abc")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "abc")
                XCTAssertEqual(key, "BYMONTHDAY")
            } else {
                XCTFail("Expected invalidValue error for BYMONTHDAY")
            }
        }
    }
    
    func testParseInvalidByYearDay() {
        XCTAssertThrowsError(try RRule.parse("FREQ=YEARLY;BYYEARDAY=abc")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "abc")
                XCTAssertEqual(key, "BYYEARDAY")
            } else {
                XCTFail("Expected invalidValue error for BYYEARDAY")
            }
        }
    }
    
    func testParseInvalidByWeekNo() {
        XCTAssertThrowsError(try RRule.parse("FREQ=YEARLY;BYWEEKNO=abc")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "abc")
                XCTAssertEqual(key, "BYWEEKNO")
            } else {
                XCTFail("Expected invalidValue error for BYWEEKNO")
            }
        }
    }
    
    func testParseInvalidByMonth() {
        XCTAssertThrowsError(try RRule.parse("FREQ=YEARLY;BYMONTH=abc")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "abc")
                XCTAssertEqual(key, "BYMONTH")
            } else {
                XCTFail("Expected invalidValue error for BYMONTH")
            }
        }
    }
    
    func testParseInvalidBySetPos() {
        XCTAssertThrowsError(try RRule.parse("FREQ=MONTHLY;BYSETPOS=abc")) { error in
            if case .invalidValue(let value, let key) = error as? RRuleParseError {
                XCTAssertEqual(value, "abc")
                XCTAssertEqual(key, "BYSETPOS")
            } else {
                XCTFail("Expected invalidValue error for BYSETPOS")
            }
        }
    }
    
    func testParseInvalidUntilFormat() {
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;UNTIL=INVALID")) { error in
            // Парсер должен обработать неверный формат UNTIL
            XCTAssertNotNil(error)
        }
    }
    
    func testParseDuplicateKeys() throws {
        // Дублирующиеся ключи - последний должен перезаписать предыдущий
        let rrule = try RRule.parse("FREQ=DAILY;COUNT=5;COUNT=10")
        XCTAssertEqual(rrule.count, 10)
    }
    
    func testParseLargeValues() throws {
        // Большие значения для COUNT и INTERVAL
        let rrule = try RRule.parse("FREQ=DAILY;INTERVAL=999999;COUNT=999999")
        XCTAssertEqual(rrule.interval, 999999)
        XCTAssertEqual(rrule.count, 999999)
    }
    
    func testParseMultipleBySecond() throws {
        let rrule = try RRule.parse("FREQ=DAILY;BYSECOND=0,15,30,45,60")
        XCTAssertEqual(rrule.bySecond, [0, 15, 30, 45, 60])
    }
    
    func testParseMultipleByMinute() throws {
        let rrule = try RRule.parse("FREQ=DAILY;BYMINUTE=0,15,30,45")
        XCTAssertEqual(rrule.byMinute, [0, 15, 30, 45])
    }
    
    func testParseMultipleByHour() throws {
        let rrule = try RRule.parse("FREQ=DAILY;BYHOUR=0,6,12,18,23")
        XCTAssertEqual(rrule.byHour, [0, 6, 12, 18, 23])
    }
    
    func testParseMultipleByMonthDay() throws {
        let rrule = try RRule.parse("FREQ=MONTHLY;BYMONTHDAY=1,15,28,-1")
        XCTAssertEqual(rrule.byMonthDay, [1, 15, 28, -1])
    }
    
    func testParseMultipleByYearDay() throws {
        let rrule = try RRule.parse("FREQ=YEARLY;BYYEARDAY=1,100,200,365,-1")
        XCTAssertEqual(rrule.byYearDay, [1, 100, 200, 365, -1])
    }
    
    func testParseMultipleByWeekNo() throws {
        let rrule = try RRule.parse("FREQ=YEARLY;BYWEEKNO=1,26,52,-1")
        XCTAssertEqual(rrule.byWeekNo, [1, 26, 52, -1])
    }
    
    func testParseMultipleByMonth() throws {
        let rrule = try RRule.parse("FREQ=YEARLY;BYMONTH=1,3,6,9,12")
        XCTAssertEqual(rrule.byMonth, [1, 3, 6, 9, 12])
    }
    
    func testParseMultipleBySetPos() throws {
        let rrule = try RRule.parse("FREQ=MONTHLY;BYSETPOS=1,2,-1,-2")
        XCTAssertEqual(rrule.bySetPos, [1, 2, -1, -2])
    }
    
    func testParseMultipleByDay() throws {
        let rrule = try RRule.parse("FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU")
        XCTAssertNotNil(rrule.byDay)
        XCTAssertEqual(rrule.byDay?.count, 7)
    }
    
    func testParseByDayWithPositions() throws {
        let rrule = try RRule.parse("FREQ=MONTHLY;BYDAY=1MO,2TU,-1FR")
        XCTAssertNotNil(rrule.byDay)
        XCTAssertEqual(rrule.byDay?.count, 3)
    }
    
    func testParseUntilWithZ() throws {
        // UNTIL с Z (UTC)
        let rrule = try RRule.parse("FREQ=DAILY;UNTIL=20241231T120000Z")
        XCTAssertNotNil(rrule.until)
    }
    
    func testParseUntilWithoutZ() throws {
        // UNTIL без Z (локальное время)
        let rrule = try RRule.parse("FREQ=DAILY;UNTIL=20241231T120000")
        XCTAssertNotNil(rrule.until)
    }
    
    func testParseUntilDateOnly() throws {
        // UNTIL только дата
        let rrule = try RRule.parse("FREQ=DAILY;UNTIL=20241231")
        XCTAssertNotNil(rrule.until)
    }
    
    func testParseComplexRuleWithAllParams() throws {
        // Сложное правило со всеми параметрами
        let rrule = try RRule.parse("FREQ=WEEKLY;INTERVAL=2;COUNT=10;BYDAY=MO,WE,FR;BYHOUR=9,17;BYMINUTE=0,30;BYSECOND=0")
        XCTAssertEqual(rrule.frequency, .weekly)
        XCTAssertEqual(rrule.interval, 2)
        XCTAssertEqual(rrule.count, 10)
        XCTAssertNotNil(rrule.byDay)
        XCTAssertNotNil(rrule.byHour)
        XCTAssertNotNil(rrule.byMinute)
        XCTAssertNotNil(rrule.bySecond)
    }
    
    func testParseWithTrailingSemicolon() throws {
        // Правило с завершающей точкой с запятой
        let rrule = try RRule.parse("FREQ=DAILY;COUNT=10;")
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.count, 10)
    }
    
    func testParseWithLeadingSemicolon() throws {
        // Правило с начальной точкой с запятой
        let rrule = try RRule.parse(";FREQ=DAILY;COUNT=10")
        XCTAssertEqual(rrule.frequency, .daily)
        XCTAssertEqual(rrule.count, 10)
    }
    
    func testParseWithEmptyValues() {
        // Пустые значения должны обрабатываться как ошибка
        XCTAssertThrowsError(try RRule.parse("FREQ=DAILY;BYDAY=")) { error in
            // Может быть invalidFormat или другая ошибка
            XCTAssertTrue(error is RRuleParseError)
        }
    }
}

