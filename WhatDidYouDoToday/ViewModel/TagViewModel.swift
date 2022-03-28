//
//  TagViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//

import Foundation
import RealmSwift

enum TagOpenType: Int {
    case set
    case select
}

struct TagViewModel {
    var tag: Tag?
    var tags: Results<Tag>?
    let service = MainViewService.shared
    
    var type: TagOpenType
    var title: String {
        return tag?.title ?? ""
    }
    
    var isSelectView: Bool {
        return type == .select
    }
    
    init(type: TagOpenType) {
        self.tags = service.fetchTags()
        self.type = type
    }
}

