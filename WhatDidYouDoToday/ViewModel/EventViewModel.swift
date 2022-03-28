//
//  EventViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/15.
//

import UIKit

struct EventViewModel {
    var selectdEvent: Event?
    var todo: Todo?
    var title: String
    var stats: TodoType
    var startTimestamp: Date!
    var endTimestamp: Date! // 실제 시간 - 데이터 베이스에서 불러온 시간
    var endTimeAdd30Minutes: Date!  // 실제 시간이 startTime보다 30분 이전일 경우엔 30분으로 설정 - 즉, 보여지는 시간
    var eventUIInfo = EventUIInfo(height: 0, width: 0, startPoint: 0, leftPoint: 0)
    var isActiveEvent: Bool

    init(event: Event) {
        // 시작중인 Event를 알기 위해서
        let isActiveEvent = event.todo?.lastEvent ?? Event() == event
        
        let dictionary: [String: Any] = ["title": event.title, "startTimestamp": event.startDate, "endTimestamp": event.endDate, "stats": event.todo?.type ?? TodoType.Complete, "isActiveEvent": isActiveEvent
        ]
        
        self.init(dictonary: dictionary)
        
        self.selectdEvent = event
        self.todo = event.todo ?? Todo()
    }
    
    init(dictonary: [String: Any]) {
        self.title = dictonary["title"] as? String ?? ""
        self.stats = dictonary["stats"] as? TodoType ?? TodoType.Complete
        if let startTimestamp = dictonary["startTimestamp"] as? Date {
            self.startTimestamp = startTimestamp
        }
        if let endTimestamp = dictonary["endTimestamp"] as? Date {
            self.endTimestamp = endTimestamp
            self.endTimeAdd30Minutes = endTimestamp
        }
        if (endTimestamp - startTimestamp).minute ?? 0 > 30 {
        } else {
            self.endTimeAdd30Minutes = self.startTimestamp.adding(minutes: 30)
        }
        self.isActiveEvent = dictonary["isActiveEvent"] as? Bool ?? false
    }
    
}

struct EventUIInfo {
    var height: CGFloat = 0
    var width: CGFloat  = 0
    var startPoint: CGFloat = 0
    var leftPoint: CGFloat = 0
}
