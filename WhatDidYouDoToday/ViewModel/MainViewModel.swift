//
//  MainViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import Foundation
import RealmSwift

// Tag, Todo 데이터를 호출하고 변경 시 데이터 업데이트를 알려주는 역할을 함.
struct MainViewModel {
    var todos:Results<Todo>?
    var tags:Results<Tag>?
    
    let service = MainViewService.shared
    
    var selectTodo: Todo?
    
    // 현재 선택한 Tag
    var selectTag: Tag? {
        didSet {
            self.todos = service.fetchTodos(to: selectTag, from: selectDate)
        }
    }
    
    // MainView, todo리스트를 호출 할 때 사용되는 date
    var selectDate: Date = Date() {
        didSet {
            if selectTag == nil { self.todos = service.fetchTodos(to: tags?.first, from: selectDate) }
            else { self.todos = service.fetchTodos(to: selectTag, from: selectDate) }
        }
    }
    
    var titleLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter.string(from: selectDate)
    }
    
    init() {
        self.tags = service.fetchTags()
        self.todos = service.fetchTodos(to: tags?.first, from: selectDate)
        self.selectTag = tags?.first
    }
    
    // collectionView에서 tagWidth를 동적으로 지정해주기 위한 메서드
    func tagWidthSize(_ text: String) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = text
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

// TodoCollectionView에서 사용되는 ViewModel
struct TodoViewModel {
    //let service = MainViewService.shared
    
    var todo: Todo
    
    var title: String {
        return todo.title
    }
    var textColor: UIColor {
        return UIColor(rgb: todo.textColor)
    }
    var statusImage: UIImage? {
        return UIImage(named:todo.type.imageName)?.withRenderingMode(.alwaysTemplate)
    }
    var date: Date {
        return todo.date
    }
    
    var attributeString: NSMutableAttributedString {
        
        let attributeString =  NSMutableAttributedString(string: todo.title)
        if todo.type == .Complete {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        } else {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: attributeString.length))
        }
        
        return attributeString
    }
    
    var isStart: Bool {
        return todo.type == .Start
    }
    
    var lastEvent: Event? {
        return todo.lastEvent
    }
    var allHours: Int {
        var diff = 0
        if let lastEvent = lastEvent {
            diff = (Date() - lastEvent.startDate).second ?? 0
        }
        
        if todo.type == .Start {
            return todo.allHours + diff
        }
        else {
            return todo.allHours
        }
        
    }
    
    var timeStamp: String {
        var time = secondsToHoursMinuteSeconds(seconds: allHours)
        if isStart {
            time = allHours == 0 ? "00 : 00 : 00" : time
        } else {
            time = allHours == 0 ? "" : time
        }
        return time
    }
    
    var isToday: Bool {
        return CalendarHelper().getStandardDate(date) >=  CalendarHelper().getStandardDate(Date())
    }
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    /// Todo cell second masking
    func secondsToHoursMinuteSeconds(seconds:Int) -> String {
        return makeTimeString(hours: seconds / 3600, minutes: (seconds % 3600 )/60, seconds: ((seconds % 3600) % 60))
    }
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
}
