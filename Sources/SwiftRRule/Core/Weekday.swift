//
//  Weekday.swift
//  SwiftRRule
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import Foundation

/// День недели с поддержкой позиции (например, 2MO = второй понедельник)
public struct Weekday: Codable, Equatable, Hashable {
    /// День недели (1 = воскресенье, 2 = понедельник, ..., 7 = суббота)
    public let dayOfWeek: Int
    
    /// Позиция в месяце/году (опционально)
    /// Например: 2 = второй, -1 = последний
    public let position: Int?
    
    /// Инициализация дня недели
    /// - Parameters:
    ///   - dayOfWeek: День недели (1 = воскресенье, 2 = понедельник, ..., 7 = суббота)
    ///   - position: Позиция в месяце/году (nil = любой, положительное = с начала, отрицательное = с конца)
    public init(dayOfWeek: Int, position: Int? = nil) {
        self.dayOfWeek = dayOfWeek
        self.position = position
    }
    
    /// Инициализация из строки (например, "MO", "2MO", "-1FR")
    public init?(from string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        
        // Проверяем наличие позиции
        if let firstChar = trimmed.first, firstChar.isNumber || firstChar == "-" {
            // Есть позиция
            var positionString = ""
            var dayString = ""
            
            for char in trimmed {
                if char.isNumber || char == "-" {
                    positionString.append(char)
                } else {
                    dayString = String(trimmed[trimmed.index(trimmed.startIndex, offsetBy: positionString.count)...])
                    break
                }
            }
            
            guard let position = Int(positionString) else {
                return nil
            }
            
            guard let dayOfWeek = Weekday.dayOfWeekFromString(dayString) else {
                return nil
            }
            
            self.dayOfWeek = dayOfWeek
            self.position = position == 0 ? nil : position
        } else {
            // Нет позиции
            guard let dayOfWeek = Weekday.dayOfWeekFromString(trimmed) else {
                return nil
            }
            
            self.dayOfWeek = dayOfWeek
            self.position = nil
        }
    }
    
    /// Преобразование в строку (например, "MO", "2MO", "-1FR")
    public func toString() -> String {
        let dayString = Weekday.stringFromDayOfWeek(dayOfWeek)
        
        if let position = position {
            return "\(position)\(dayString)"
        } else {
            return dayString
        }
    }
    
    // MARK: - Private Helpers
    
    private static func dayOfWeekFromString(_ string: String) -> Int? {
        let upper = string.uppercased()
        switch upper {
        case "SU", "SUNDAY":
            return 1
        case "MO", "MONDAY":
            return 2
        case "TU", "TUESDAY":
            return 3
        case "WE", "WEDNESDAY":
            return 4
        case "TH", "THURSDAY":
            return 5
        case "FR", "FRIDAY":
            return 6
        case "SA", "SATURDAY":
            return 7
        default:
            return nil
        }
    }
    
    private static func stringFromDayOfWeek(_ dayOfWeek: Int) -> String {
        switch dayOfWeek {
        case 1:
            return "SU"
        case 2:
            return "MO"
        case 3:
            return "TU"
        case 4:
            return "WE"
        case 5:
            return "TH"
        case 6:
            return "FR"
        case 7:
            return "SA"
        default:
            return ""
        }
    }
}

// MARK: - Convenience Initializers

public extension Weekday {
    /// Воскресенье
    static let sunday = Weekday(dayOfWeek: 1)
    
    /// Понедельник
    static let monday = Weekday(dayOfWeek: 2)
    
    /// Вторник
    static let tuesday = Weekday(dayOfWeek: 3)
    
    /// Среда
    static let wednesday = Weekday(dayOfWeek: 4)
    
    /// Четверг
    static let thursday = Weekday(dayOfWeek: 5)
    
    /// Пятница
    static let friday = Weekday(dayOfWeek: 6)
    
    /// Суббота
    static let saturday = Weekday(dayOfWeek: 7)
}

