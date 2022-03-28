//
//  NoticeViewModel.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/25.
//

import Foundation

struct NoticeViewModel {
    let title: String
    let content: String
    let date: String
    
    init(dictionary: [String : AnyObject]) {
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.date = dictionary["date"] as? String ?? ""
    }
}
