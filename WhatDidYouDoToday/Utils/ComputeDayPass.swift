//
//  AppLaunchController.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/18.
//

import UIKit
import RealmSwift

class ComputeDayPass {
    //private let realm = RealmService.shared.realm
    let realmBackground = try! Realm()
    // Mark: NextDay Controll
    // 앱이 실행되어있을 때, 앱을 켰을 때 날짜가 변경되면 동작하는 함수.
    // 다음날로 미루거나, 이전날의 Task의 상태값들을 처리함.
    // 이전날의 Event을 EndDate의 날짜를 변경 시키고, 변경된 날짜로 Event를 추가시켜줌.
    func operate() {
        
        //let realmBackground = RealmService.shared.realm
        
        let loadDate = UserDefaults.standard.object(forKey: "dateKeyForUserDefault") as? Date
        
        if let loadDate = loadDate {
            let currentDate = CalendarHelper().getStandardDate()
            
            print("DEBUG: loadDate is \(loadDate)")
            print("DEBUG: currentDate is \(currentDate)")
            
            // extension으로 인해 가능함
            let interval = currentDate - loadDate
            
            print("DEBUG: interval is \(interval)")
            
            guard let dayDiff = interval.day else { return }
            // 하루가 지남
            if dayDiff > 0 {
                print("DEBUG: 하루 지남 dayDiff is \(dayDiff)")
                // 변경된 날짜로 재설정함
                UserDefaults.standard.set(currentDate, forKey:"dateKeyForUserDefault")
                
                print("DEBUG: 변경된 날짜로 재설정함")
                
                
                // 저장된 날짜에 해당하는 tagTodo들을 모두 호출함
                let pastBoundary = CalendarHelper().dayBoundary(from: loadDate)
                print("DEBUG: tagTodo 호출시 죽는것 같음 pastBoundary is \(pastBoundary)")
                print("DEBUG: 왜 안돼지 tagtodo is. \(realmBackground.objects(Todo.self))")
                print("DEBUG: TodoType.Complete 에서 에러 발생 예상 \(TodoType.Complete)")
                print("DEBUG: TodoType.Complete 에서 에러 발생 예상 filter 사용 \(realmBackground.objects(Todo.self).filter("type != %@", TodoType.Complete.rawValue))")
                
                let pastTodos = realmBackground.objects(Todo.self).filter("type != %@ AND date BETWEEN %@", TodoType.Complete.rawValue, [pastBoundary.startOfDay, pastBoundary.endOfDay])
                
                print("DEBUG: pastTodos 목록들임 : \(pastTodos)")
                
                // 현재 날짜의 하루 간격
                let currentBoundary = CalendarHelper().dayBoundary(from: currentDate)
                
                // 어제 존재 하던, 과거에 마지막으로 존재하던 tagTodo를 기준으로, 오늘의 tagTodo들을 찾음
                pastTodos.forEach { (todo) in
                    
                    let prevLastEvent = todo.lastEvent
                    
                    //과거 데이터 업데이트
                    self.update(todo, with: ["type": changeTypeByPassDay(todo: todo), "isAddDay": false])
                    
                    guard let todoRepeat = todo.todoRepeat.first else {
                        return
                    }
                    let currentTodos = todoRepeat.todos.filter("date BETWEEN %@", [currentBoundary.startOfDay, currentBoundary.endOfDay])
                    
                    // 오늘의 todo가 있을 경우
                    if currentTodos.first != nil {
                        print("DEBUG: todo가 있어서 업데이트 시작")
                        let currentTodo = currentTodos.first!
                        
                        // 해당하는 type으로 변경
                        // 오늘이기 때문에, isAddDay는 false로 변경
                        self.update(currentTodo, with: ["type": changeTypeByPassDay(todo: todo), "isAddDay": false])
                        
                        // 새로운 Event를 추가해줌. 이전의 Event의 endDate 날짜를 변경시킴
                        updateEvent(todo: currentTodo, currentDate: currentDate)
                    }
                    
                    // 오늘의 todo가 없는 경우
                    else {
                        print("DEBUG: todo가 없어서 그냥 집어 넣어줌 시작")
                        
                        let newTodo = Todo(todo: todo)
                        newTodo.date = currentDate
                        newTodo.isAddDay = false
                        newTodo.allHours = 0
                        self.create(newTodo)
                        
                        do {
                            try realmBackground.write {
                                todoRepeat.todos.append(newTodo)
                            }
                        } catch let error as NSError {
                            print("Debug: error is \(error)")
                        }
                        
                        updateEvent(todo: newTodo, currentDate: currentDate)
                    }
                    
                    // 과거의 tagTodo의 type을 완료로 바꿈
                    if todo.type == .Start {
                        guard let prevLastEvent = prevLastEvent else { return }
                        guard let endOfDay = pastBoundary.endOfDay else { return }
                        
                        // tagTodo의 allHours 변경 -> Main에도, TodoCollection에도 존재함 중복되는 코드
                        let diff = (endOfDay - prevLastEvent.startDate).second ?? 0
                        let allHours = todo.allHours + diff
                        self.update(todo, with: ["allHours": allHours, "type": TodoType.Complete, "isAddDay": false])
                        
                        // event 날짜 이전 날짜의 11:59:59로 변경 해줌
                        self.update(prevLastEvent, with: ["endDate": endOfDay])
                        
                    }
                    
                }
            }
        }
    }
    
    
    // 새롭게 추가된 tagTodo에 넣어야해서 따로 뺐다.
    func updateEvent(todo: Todo, currentDate: Date){
        // event 처리
        // 마지막으로 저장된 날짜에 만약 시작중인 Task가 존재 할 경우
        // lastEvent를 00:00로 짜르고, 00:00부터 시작하는 Event를 새로 등록해 줘야한다.
        
        if todo.type == .Start {
            // 새로운 event를 변경된 날짜로 추가해준다.
            let newEvent = Event()
            newEvent.title = todo.title
            newEvent.startDate = currentDate
            newEvent.endDate = currentDate
            newEvent.todo = todo // 추가된 애량 엮어줘야함.
            
            self.create(newEvent)
            self.update(todo, with: ["lastEvent": newEvent])
            
        }
    }
    
    func changeTypeByPassDay(todo: Todo) -> TodoType {
        switch todo.type {
        case .Start:
            return .Start
        case .Stop:
            return .Stop
        case .Complete:
            return .Complete
        case .NotStarted:
            return .Postpone
        case .Postpone:
            return .Postpone
        case .delete:
            return .NotStarted
        }
    }
    // 이전 날짜 status를 변경시킴 -> 미룸으로
    // 다만 시작 중인 경우는 제외함. 이전날짜는 완료로 표시하고 다음날 진행중으로 표시
    
    // 걍 싹지운다음에 아래 로직 수행하는게 편할듯 OR 모든 경우에서 이미 해당 Todo가 있는 경우 추가를 진행하지 않음!(미룸일 것이기 때문에)
    // todo .status가 미룸일 경우
    // 이미 추가가 되어있을 거임.
    
    // todo .status가 complete가 아닌경우 (시작(진행중), 중지(반진행), 빈칸 )
    // 미룸으로 추가함
    
    // todo .status가 시작(진행중인경우)
    // 진행중으로 추가함
    
    // todo .statue가 delete일 경우
    // 암궛도 안함
    
    // 위에내용을 거치고
    // todo .status가 고정일 경우, dayrepeatype이 ""이 아닐경우
    // 해당 날짜에 속한다면 추가를 진행함
    
    
    
    private func create<T:Object>(_ object:T) {
        do {
            try realmBackground.write {
                realmBackground.add(object)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    // Update
    // realm은 update시 객체의 값을 대입하기만하면 자동으로 업데이트된다.
    // ex) dog.name = "Rex"
    private func update<T:Object>(_ object:T, with dictionary:[String:Any?]) {
        do {
            try realmBackground.write {
                for (key, value) in dictionary {
                    if key != "_id" {
                        object.setValue(value, forKey: key)
                    }
                    
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    // Delete
    private func delete<T:Object>(_ object:T) {
        do {
            try realmBackground.write {
                realmBackground.delete(object)
            }
        } catch let error as NSError {
            print(error)
        }
    }
}
