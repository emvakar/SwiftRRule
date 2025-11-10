//
//  RRule.swift
//  SwiftRRule
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import Foundation

/// Правило повторения события согласно RFC 5545
public struct RRule: Codable, Equatable {
    /// Частота повторения (обязательное поле)
    public let frequency: Frequency
    
    /// Интервал между повторениями (по умолчанию 1)
    public let interval: Int?
    
    /// Количество повторений
    public let count: Int?
    
    /// Дата окончания повторений
    public let until: Date?
    
    /// Секунды (0-59)
    public let bySecond: [Int]?
    
    /// Минуты (0-59)
    public let byMinute: [Int]?
    
    /// Часы (0-23)
    public let byHour: [Int]?
    
    /// Дни недели
    public let byDay: [Weekday]?
    
    /// Дни месяца (-31 до 31, исключая 0)
    public let byMonthDay: [Int]?
    
    /// Дни года (-366 до 366, исключая 0)
    public let byYearDay: [Int]?
    
    /// Недели года (-53 до 53, исключая 0)
    public let byWeekNo: [Int]?
    
    /// Месяцы (1-12)
    public let byMonth: [Int]?
    
    /// Позиции в наборе (-366 до 366, исключая 0)
    public let bySetPos: [Int]?
    
    /// День начала недели (по умолчанию MO - понедельник)
    public let wkst: Weekday?
    
    // MARK: - Parsing
    
    /// Парсинг строки RRule
    /// - Parameter string: Строка в формате RRule (например, "FREQ=DAILY;INTERVAL=2;COUNT=10")
    /// - Returns: Объект RRule
    /// - Throws: RRuleParseError при ошибке парсинга
    public static func parse(_ string: String) throws -> RRule {
        return try RRuleParser.parse(string)
    }
    
    // MARK: - Date Generation
    
    /// Генерация дат начиная с указанной даты
    /// - Parameter startDate: Начальная дата
    /// - Returns: Массив дат, соответствующих правилу повторения
    public func generateDates(startingFrom startDate: Date) -> [Date] {
        let generator = DateGenerator(rrule: self)
        return generator.generateDates(startingFrom: startDate)
    }
    
    /// Инициализация RRule
    public init(
        frequency: Frequency,
        interval: Int? = nil,
        count: Int? = nil,
        until: Date? = nil,
        bySecond: [Int]? = nil,
        byMinute: [Int]? = nil,
        byHour: [Int]? = nil,
        byDay: [Weekday]? = nil,
        byMonthDay: [Int]? = nil,
        byYearDay: [Int]? = nil,
        byWeekNo: [Int]? = nil,
        byMonth: [Int]? = nil,
        bySetPos: [Int]? = nil,
        wkst: Weekday? = nil
    ) {
        self.frequency = frequency
        self.interval = interval
        self.count = count
        self.until = until
        self.bySecond = bySecond
        self.byMinute = byMinute
        self.byHour = byHour
        self.byDay = byDay
        self.byMonthDay = byMonthDay
        self.byYearDay = byYearDay
        self.byWeekNo = byWeekNo
        self.byMonth = byMonth
        self.bySetPos = bySetPos
        self.wkst = wkst
    }
}

// MARK: - Codable Implementation

extension RRule {
    enum CodingKeys: String, CodingKey {
        case frequency = "FREQ"
        case interval = "INTERVAL"
        case count = "COUNT"
        case until = "UNTIL"
        case bySecond = "BYSECOND"
        case byMinute = "BYMINUTE"
        case byHour = "BYHOUR"
        case byDay = "BYDAY"
        case byMonthDay = "BYMONTHDAY"
        case byYearDay = "BYYEARDAY"
        case byWeekNo = "BYWEEKNO"
        case byMonth = "BYMONTH"
        case bySetPos = "BYSETPOS"
        case wkst = "WKST"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // FREQ обязателен
        let freqString = try container.decode(String.self, forKey: .frequency)
        guard let frequency = Frequency(rawValue: freqString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .frequency,
                in: container,
                debugDescription: "Invalid frequency: \(freqString)"
            )
        }
        self.frequency = frequency
        
        self.interval = try container.decodeIfPresent(Int.self, forKey: .interval)
        self.count = try container.decodeIfPresent(Int.self, forKey: .count)
        self.until = try container.decodeIfPresent(Date.self, forKey: .until)
        self.bySecond = try container.decodeIfPresent([Int].self, forKey: .bySecond)
        self.byMinute = try container.decodeIfPresent([Int].self, forKey: .byMinute)
        self.byHour = try container.decodeIfPresent([Int].self, forKey: .byHour)
        self.byMonthDay = try container.decodeIfPresent([Int].self, forKey: .byMonthDay)
        self.byYearDay = try container.decodeIfPresent([Int].self, forKey: .byYearDay)
        self.byWeekNo = try container.decodeIfPresent([Int].self, forKey: .byWeekNo)
        self.byMonth = try container.decodeIfPresent([Int].self, forKey: .byMonth)
        self.bySetPos = try container.decodeIfPresent([Int].self, forKey: .bySetPos)
        
        // Специальная обработка для BYDAY (массив строк или Weekday)
        if let byDayStrings = try? container.decodeIfPresent([String].self, forKey: .byDay) {
            self.byDay = try byDayStrings.map { string in
                guard let weekday = Weekday(from: string) else {
                    throw DecodingError.dataCorruptedError(
                        forKey: .byDay,
                        in: container,
                        debugDescription: "Invalid weekday: \(string)"
                    )
                }
                return weekday
            }
        } else {
            self.byDay = nil
        }
        
        // Специальная обработка для WKST
        if let wkstString = try? container.decodeIfPresent(String.self, forKey: .wkst) {
            guard let wkst = Weekday(from: wkstString) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .wkst,
                    in: container,
                    debugDescription: "Invalid wkst: \(wkstString)"
                )
            }
            self.wkst = wkst
        } else {
            self.wkst = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(frequency.rawValue, forKey: .frequency)
        try container.encodeIfPresent(interval, forKey: .interval)
        try container.encodeIfPresent(count, forKey: .count)
        try container.encodeIfPresent(until, forKey: .until)
        try container.encodeIfPresent(bySecond, forKey: .bySecond)
        try container.encodeIfPresent(byMinute, forKey: .byMinute)
        try container.encodeIfPresent(byHour, forKey: .byHour)
        try container.encodeIfPresent(byMonthDay, forKey: .byMonthDay)
        try container.encodeIfPresent(byYearDay, forKey: .byYearDay)
        try container.encodeIfPresent(byWeekNo, forKey: .byWeekNo)
        try container.encodeIfPresent(byMonth, forKey: .byMonth)
        try container.encodeIfPresent(bySetPos, forKey: .bySetPos)
        
        if let byDay = byDay {
            let byDayStrings = byDay.map { $0.toString() }
            try container.encode(byDayStrings, forKey: .byDay)
        }
        
        if let wkst = wkst {
            try container.encode(wkst.toString(), forKey: .wkst)
        }
    }
}

