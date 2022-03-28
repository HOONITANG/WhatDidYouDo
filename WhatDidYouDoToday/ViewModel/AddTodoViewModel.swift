//
//  AddTodoViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import Foundation
import RealmSwift

enum AddTodoOpenType: Int {
    case set
    case add
    
    var actionTitle: String {
        switch self {
         
        case .set:
            return I18NStrings.Tag.modify
        case .add:
            return I18NStrings.Tag.add
        }
    }
    
    var alertMessage: String {
        switch self {
        case .set:
            return I18NStrings.Tag.changeEmptyTitleMessage
        case .add:
            return I18NStrings.Tag.addEmptyTitleMessage
        }
    }
}

enum AddTodoCotents: Int, CaseIterable {
    case title
    case tag
    case color
    case repeatDay
    
    var description: String {
        switch self {
        case .title: return "title"
        case .tag: return "tag"
        case .repeatDay: return "repeat"
        case .color: return "color"
        }
    }
}

struct AddTodoViewModel {
    var tag: Tag // tag가 설정되면, tag option에 선택한 태그 이름으로 변경되어야함.
    var todo: Todo
    var originTodoId: ObjectId
    var date: Date
    var content: AddTodoCotents?
    var type: AddTodoOpenType
    // 오늘 날짜 이후임을 확인하는 Boolean 값
    var isAfterToday: Bool {
        return (CalendarHelper().getStandardDate(todo.date) - CalendarHelper().getStandardDate()).day ?? 0 >= 0
    }
//    var todoRepeatType: LinkingObjects<TodoRepeat> {
//        return todo.todoRepeatType ?? TodoRepeat()
//    }
    var repeatTypes: String = ""
    
    init (tag: Tag, todo: Todo, date: Date, type: AddTodoOpenType) {
        self.originTodoId = todo._id
        self.repeatTypes = todo.todoRepeat.first?.repeatTypes ?? ""
        self.todo = Todo(todo: todo)
        self.tag = tag
        self.date = date
        self.type = type
    }
    
    var isTitleField: Bool {
        return content == .title
    }
    
    var isTagField: Bool {
        return content == .tag
    }
    
    var isRepeatDayField: Bool {
        return content == .repeatDay
    }
    
    var isColorField: Bool {
        return content == .color
    }
    
    var colorTypeDescription: String {
        switch todo.colorType {
        case .basic:
            return I18NStrings.Tag.basic
        case .warm:
            return I18NStrings.Tag.warm
        case .pastel:
            return I18NStrings.Tag.pastel
        case .cold:
            return I18NStrings.Tag.cold
        case .dark:
            return I18NStrings.Tag.dark
        case .spring:
            return I18NStrings.Tag.spring
        case .coffee:
            return I18NStrings.Tag.coffee
        case .retro:
            return I18NStrings.Tag.retro
        }
    }
}
