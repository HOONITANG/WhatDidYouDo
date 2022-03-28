//
//  CalendarHelper.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import Foundation

class CalendarHelper
{
    typealias dayBoundary = (startOfDay: Date?, endOfDay: Date?)
    
    let calendar = Calendar.current
    /// GMT 기준, 24시를 반환해주는 함수
    // ex) input: 2022-01-17 12:34:26 +0000
    //     result : 2022-01-17 15:00:00 +0000
    func getStandardDate(_ date: Date = Date()) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let convertDate = dateFormatter.string(from: date)
        let result = dateFormatter.date(from: convertDate) ?? Date()
        return result
    }
    
    /// date 기준으로  하루시작 시간과 끝나는 시간을 반환함
    func dayBoundary(from date: Date) -> dayBoundary
    {
        
        let startOfDay = Calendar.current.startOfDay(for: getStandardDate(date))
        let endOfDay: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: startOfDay)!
        }()
        
        return (startOfDay, endOfDay)
    }
    
    /// date 기준으로 하루 더해서 반환하는 메서드
    func plusDay(from date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let convertDate = dateFormatter.string(from: date)
        let to = dateFormatter.date(from: convertDate) ?? Date()
    
        return calendar.date(byAdding: .day, value: 1, to: to)!
    }
    
    /// date 기준으로 하루 빼서 반환하는 메서드
    func minusDay(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let convertDate = dateFormatter.string(from: date)
        let to = dateFormatter.date(from: convertDate) ?? Date()
        
        return calendar.date(byAdding: .day, value: -1, to: to)!
    }
    
    func plusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func monthString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int
    {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(date: Date) -> Int
    {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(date: Date) -> Date
    {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int
    {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
}
