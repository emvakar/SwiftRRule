//
//  RRuleParser.swift
//  SwiftRRule
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import Foundation

/// Ошибки парсинга RRule
public enum RRuleParseError: Error, Equatable {
    /// Пустая строка
    case emptyString
    
    /// Отсутствует обязательный параметр FREQ
    case missingFrequency
    
    /// Неверный формат частоты
    case invalidFrequency(String)
    
    /// Неверный формат значения
    case invalidValue(String, for: String)
    
    /// Неверный формат даты UNTIL
    case invalidUntilDate(String)
    
    /// Неверный формат дня недели
    case invalidWeekday(String)
    
    /// Неверный формат строки
    case invalidFormat(String)
}

/// Парсер строк RRule согласно RFC 5545
public struct RRuleParser {
    
    /// Парсинг строки RRule
    /// - Parameter string: Строка в формате RRule (например, "FREQ=DAILY;INTERVAL=2;COUNT=10")
    /// - Returns: Объект RRule
    /// - Throws: RRuleParseError при ошибке парсинга
    public static func parse(_ string: String) throws -> RRule {
        guard !string.isEmpty else {
            throw RRuleParseError.emptyString
        }
        
        // Разбиваем строку на пары ключ=значение
        let components = string.components(separatedBy: ";")
        var parameters: [String: String] = [:]
        
        for component in components {
            let trimmed = component.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { continue }
            
            let parts = trimmed.split(separator: "=", maxSplits: 1)
            guard parts.count == 2 else {
                throw RRuleParseError.invalidFormat(trimmed)
            }
            
            let key = String(parts[0]).uppercased()
            let value = String(parts[1])
            parameters[key] = value
        }
        
        // FREQ обязателен
        guard let freqString = parameters["FREQ"] else {
            throw RRuleParseError.missingFrequency
        }
        
        guard let frequency = Frequency(rawValue: freqString) else {
            throw RRuleParseError.invalidFrequency(freqString)
        }
        
        // Парсим остальные параметры
        let interval = try parseInterval(parameters["INTERVAL"])
        let count = try parseCount(parameters["COUNT"])
        let until = try parseUntil(parameters["UNTIL"])
        let bySecond = try parseIntList(parameters["BYSECOND"], name: "BYSECOND")
        let byMinute = try parseIntList(parameters["BYMINUTE"], name: "BYMINUTE")
        let byHour = try parseIntList(parameters["BYHOUR"], name: "BYHOUR")
        let byDay = try parseByDay(parameters["BYDAY"])
        let byMonthDay = try parseIntList(parameters["BYMONTHDAY"], name: "BYMONTHDAY")
        let byYearDay = try parseIntList(parameters["BYYEARDAY"], name: "BYYEARDAY")
        let byWeekNo = try parseIntList(parameters["BYWEEKNO"], name: "BYWEEKNO")
        let byMonth = try parseIntList(parameters["BYMONTH"], name: "BYMONTH")
        let bySetPos = try parseIntList(parameters["BYSETPOS"], name: "BYSETPOS")
        let wkst = try parseWkst(parameters["WKST"])
        
        return RRule(
            frequency: frequency,
            interval: interval,
            count: count,
            until: until,
            bySecond: bySecond,
            byMinute: byMinute,
            byHour: byHour,
            byDay: byDay,
            byMonthDay: byMonthDay,
            byYearDay: byYearDay,
            byWeekNo: byWeekNo,
            byMonth: byMonth,
            bySetPos: bySetPos,
            wkst: wkst
        )
    }
    
    // MARK: - Private Parsing Methods
    
    private static func parseInterval(_ value: String?) throws -> Int? {
        guard let value = value else { return nil }
        guard let intValue = Int(value), intValue > 0 else {
            throw RRuleParseError.invalidValue(value, for: "INTERVAL")
        }
        return intValue
    }
    
    private static func parseCount(_ value: String?) throws -> Int? {
        guard let value = value else { return nil }
        guard let intValue = Int(value), intValue > 0 else {
            throw RRuleParseError.invalidValue(value, for: "COUNT")
        }
        return intValue
    }
    
    private static func parseUntil(_ value: String?) throws -> Date? {
        guard let value = value else { return nil }
        
        // Формат UNTIL может быть в формате YYYYMMDDTHHMMSSZ или YYYYMMDD
        // Сначала пробуем ISO8601 форматтеры
        let isoFormatters: [ISO8601DateFormatter] = [
            {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                return formatter
            }(),
            {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                return formatter
            }()
        ]
        
        for formatter in isoFormatters {
            if let date = formatter.date(from: value) {
                return date
            }
        }
        
        // Затем пробуем DateFormatter с различными форматами
        let dateFormatters: [DateFormatter] = [
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                return formatter
            }(),
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd'T'HHmmss"
                formatter.timeZone = TimeZone.current
                return formatter
            }(),
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                formatter.timeZone = TimeZone.current
                return formatter
            }()
        ]
        
        for formatter in dateFormatters {
            if let date = formatter.date(from: value) {
                return date
            }
        }
        
        throw RRuleParseError.invalidUntilDate(value)
    }
    
    private static func parseIntList(_ value: String?, name: String) throws -> [Int]? {
        guard let value = value else { return nil }
        let components = value.components(separatedBy: ",")
        var result: [Int] = []
        
        for component in components {
            let trimmed = component.trimmingCharacters(in: .whitespaces)
            guard let intValue = Int(trimmed) else {
                throw RRuleParseError.invalidValue(trimmed, for: name)
            }
            result.append(intValue)
        }
        
        return result.isEmpty ? nil : result
    }
    
    private static func parseByDay(_ value: String?) throws -> [Weekday]? {
        guard let value = value else { return nil }
        let components = value.components(separatedBy: ",")
        var result: [Weekday] = []
        
        for component in components {
            let trimmed = component.trimmingCharacters(in: .whitespaces)
            guard let weekday = Weekday(from: trimmed) else {
                throw RRuleParseError.invalidWeekday(trimmed)
            }
            result.append(weekday)
        }
        
        return result.isEmpty ? nil : result
    }
    
    private static func parseWkst(_ value: String?) throws -> Weekday? {
        guard let value = value else { return nil }
        guard let weekday = Weekday(from: value) else {
            throw RRuleParseError.invalidWeekday(value)
        }
        return weekday
    }
}

