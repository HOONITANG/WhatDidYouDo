//
//  DayFilterViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import Foundation


enum DayFilterContents: Int, CaseIterable {
    case sun
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
    var description: String {
        switch self {
        case .sun:
            return "sun"
        case .mon:
            return "mon"
        case .tue:
            return "tue"
        case .wed:
            return "wed"
        case .thu:
            return "thu"
        case .fri:
            return "fri"
        case .sat:
            return "sat"
        }
    }
}


struct DayFilterViewModel {
    let content: DayFilterContents
    var dayText: String = ""
    
    init(content: DayFilterContents) {
        self.content = content
        self.dayText = content.description
    }
    
}

