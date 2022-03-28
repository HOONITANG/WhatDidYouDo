//
//  DailyScheduleService.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/15.
//

import Foundation
import RealmSwift

class DailyScheduleService {
    // sigleton pattern
    static let shared = DailyScheduleService()
    
    // Realm()으로 선언된 변수는 Document/밑에 있는 realmDB에 대한 포인터다.
    var realm = try! Realm()
    
    func fetchEvents(from date: Date) -> Results<Event>? {
        // startDate와 endDate가 오늘 날짜에 포함되는 이벤트
        // 하루뒤 날짜, Todo로 TagTodo를 검색함
        let boundary = CalendarHelper().dayBoundary(from: date)
        
        // event마지막이 오늘이거나
        // startDate가 오늘이거나 한 녀석을 뽑아야함
        let events = realm.objects(Event.self).filter("startDate BETWEEN %@ OR endDate BETWEEN %@", [boundary.startOfDay, boundary.endOfDay], [boundary.startOfDay, boundary.endOfDay]).sorted(byKeyPath: "startDate")
        
        return events
    }
}
