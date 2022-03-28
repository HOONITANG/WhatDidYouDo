//
//  EventDetailViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/15.
//

import UIKit

enum EventViewDetailCellOption : Int, CaseIterable {
    case start
    case end
    var description: String {
        switch self {
        case .start:
            return I18NStrings.Alert.start
        case .end:
            return I18NStrings.Alert.end
        }
    }
    
}

struct EventDetailViewModel {
    
    var viewModel: EventViewModel
    var cellOption: EventViewDetailCellOption
    
    var startDate: Date
    var endDate: Date
    
    var isVaild: Bool {
        return viewModel.startTimestamp <= viewModel.endTimestamp
    }
    
    var pickerDate: Date {
        switch cellOption {
        case .start:
            return viewModel.startTimestamp
        case .end:
            return viewModel.endTimestamp
        }
    }
    var date: String {
        switch cellOption {
        case .start:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy. MM. dd. a HH:mm"
            return formatter.string(from: viewModel.startTimestamp)
        case .end:
            let formatter = DateFormatter()
            formatter.dateFormat = "a HH:mm"
            return formatter.string(from: viewModel.endTimestamp)
        }
    }
    
    init(viewModel: EventViewModel, cellOption: EventViewDetailCellOption) {
        //self.todo = todo
        self.viewModel = viewModel
        self.cellOption = cellOption
        
        self.startDate = viewModel.startTimestamp
        self.endDate = viewModel.endTimestamp
    }
}
