//
//  RRuleGenerator.swift
//  SwiftRRule
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import Foundation

/// Генератор строк RRule согласно RFC 5545
public struct RRuleGenerator {
    
    private let rrule: RRule
    
    /// Инициализация генератора
    /// - Parameter rrule: Правило повторения
    public init(rrule: RRule) {
        self.rrule = rrule
    }
    
    /// Генерация строки RRule
    /// - Returns: Строка в формате RRule
    public func generate() -> String {
        var components: [String] = []
        
        // FREQ обязателен
        components.append("FREQ=\(rrule.frequency.rawValue)")
        
        // INTERVAL (опускаем если равен 1)
        if let interval = rrule.interval, interval != 1 {
            components.append("INTERVAL=\(interval)")
        }
        
        // COUNT
        if let count = rrule.count {
            components.append("COUNT=\(count)")
        }
        
        // UNTIL
        if let until = rrule.until {
            components.append("UNTIL=\(formatUntilDate(until))")
        }
        
        // BYSECOND
        if let bySecond = rrule.bySecond, !bySecond.isEmpty {
            let values = bySecond.map { String($0) }.joined(separator: ",")
            components.append("BYSECOND=\(values)")
        }
        
        // BYMINUTE
        if let byMinute = rrule.byMinute, !byMinute.isEmpty {
            let values = byMinute.map { String($0) }.joined(separator: ",")
            components.append("BYMINUTE=\(values)")
        }
        
        // BYHOUR
        if let byHour = rrule.byHour, !byHour.isEmpty {
            let values = byHour.map { String($0) }.joined(separator: ",")
            components.append("BYHOUR=\(values)")
        }
        
        // BYDAY
        if let byDay = rrule.byDay, !byDay.isEmpty {
            let values = byDay.map { $0.toString() }.joined(separator: ",")
            components.append("BYDAY=\(values)")
        }
        
        // BYMONTHDAY
        if let byMonthDay = rrule.byMonthDay, !byMonthDay.isEmpty {
            let values = byMonthDay.map { String($0) }.joined(separator: ",")
            components.append("BYMONTHDAY=\(values)")
        }
        
        // BYYEARDAY
        if let byYearDay = rrule.byYearDay, !byYearDay.isEmpty {
            let values = byYearDay.map { String($0) }.joined(separator: ",")
            components.append("BYYEARDAY=\(values)")
        }
        
        // BYWEEKNO
        if let byWeekNo = rrule.byWeekNo, !byWeekNo.isEmpty {
            let values = byWeekNo.map { String($0) }.joined(separator: ",")
            components.append("BYWEEKNO=\(values)")
        }
        
        // BYMONTH
        if let byMonth = rrule.byMonth, !byMonth.isEmpty {
            let values = byMonth.map { String($0) }.joined(separator: ",")
            components.append("BYMONTH=\(values)")
        }
        
        // BYSETPOS
        if let bySetPos = rrule.bySetPos, !bySetPos.isEmpty {
            let values = bySetPos.map { String($0) }.joined(separator: ",")
            components.append("BYSETPOS=\(values)")
        }
        
        // WKST (опускаем если равен MO - понедельник, значение по умолчанию)
        if let wkst = rrule.wkst, wkst.dayOfWeek != 2 {
            components.append("WKST=\(wkst.toString())")
        }
        
        return components.joined(separator: ";")
    }
    
    // MARK: - Private Methods
    
    /// Форматирование даты UNTIL в формат YYYYMMDDTHHMMSSZ
    private func formatUntilDate(_ date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .timeZone], from: date)
        
        // Если время не указано, используем полночь
        if components.hour == nil {
            components.hour = 0
            components.minute = 0
            components.second = 0
        }
        
        // Форматируем в YYYYMMDDTHHMMSSZ
        let year = String(format: "%04d", components.year ?? 0)
        let month = String(format: "%02d", components.month ?? 0)
        let day = String(format: "%02d", components.day ?? 0)
        let hour = String(format: "%02d", components.hour ?? 0)
        let minute = String(format: "%02d", components.minute ?? 0)
        let second = String(format: "%02d", components.second ?? 0)
        
        // Определяем, нужно ли добавлять Z (UTC)
        let timeZone = components.timeZone ?? TimeZone.current
        let isUTC = timeZone == TimeZone(secondsFromGMT: 0)
        let timeZoneSuffix = isUTC ? "Z" : ""
        
        return "\(year)\(month)\(day)T\(hour)\(minute)\(second)\(timeZoneSuffix)"
    }
}

