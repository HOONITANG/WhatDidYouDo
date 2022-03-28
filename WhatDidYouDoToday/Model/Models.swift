//
//  Models.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import Foundation
import RealmSwift

/// Todo들을 그룹핑하는 데이터
class Tag: Object {
    @Persisted(primaryKey: true) var _id : ObjectId               // AutoKey값
    @Persisted var title: String = ""                             // Tag의 Title
    @Persisted var sort: Int = 0                                  // 보여 줄 순서를 위해 저장
    @Persisted var isDefault: Bool = false
    @Persisted var isStart: Bool = false
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}

/// Todo Repeat Check Data
class TodoRepeat: Object {
    @Persisted(primaryKey: true) var _id : ObjectId     // AutoKey값
    @Persisted var repeatTypes: String = ""             // "": not rpeat 0: sun, 1: mon ... 6: sat
    @Persisted var todos: List<Todo>
    @Persisted var date = Date()                        // 정렬에 사용 될 수 있을 것 같아 추가
    @Persisted var sort: Int = 0                        // 정렬에 사용 될 수 있을 것 같아 추가
    @Persisted var exceptDates: List<ExceptDate>        // 날짜 추가에서 제외하는 Date
}

// 날짜추가에서 제외되는 Date
class ExceptDate: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var exceptDate: Date?
}

/// Todo데이터
class Todo: Object {
    @Persisted(primaryKey: true) var _id : ObjectId     // AutoKey값
    @Persisted(originProperty: "todos") var todoRepeat: LinkingObjects<TodoRepeat>
    @Persisted var title: String = ""                   // Todo의 Title
    @Persisted var sort: Int = 0                        // 보여 줄 순서를 위해 저장
    @Persisted var tag: Tag?                            // 어떤 태그인지 알기 위해(TagTodo에, 날짜 별로 추가해 줄때 사용)
    // @Persisted var repeatTypes: String = ""             // "": not rpeat 0: sun, 1: mon ... 6: sat
    // @Persisted var isLast: Bool = false                   // 가장 마지막에 설정 된 Todo임을 알기 위해 사용
    @Persisted var lastEvent: Event?                    // 가장 최근에 선택한 event
    
    // 수정시 저장한 color를 보여주기 위해 사용
    @Persisted var textColor = 0x000000
    @Persisted var colorType = ColorType.basic
    @Persisted var colorIndex = 0
    
    @Persisted var date: Date = Date()
    @Persisted var type: TodoType = TodoType.NotStarted  // open, postpone(전날 미완료 or 미룸시), dayadd냐
    @Persisted var isAddDay: Bool = false
    @Persisted var allHours: Int = 0
    
    
    convenience init(todo: Todo) {
        self.init()
        self.title = todo.title
        self.type = todo.type
        self.sort = todo.sort
        self.tag = todo.tag
        self.allHours = todo.allHours
        self.lastEvent = todo.lastEvent
        self.textColor = todo.textColor
        self.colorType = todo.colorType
        self.colorIndex = todo.colorIndex
    }
//
//    convenience init(todo: Todo, new: Bool) {
//        self.init()
//        self.title = todo.title
//        self.sort = todo.sort
//        self.tag = todo.tag
//        self.applyTypeDate = todo.applyTypeDate
//        self.repeatTypes = todo.repeatTypes
//        self.lastEvent = todo.lastEvent
//        self.status = todo.status
//        self.textColor = todo.textColor
//        self.colorType = todo.colorType
//        self.colorIndex = todo.colorIndex
//    }
    
}


enum ColorType: Int, CaseIterable, PersistableEnum {
    case basic
    case pastel
    case warm
    case cold
    case dark
    case spring
    case coffee
    case retro
}


class Event: Object {
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var title: String
    @Persisted var todo: Todo?
    @Persisted var startDate: Date = Date()
    @Persisted var endDate: Date = Date()
}


enum TodoType: Int, PersistableEnum {
    case Start
    case Stop
    case Complete
    case NotStarted
    case Postpone
    case delete
    
    var description: String {
        switch self {
        case .Start:
            return I18NStrings.Alert.start
        case .Stop:
            return I18NStrings.Alert.suspense
        case .Complete:
            return I18NStrings.Alert.complete
        case .NotStarted:
            return I18NStrings.Alert.notComplete
        case .Postpone:
            return I18NStrings.Alert.postpone
        case .delete:
            return I18NStrings.Alert.remove
        }
    }
    
    var imageName: String {
        switch self {
        case .Start:
            return "notstarted_option"
        case .Stop:
            return "notstarted_option"
        case .Complete:
            return "complete_option"
        case .NotStarted:
            return "notstarted_option"
        case .Postpone:
            return "postpone_option"
        case .delete:
            return "delete_option"
        }
    }
}
