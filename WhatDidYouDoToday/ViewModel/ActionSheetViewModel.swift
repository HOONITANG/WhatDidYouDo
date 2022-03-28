//
//  ActionSheetViewModel.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/17.
//

import Foundation

struct ActionSheetViewModel {

    private let todo: Todo
        
    // BottomActionSheet options
    var options: [TodoType] {
        var results = [TodoType]()
        
        results.append(.Complete)
        results.append(.NotStarted)
        results.append(.Postpone)
        results.append(.delete)
        
        return results
    }
    
    init(todo: Todo) {
        self.todo = todo
    }
}
