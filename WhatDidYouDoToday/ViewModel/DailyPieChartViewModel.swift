//
//  DailyPieChartViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/20.
//


import Foundation
import RealmSwift
import RandomColorSwift

/// DailySchedule의 tableView에서 사용되는 값들을 모아놓음
struct DailyPieChartViewModel {
    typealias Time = (hours: Int, minutes: Int, seconds: Int)
    /// event들을 검색 할 날짜
    var date: Date {
        didSet {
            pieEventViewModels = []
            todos = []
            self.events = DailyScheduleService.shared.fetchEvents(from: date)
            events?.enumerated().forEach({ (index, event) in
                self.pieEventViewModels.append(PieEventViewModel(event: event, color: generateRandomPastelColor(withMixedColor: colors[index])))
                
                self.todos.insert(event.todo ?? Todo())
            })
        }
    }
    
    // month Label
    var monthLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY. MM. dd - EE"
        return formatter.string(from: date)
    }
    /// tableView에 표현될 event
    var events:Results<Event>?
    
    // piechart에 표현될 event
    var pieEventViewModels = [PieEventViewModel]()
    
    // pie chart에서 사용될 색깔
    var colors:[UIColor] {
        return randomColors(count: events?.count ?? 0, luminosity: .light)
    }
    
    var todos = Set<Todo>()
    
    var useAllHourAttribute: NSAttributedString {
        let allHours = todos.reduce(0,{$0 + $1.allHours})
        let time = secondsToHoursMinuteSeconds(seconds: allHours)
        
        return attributeText(text: I18NStrings.Chart.totalUsageTime, value: time)
    }
    
    var remainHourAttribute: NSAttributedString {
        let allHours = todos.reduce(0,{$0 + $1.allHours})
        let remainHours = 86400 - allHours
        let time = secondsToHoursMinuteSeconds(seconds: remainHours)
        
        return attributeText(text: I18NStrings.Chart.freeTime, value: time)
    }
    
    
    init(from date: Date) {
        self.date = date
        
        self.events = DailyScheduleService.shared.fetchEvents(from: date)
        
        events?.enumerated().forEach({ (index, event) in
            self.pieEventViewModels.append(PieEventViewModel(event: event, color: generateRandomPastelColor(withMixedColor: colors[index])))
            
            self.todos.insert(event.todo ?? Todo())
        })
    }
    
    // second masking
    func secondsToHoursMinuteSeconds(seconds:Int) -> String {
        return makeTimeString(hours: seconds / 3600, minutes: (seconds % 3600 )/60, seconds: ((seconds % 3600) % 60))
    }
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    // 랜덤한 Pastel색의로 변경
    func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
        // Randomly generate number in closure
        let randomColorGenerator = { ()-> CGFloat in
            CGFloat(arc4random() % 256 ) / 256
        }
            
        var red: CGFloat = randomColorGenerator()
        var green: CGFloat = randomColorGenerator()
        var blue: CGFloat = randomColorGenerator()
            
        // Mix the color
        if let mixColor = mixColor {
            var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
            mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
            
            red = (red + mixRed) / 2;
            green = (green + mixGreen) / 2;
            blue = (blue + mixBlue) / 2;
        }
            
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    // 시간에 대한 attributeText
    fileprivate func attributeText(text: String, value: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(text) ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]))
        
        
        return attributedTitle
    }
    
    // eventView를 그리기위한 설정 값 세팅
    mutating func eventViewModelSet(width eventViewWidth: CGFloat) {
        
        // 중첩되게 쌓이지 않았다면, 기본 width로 출력함
        // index : event의 각 index
        // stack : 쌓인 횟수
        
        // index ~ stack이 0이되기 전까지 label을 변경해줌.
        // 겹치는 마지막 label에 ,로 모두 표현함.
        
        var stack = 0
        var stackIndex = -1 // 스택이 쌓이기 시작한 index
        
        var labelArr = [String]() // 한번에 표현 될 label 배열
        for (index, _) in pieEventViewModels.enumerated() {
            let isIndexValid = pieEventViewModels.indices.contains(index+1)
            
            
            // index + 1이 존재할 때 까지
            if isIndexValid {
                // 현재 index와 다음 index+1 겹칠경우
                if pieEventViewModels[index].endTimestamp >= pieEventViewModels[index+1].startTimestamp {
                    stack += 1
                    stackIndex = stackIndex == -1 ? index : stackIndex
                    
                    let lastStackIndex = stackIndex+stack
                    
                    
                    // 쌓이기 시작한 index부터, 현재 쌓인곳 까지의 값을 변경해줌.
                    for (_, e) in (stackIndex...lastStackIndex).enumerated() {
                        
                        labelArr.append( pieEventViewModels[e].event.title )
                        pieEventViewModels[e].label = ""
                    }
                    // 마지막 label에 ,로 합쳐줌.
                    pieEventViewModels[lastStackIndex].label = labelArr.joined(separator: ",")
                    
                    
                }
                // 다음 Event 겹치지 않을 경우, stack이 쌓여 있다면, 쌓여있는 곳 까지 변경해줌
                else {
                    if stack != 0 {
                        let lastStackIndex = stackIndex+stack
                        for (_, e) in (stackIndex...(stackIndex+stack)).enumerated() {
                            pieEventViewModels[e].label = ""
                        }
                        // 마지막 label에 ,로 합쳐줌.
                        pieEventViewModels[lastStackIndex].label = labelArr.joined(separator: ",")
                    }
                    // 스택 초기화
                    stack = 0
                    stackIndex = -1
                    // label 초기화
                    labelArr = []
                }
            }
        }
    }
    
}

// PieChart에 사용되는 ViewModel
struct PieEventViewModel {
    
    var event: Event
    var backgroundColor: UIColor
    
    var label: String
    
    var startPoint: CGFloat {
        return CGFloat(convertDateToMinutes(event.startDate))
    }
    
    var endPoint: CGFloat {
        return CGFloat(convertDateToMinutes(event.endDate))
    }
    
    var endTimestamp: Date {
        return event.endDate
    }
    
    var startTimestamp: Date {
        return event.startDate
    }
    
    var durationTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        
        let start = formatter.string(from: event.startDate)
        let end = formatter.string(from: event.endDate)
        
        return "\(start) - \(end)"
    }
    
    // 15분 이상 작업한 내용만 보여줌.
    var isShow: Bool {
        if (event.endDate - event.startDate).minute ?? 0 > 15 {
            return true
        }
        else {
            return false
        }
    }
    
    init(event: Event, color: Color) {
        self.event = event
        self.backgroundColor = color
        self.label = event.title
    }
    
    // 현재 시간을 일정 수치로 변경함 1시30분 -> 1.5
    func convertDateToMinutes(_ date: Date) -> Double {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let digit: Double = pow(10, 2)
        let index = Double((hour * 60) + minute) / Double(60)
        let result = round(index * digit) / digit
        return result
    }
    
    func labelSize() -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = label
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
