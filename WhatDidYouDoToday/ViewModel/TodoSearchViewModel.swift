//
//  TodoSearchViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/22.
//

import Foundation
import RealmSwift

struct TodoSearchViewModel {
    let todos: Results<Todo>
    
    var title: String {
        return todos.first?.title ?? "알수없음."
    }
    
    var startDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy. MM. dd"
        if todos.first == nil { return "" }
        return formatter.string(from: todos.first!.date)
    }
    
    var endDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy. MM. dd"
        if todos.first == nil { return "" }
        return formatter.string(from: todos.last!.date)
    }
    
    var allHours: Int {
        let allHours = todos.reduce(0,{$0 + $1.allHours})
        return allHours
    }
    
    var hours: String {
        let hours = (allHours / 3600)
        
        return "\(hours) hours"
    }
    
    var minutes: String {
        let minutes = (allHours % 3600 )/60
        return "\(minutes) minutes"
    }
    
    init(todos: List<Todo>) {
        self.todos = todos.sorted(byKeyPath: "date")
    }
}
