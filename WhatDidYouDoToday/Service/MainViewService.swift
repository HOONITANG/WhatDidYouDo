//
//  MainViewSerivce.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import Foundation
import RealmSwift

class MainViewService {
    // sigleton pattern
    static let shared = MainViewService()
    
    // Realm()으로 선언된 변수는 Document/밑에 있는 realmDB에 대한 포인터다.
    var realm = try! Realm()
    
    /// Tag에 해당하는 todo데이터 fetch
    func fetchTodos(to tag: Tag?, from date: Date) -> Results<Todo>? {
        guard let tag = tag else { return nil }
        
        // fetch 전, todo 날짜 기준으로 추가
        updateTodos(from: date)
        
        let boundary = CalendarHelper().dayBoundary(from: date)
        let todos = realm.objects(Todo.self).filter("tag = %@ AND date BETWEEN %@", tag, [boundary.startOfDay, boundary.endOfDay])
        
        return todos
    }
    
    // Search에서 사용되는 todo데이터
    func fetchAllTodoRepeats() -> Results<TodoRepeat>? {
        let todoRepeats = realm.objects(TodoRepeat.self)
        return todoRepeats
    }
    
    /// 날짜에 해당하는 todo데이터 fetch
    func fetchTodos(from date: Date) -> Results<Todo>? {
        let boundary = CalendarHelper().dayBoundary(from: date)
        
        let todos = realm.objects(Todo.self).filter("date BETWEEN %@", [boundary.startOfDay, boundary.endOfDay])
        
        return todos
    }
    
    
    /// Tag 데이터 fetch
    func fetchTags() -> Results<Tag>? {
        let tags = realm.objects(Tag.self)
        return tags
    }
    
    
    /// 날짜 선택 시, 오늘 이후일 경우 동작하는 메서드
    /// Todo에 저장된 repeatdays에 따라 반복해야하는 날짜면 추가해주는 메서드
    func updateTodos(from date: Date) -> Void {
        // 선택 날짜에 대한 하루 범위
        let boundary = CalendarHelper().dayBoundary(from: date)
        
        // 오늘보다 이후 일 경우에만 동작하게
        // 오늘 날짜에도 동작함.
        let isAfterDay = CalendarHelper().getStandardDate(date) >= CalendarHelper().getStandardDate()
        
        if isAfterDay {
            // repeatyTypes가 존재하여, 날짜별 반복하는 todo List를 검색함
            // 날짜를 선택 했을 때, repeatTypes에 맞게 추가를 하던지 말던지 해야함.
            let todoRepeats = realm.objects(TodoRepeat.self)
            
            todoRepeats.forEach { (todoRepeat) in
                
                let weekday = CalendarHelper().weekDay(date: date)
                let repeatTypes = convertStringtoArray(str: todoRepeat.repeatTypes)
                
                // 반복해야하는 날짜인지 체크
                if repeatTypes.contains(String(weekday)) {
                    // 선택한 날짜에 Todo가 추가 되어있는지 확인
                    let isEmptyTodo = todoRepeat.todos.filter("date BETWEEN %@", [boundary.startOfDay, boundary.endOfDay]).isEmpty
                    // 없을 시 추가.
                    if isEmptyTodo {
                        let prevTodo = todoRepeat.todos.first ?? Todo()
                        let todo = Todo(todo: prevTodo)
                        todo.date = CalendarHelper().getStandardDate(date)
                        todo.allHours = 0
                        todo.isAddDay = true
                        todo.type = .NotStarted
                        RealmService.shared.create(todo)
                        
                        // 추가된 todo을 todoRepeat에 추가함
                        do {
                            try realm.write {
                                todoRepeat.todos.append(todo)
                            }
                        } catch let error as NSError {
                            print("Debug: error is \(error)")
                        }
                    }
                }
            }
        }
    }
    
    /// 전달받은 todo로 내일 미룸상태인 todo를 제거하는 메서드
    fileprivate func removeTomorrowPostpone(from todo: Todo) {
        guard let todoRepeat = todo.todoRepeat.first else { return }
        
        // 하루 뒤 날짜를 얻음
        let newDate = CalendarHelper().plusDay(from: todo.date)
        let boundary = CalendarHelper().dayBoundary(from: newDate)
        // 하루뒤 날짜, Todo로 TagTodo를 검색함
        let tommorowTodos = todoRepeat.todos.filter("date BETWEEN %@", [boundary.startOfDay, boundary.endOfDay])
        
        // 다음날 Tagtodo가 존재 하고
        if let existTodo = tommorowTodos.first {
            // type이 미룸일 경우 제거함
            if existTodo.type == .Postpone {
                RealmService.shared.delete(existTodo)
            }
        }
    }
    
    /// Todo을 시작 상태에서 -> 종료로 바꾸었을 때 동작하는 메서드
    /// 실행 중이던 event의 시간을 측정하여 todo의 시간을 업데이트 해준다.
    fileprivate func ongoingEventEnd(_ todo: Todo) {
        // 선택한 Todo가 시작 중일 경우에만 동작
        if todo.type != .Start {
            return
        }
        
        // event 종료
        guard let event = todo.lastEvent  else { return }
        
        // tagTodo의 allHours 변경
        let diff = (Date() - event.startDate).second ?? 0
        let allHours = todo.allHours + diff
        
        RealmService.shared.update(event, with: ["endDate": Date()])
        RealmService.shared.update(todo, with: ["allHours": allHours, "lastEvent": event])
        RealmService.shared.update(todo.tag!, with: ["isStart": false]) // tag start표시 없앰
    }
    
    /// todo의 상태에 따라 시작과 중지를 실행하는 메서드
    func updateStartStatus(todo: Todo?) {
        guard let todo = todo else { return }
        if todo.type != .Start {
            RealmService.shared.update(todo, with: ["type": TodoType.Start])
            //todo 미룸 제거
            removeTomorrowPostpone(from: todo)
            
            // event 생성, todo의 lastEvent업데이트
            let event = Event()
            event.title = todo.title
            event.startDate = Date()
            event.endDate = Date()
            // event.endDate = event.startDate.adding(minutes: 30)
            event.todo = todo
            
            RealmService.shared.create(event)
            RealmService.shared.update(todo, with: ["lastEvent": event])
            RealmService.shared.update(todo.tag!, with: ["isStart": true])
        }
        // type이 시작 일 경우 종료.
        else {
            // event 종료
            ongoingEventEnd(todo)
            // todo status 업데이트
            RealmService.shared.update(todo, with: ["type": TodoType.Stop])
            removeTomorrowPostpone(from: todo)
        }
    }
    
    func updateTodoStatus(todo: Todo?, status: TodoType, controller: UIViewController, completion: @escaping ()->Void) {
        guard let todo = todo else { return }
        guard let todoRepeat = todo.todoRepeat.first else { return }
        switch status {
        case .Start:
            // 사용하지않음.
            print("Debug: Start")
        case .Stop:
            // 사용하지않음.
            print("Debug: Stop")
        case .Complete:
            // 실행중인 event 종료
            ongoingEventEnd(todo)
            // Complete로 상태 값 변경
            RealmService.shared.update(todo, with: ["type": TodoType.Complete])
            // 미룸 제거, 날짜 클릭 시 미룸으로 추가된 날짜 제거
            removeTomorrowPostpone(from: todo)
        case .NotStarted:
            // 실행중인 event 종료
            ongoingEventEnd(todo)
            // Complete로 상태 값 변경
            RealmService.shared.update(todo, with: ["type": TodoType.NotStarted])
            // 미룸 제거, 날짜 클릭 시 미룸으로 추가된 날짜 제거
            removeTomorrowPostpone(from: todo)
        case .Postpone:
            // 실행중인 event 종료
            ongoingEventEnd(todo)
            // Postpone로 상태 값 변경
            RealmService.shared.update(todo, with: ["type": TodoType.Postpone])
            
            // 하루 뒤 날짜를 얻음
            let newDate = CalendarHelper().plusDay(from: todo.date)
            
            // 하루뒤 날짜, Todo로 TagTodo를 검색함
            let boundary = CalendarHelper().dayBoundary(from: newDate)
            
            let tommorowTodos = todoRepeat.todos.filter("date BETWEEN %@", [boundary.startOfDay, boundary.endOfDay])
            
            // 다음날 Todo가 존재할 경우, 날짜로 추가되었을 수 있기에 isAddDay를 false로 변경함
            if tommorowTodos.first != nil {
                RealmService.shared.update(todo, with: ["type": TodoType.Postpone, "isAddDay": false])
            }
            // 다음날에 Todo가 존재하지 않으면 그냥 생성해줌
            else {
                let todo = Todo(todo: todo)
                todo.date = newDate
                RealmService.shared.create(todo)
                
                // 추가된 todo을 todoRepeat에 추가함
                do {
                    try realm.write {
                        todoRepeat.todos.append(todo)
                    }
                } catch let error as NSError {
                    print("Debug: error is \(error)")
                }
            }
            
        case .delete:
            // 실행중인 event 종료
            ongoingEventEnd(todo)
            
            // 오늘 날짜 이후 일 경우 Ex) 오늘 새벽1시에 추가 했을 시, 오늘 날짜보다 이후이다.
            // 21일 00:00 > 21일 00:00 -> 오늘 추가, 당일이다.
            // 22일 00:00 > 21일 01:00 -> 22일날 추가한 Todo다
            let isAfterDay = CalendarHelper().getStandardDate(todo.date) >= CalendarHelper().getStandardDate()
          
            // 선택한 날짜 이후, 당일 일 경우
            if isAfterDay {
                // repeatType이 존재하는 경우
                if todoRepeat.repeatTypes != "" {
                    AlertHelper.showAlert(title: "", message: I18NStrings.Main.repeatRemoveMessage, type: .delete, over: controller) { (_) in
                        // 선택한 Todo 날짜 이후, isAddDay == true인, repeatDay로 인해 추가된 tagTodo를 검색함
                        // 선택한 TagTodo를 변경 후
                        // 선택한 tagTodo 날짜 기준으로 지워질 데이터를 부름
                        let startDate = todo.date
                        let toBeDeleteTodo = todoRepeat.todos.filter("isAddDay == true AND date > %@",startDate)
                        // 검색한 오늘 이후 모든 tagTodo 제거
                        toBeDeleteTodo.forEach { (todo) in
                            RealmService.shared.delete(todo)
                        }
                        
                        // repeat 업데이트, todo 업데이트
                        RealmService.shared.update(todoRepeat, with: ["repeatTypes": ""])
                        // 오늘날짜 Todo 제거
                        RealmService.shared.delete(todo)
                        
                        completion()
                    }
                }
                // repeatType이 존재하지 않는 경우
                else {
                    RealmService.shared.delete(todo)
                }
            }
            // 선택한 날짜 이전 일 경우
            else {
                RealmService.shared.delete(todo)
            }
        }
        
        completion()
    }
    
    // String을 배열로 변환해주는 함수
    func convertStringtoArray(str: String) -> [String] {
        let array = str.components(separatedBy: ",")
        
        return array
    }
}

// Mark: TodoStatus Controll

// todo .status가 미룸인 경우
// -> 미룸 눌렀을 때 다음날 추가 해줌. 다만 다음날에 있을 경우 삭제후 추가함(day로 추가된 넘일 수가 있음)
// -> 미룸 해제 했으면 다음 날 삭제해줌.

//
// todo .status가 Delete인 경우
// Delete를 하면 오늘만 삭제됨?? (오늘 이전일 경우엔)
// (오늘, 오늘 이후 일 경우넨 해당하는 (미룸이 아니고, 사용자가 추가하지 않은(day로 추가된))모든 TagTodo를삭제함, Fiexed요일 있을 경우, 해제된다고 알려주고 삭제함)
// 선택날짜 이후 모든 해당하는 TagTodo를 삭제함?? -> 이건도 Delete할 때 진행햐하는 부분

//
// 요일 변경은 오늘 이후만 가능함 - 다만 적용되는 날짠 오늘부터임. 클릭한 날짜부터가 아님.? 걍 오늘만됨
// Fixed 요일 변경 시, 변경 날짜 이후 해당 모든 TagTodo 삭제 -> day로 추가된 녀석들만 삭제해야함

// MARK: -UpdateTagTodoBySelectDate
