//
//  Frequency.swift
//  SwiftRRule
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import Foundation

/// Частота повторения события согласно RFC 5545
public enum Frequency: String, Codable, CaseIterable {
    /// Ежедневно
    case daily = "DAILY"
    
    /// Еженедельно
    case weekly = "WEEKLY"
    
    /// Ежемесячно
    case monthly = "MONTHLY"
    
    /// Ежегодно
    case yearly = "YEARLY"
    
    /// Инициализация из строки (без учета регистра)
    public init?(rawValue: String) {
        let upper = rawValue.uppercased()
        switch upper {
        case "DAILY":
            self = .daily
        case "WEEKLY":
            self = .weekly
        case "MONTHLY":
            self = .monthly
        case "YEARLY":
            self = .yearly
        default:
            return nil
        }
    }
}

