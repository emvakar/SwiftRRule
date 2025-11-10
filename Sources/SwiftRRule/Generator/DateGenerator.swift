//
//  DateGenerator.swift
//  SwiftRRule
//
//  Created by Emil Karimov on 10.11.2025.
//  Copyright © 2025 Emil Karimov. All rights reserved.
//

import Foundation

/// Генератор дат на основе правил повторения RRule
public struct DateGenerator {
    
    private let rrule: RRule
    private let calendar: Calendar
    
    /// Инициализация генератора
    /// - Parameters:
    ///   - rrule: Правило повторения
    ///   - calendar: Календарь для вычислений (по умолчанию текущий)
    public init(rrule: RRule, calendar: Calendar = .current) {
        self.rrule = rrule
        self.calendar = calendar
    }
    
    /// Генерация дат начиная с указанной даты
    /// - Parameter startDate: Начальная дата
    /// - Returns: Массив дат, соответствующих правилу повторения
    public func generateDates(startingFrom startDate: Date) -> [Date] {
        var dates: [Date] = []
        let interval = rrule.interval ?? 1
        let maxCount = rrule.count ?? Int.max
        
        // Если есть BYHOUR, BYMINUTE, BYSECOND для DAILY частоты, 
        // то начальная дата может не соответствовать правилам
        // В этом случае мы все равно начнем генерацию
        var currentDate = startDate
        
        // Если нет BYHOUR, BYMINUTE, BYSECOND для DAILY частоты, то проверяем соответствие начальной даты
        if !(rrule.frequency == .daily && (rrule.byHour != nil || rrule.byMinute != nil || rrule.bySecond != nil)) {
            guard isValidDate(startDate, for: rrule) else {
                return []
            }
        }
        var count = 0
        var iterations = 0
        let maxIterations = 10000 // Защита от бесконечного цикла
        
        // Генерируем даты в зависимости от частоты
        while count < maxCount && iterations < maxIterations {
            iterations += 1
            
            // Проверяем ограничение UNTIL
            if let until = rrule.until, currentDate > until {
                break
            }
            
            // Применяем BY* правила для фильтрации дат
            let validDates = applyByRules(to: currentDate, for: rrule)
            
            // Если нет валидных дат, переходим к следующему дню
            if validDates.isEmpty {
                // Переходим к следующей дате в зависимости от частоты
                guard let nextDate = nextDate(from: currentDate, frequency: rrule.frequency, interval: interval, rrule: rrule) else {
                    break
                }
                currentDate = nextDate
                continue
            }
            
            for date in validDates {
                if count >= maxCount {
                    break
                }
                
                if let until = rrule.until, date > until {
                    break
                }
                
                dates.append(date)
                count += 1
            }
            
            // Переходим к следующей дате в зависимости от частоты
            guard let nextDate = nextDate(from: currentDate, frequency: rrule.frequency, interval: interval, rrule: rrule) else {
                break
            }
            
            currentDate = nextDate
        }
        
        return dates
    }
    
    // MARK: - Private Methods
    
    /// Проверка, является ли дата валидной для правила
    private func isValidDate(_ date: Date, for rrule: RRule) -> Bool {
        // Применяем все BY* правила
        return applyByRules(to: date, for: rrule).contains(date)
    }
    
    /// Применение BY* правил к дате
    private func applyByRules(to date: Date, for rrule: RRule) -> [Date] {
        var dates = [date]
        
        // Для DAILY частоты BYHOUR, BYMINUTE, BYSECOND генерируют все комбинации для дня
        if rrule.frequency == .daily && (rrule.byHour != nil || rrule.byMinute != nil || rrule.bySecond != nil) {
            var result: [Date] = []
            var baseComponents = calendar.dateComponents([.year, .month, .day], from: date)
            
            // Получаем значения для генерации комбинаций
            let hours = rrule.byHour ?? [calendar.component(.hour, from: date)]
            let minutes = rrule.byMinute ?? [calendar.component(.minute, from: date)]
            let seconds = rrule.bySecond ?? [calendar.component(.second, from: date)]
            
            // Генерируем все комбинации часов, минут и секунд для этого дня
            // Сортируем даты по времени для правильного порядка
            for hour in hours.sorted() {
                for minute in minutes.sorted() {
                    for second in seconds.sorted() {
                        baseComponents.hour = hour
                        baseComponents.minute = minute
                        baseComponents.second = second
                        if let newDate = calendar.date(from: baseComponents) {
                            result.append(newDate)
                        }
                    }
                }
            }
            
            // Для DAILY частоты с BYHOUR/BYMINUTE/BYSECOND возвращаем результат сразу,
            // не применяя другие правила, которые могут изменить даты
            return result
        } else {
            // Для других частот используем фильтры
            // BYSECOND
            if let bySecond = rrule.bySecond {
                dates = filterBySecond(dates, bySecond: bySecond)
            }
            
            // BYMINUTE
            if let byMinute = rrule.byMinute {
                dates = filterByMinute(dates, byMinute: byMinute)
            }
            
            // BYHOUR
            if let byHour = rrule.byHour {
                dates = filterByHour(dates, byHour: byHour)
            }
        }
        
        // BYDAY
        if let byDay = rrule.byDay {
            dates = filterByDay(dates, byDay: byDay, frequency: rrule.frequency)
        }
        
        // BYMONTHDAY
        if let byMonthDay = rrule.byMonthDay {
            dates = filterByMonthDay(dates, byMonthDay: byMonthDay)
        }
        
        // BYYEARDAY
        if let byYearDay = rrule.byYearDay {
            dates = filterByYearDay(dates, byYearDay: byYearDay)
        }
        
        // BYWEEKNO
        if let byWeekNo = rrule.byWeekNo {
            dates = filterByWeekNo(dates, byWeekNo: byWeekNo)
        }
        
        // BYMONTH
        if let byMonth = rrule.byMonth {
            dates = filterByMonth(dates, byMonth: byMonth)
        }
        
        // BYSETPOS
        if let bySetPos = rrule.bySetPos {
            dates = filterBySetPos(dates, bySetPos: bySetPos)
        }
        
        return dates
    }
    
    /// Получение следующей даты в зависимости от частоты
    private func nextDate(from date: Date, frequency: Frequency, interval: Int, rrule: RRule) -> Date? {
        var components = DateComponents()
        
        switch frequency {
        case .daily:
            components.day = interval
        case .weekly:
            components.weekOfYear = interval
        case .monthly:
            components.month = interval
        case .yearly:
            components.year = interval
        }
        
        // Для DAILY частоты с BYHOUR/BYMINUTE/BYSECOND используем начало дня
        // чтобы избежать проблем с сохранением часов при переходе к следующему дню
        let baseDate: Date
        if rrule.frequency == .daily && (rrule.byHour != nil || rrule.byMinute != nil || rrule.bySecond != nil) {
            let dayComponents = calendar.dateComponents([.year, .month, .day], from: date)
            baseDate = calendar.date(from: dayComponents) ?? date
        } else {
            baseDate = date
        }
        
        return calendar.date(byAdding: components, to: baseDate)
    }
    
    // MARK: - BY* Filters
    
    private func filterBySecond(_ dates: [Date], bySecond: [Int]) -> [Date] {
        return dates.filter { date in
            let second = calendar.component(.second, from: date)
            return bySecond.contains(second)
        }
    }
    
    private func filterByMinute(_ dates: [Date], byMinute: [Int]) -> [Date] {
        return dates.filter { date in
            let minute = calendar.component(.minute, from: date)
            return byMinute.contains(minute)
        }
    }
    
    private func filterByHour(_ dates: [Date], byHour: [Int]) -> [Date] {
        return dates.filter { date in
            let hour = calendar.component(.hour, from: date)
            return byHour.contains(hour)
        }
    }
    
    private func filterByDay(_ dates: [Date], byDay: [Weekday], frequency: Frequency) -> [Date] {
        return dates.flatMap { date -> [Date] in
            var result: [Date] = []
            
            for weekday in byDay {
                if let matchingDate = findMatchingDate(date: date, weekday: weekday, frequency: frequency) {
                    result.append(matchingDate)
                }
            }
            
            return result
        }
    }
    
    private func findMatchingDate(date: Date, weekday: Weekday, frequency: Frequency) -> Date? {
        let dayOfWeek = calendar.component(.weekday, from: date)
        let targetDayOfWeek = weekday.dayOfWeek
        
        // Если указана позиция (например, 2MO, -1FR)
        if let position = weekday.position {
            return findDateByPosition(date: date, dayOfWeek: targetDayOfWeek, position: position, frequency: frequency)
        }
        
        // Если позиция не указана, просто проверяем день недели
        if dayOfWeek == targetDayOfWeek {
            return date
        }
        
        // Для DAILY частоты не ищем ближайший день недели, так как это может изменить дату
        // Для WEEKLY частоты ищем ближайший день недели
        if frequency == .weekly {
            // Ищем ближайший день недели в той же неделе
            let diff = targetDayOfWeek - dayOfWeek
            if let adjustedDate = calendar.date(byAdding: .day, value: diff, to: date) {
                return adjustedDate
            }
        }
        
        return nil
    }
    
    private func findDateByPosition(date: Date, dayOfWeek: Int, position: Int, frequency: Frequency) -> Date? {
        let calendar = self.calendar
        
        switch frequency {
        case .monthly:
            // Находим все вхождения дня недели в месяце
            guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
                  let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart) else {
                return nil
            }
            
            var occurrences: [Date] = []
            var currentDate = monthStart
            
            while currentDate <= monthEnd {
                let currentDayOfWeek = calendar.component(.weekday, from: currentDate)
                if currentDayOfWeek == dayOfWeek {
                    occurrences.append(currentDate)
                }
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            }
            
            if position > 0 && position <= occurrences.count {
                return occurrences[position - 1]
            } else if position < 0 {
                let absPosition = abs(position)
                if absPosition <= occurrences.count {
                    return occurrences[occurrences.count - absPosition]
                }
            }
            
        case .yearly:
            // Аналогично месяцу, но для года
            guard let yearStart = calendar.date(from: calendar.dateComponents([.year], from: date)),
                  let yearEnd = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: yearStart) else {
                return nil
            }
            
            var occurrences: [Date] = []
            var currentDate = yearStart
            
            while currentDate <= yearEnd {
                let currentDayOfWeek = calendar.component(.weekday, from: currentDate)
                if currentDayOfWeek == dayOfWeek {
                    occurrences.append(currentDate)
                }
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            }
            
            if position > 0 && position <= occurrences.count {
                return occurrences[position - 1]
            } else if position < 0 {
                let absPosition = abs(position)
                if absPosition <= occurrences.count {
                    return occurrences[occurrences.count - absPosition]
                }
            }
            
        default:
            // Для DAILY и WEEKLY позиция не имеет смысла
            return nil
        }
        
        return nil
    }
    
    private func filterByMonthDay(_ dates: [Date], byMonthDay: [Int]) -> [Date] {
        return dates.filter { date in
            let day = calendar.component(.day, from: date)
            let daysInMonth = calendar.range(of: .day, in: .month, for: date)?.count ?? 0
            
            return byMonthDay.contains { monthDay in
                if monthDay > 0 {
                    return monthDay == day
                } else {
                    // Отрицательные значения считаются с конца месяца
                    return (daysInMonth + monthDay + 1) == day
                }
            }
        }
    }
    
    private func filterByYearDay(_ dates: [Date], byYearDay: [Int]) -> [Date] {
        return dates.filter { date in
            let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 0
            let daysInYear = calendar.range(of: .day, in: .year, for: date)?.count ?? 365
            
            return byYearDay.contains { yearDay in
                if yearDay > 0 {
                    return yearDay == dayOfYear
                } else {
                    // Отрицательные значения считаются с конца года
                    return (daysInYear + yearDay + 1) == dayOfYear
                }
            }
        }
    }
    
    private func filterByWeekNo(_ dates: [Date], byWeekNo: [Int]) -> [Date] {
        return dates.filter { date in
            let weekOfYear = calendar.component(.weekOfYear, from: date)
            let weeksInYear = calendar.range(of: .weekOfYear, in: .year, for: date)?.count ?? 52
            
            return byWeekNo.contains { weekNo in
                if weekNo > 0 {
                    return weekNo == weekOfYear
                } else {
                    // Отрицательные значения считаются с конца года
                    return (weeksInYear + weekNo + 1) == weekOfYear
                }
            }
        }
    }
    
    private func filterByMonth(_ dates: [Date], byMonth: [Int]) -> [Date] {
        return dates.filter { date in
            let month = calendar.component(.month, from: date)
            return byMonth.contains(month)
        }
    }
    
    private func filterBySetPos(_ dates: [Date], bySetPos: [Int]) -> [Date] {
        // BYSETPOS применяется к уже отфильтрованному набору дат
        // Это требует более сложной логики, которая будет реализована позже
        // Пока возвращаем все даты
        return dates
    }
}

