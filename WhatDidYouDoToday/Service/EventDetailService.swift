//
//  EventDetailService.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/15.
//

import Foundation
import RealmSwift

class EventDetailService {
    // sigleton pattern
    static let shared = EventDetailService()
    
    // Realm()으로 선언된 변수는 Document/밑에 있는 realmDB에 대한 포인터다.
    var realm = try! Realm()
    
    func updateTodoHour(event: Event, stratDate: Date, endDate: Date) -> Void {
        guard let todo = event.todo else { return }
        
        // 기존에 가지고 있던 시간을 빼줌.
        let diff = (event.startDate - event.endDate).second ?? 0
        let allHours = todo.allHours + diff
        RealmService.shared.update(todo, with: ["allHours": allHours])
     
        RealmService.shared.update(event, with: ["startDate": stratDate, "endDate": endDate])
        
        // 변경된 시간으로 더해줌.
        let newDiff = (event.endDate - event.startDate).second ?? 0
        let newAllHours = todo.allHours + newDiff
        RealmService.shared.update(todo, with: ["allHours": newAllHours])
        
    }
    
    func deleteEvent(event: Event) {
        // tagTodo가 존재 할때만 총시간을 빼준다.
        guard let todo = event.todo else {
            RealmService.shared.delete(event)
            return
        }
        
        let diff = (event.startDate - event.endDate).second ?? 0
        let allHours = todo.allHours + diff
        RealmService.shared.update(todo, with: ["allHours": allHours])
        RealmService.shared.delete(event)
    }
}
