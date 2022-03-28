//
//  DailyScheduleViewModel.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/15.
//

import Foundation
import RealmSwift

/// DailySchedule의 tableView에서 사용되는 값들을 모아놓음
struct DailyScheduleViewModel {
    /// event들을 검색 할 날짜
    var date = Date()
    /// tableView에 event 뷰를 표현할 정보
    var eventViewModels = [EventViewModel]()
    
    /// tableView에 표현될 event
    var events:Results<Event>? 
    
    /// Table List 값
    let hours:[Int] = {
        var hours = [Int]()
        for hour in 0...23
        {
            hours.append(hour)
        }
        return hours
    }()
    
    /// Navigation Title 라벨
    var titleLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM .dd - EE"
        return formatter.string(from: date)
    }
    
    init(from date: Date) {
        self.date = date
        self.events = DailyScheduleService.shared.fetchEvents(from: date)
        events?.forEach { (event) in
            self.eventViewModels.append(EventViewModel(event: event))
        }
    }
    
    /// eventView를 그리기위한 설정 값 세팅
    mutating func eventViewModelSet(width eventViewWidth: CGFloat) {
        // 기본값 설정
        for (index, event) in eventViewModels.enumerated() {
            eventViewModels[index].eventUIInfo.startPoint = CGFloat(convertDateToMinutes(event.startTimestamp))
            eventViewModels[index].eventUIInfo.height = caculateRowHeight(sDate: event.startTimestamp, eDate: event.endTimeAdd30Minutes)
            eventViewModels[index].eventUIInfo.width = eventViewWidth
        }
        
        // 중첩되게 쌓이지 않았다면, 기본 width로 출력함
        // index : event의 각 index
        // stack : 쌓인 횟수
        
        // index ~ stack이 0이되기 전까지 width의 크기를 변경해줌
        // 겹칩이 끝났을 때 stack이 2번 쌓였으면 -> 쌓이기 시작한 인덱스부터 index ~ index + 2 위치까지 크기를 변경함
        
        var stack = 0
        var stackIndex = -1 // 스택이 쌓이기 시작한 index
        for (index, _) in eventViewModels.enumerated() {
            let isIndexValid = eventViewModels.indices.contains(index+1)
            // index + 1이 존재할 때 까지
            if isIndexValid {
                // 현재 index와 다음 index+1 겹칠경우
                if eventViewModels[index].endTimeAdd30Minutes >= eventViewModels[index+1].startTimestamp {
                    stack += 1
                    stackIndex = stackIndex == -1 ? index : stackIndex
                    
                    for (j, e) in (stackIndex...(stackIndex+stack)).enumerated() {
                        eventViewModels[e].eventUIInfo.width = (eventViewWidth / CGFloat(stack+1))
                        eventViewModels[e].eventUIInfo.leftPoint = j != 0 ? (eventViewWidth / CGFloat(stack+1)) * CGFloat(j) : CGFloat(0)
                    }
                    
                }
                // 겹치지 않을 경우, stack이 쌓여 있다면, 쌓여있는 곳 까지 변경해줌
                else {
                    if stack != 0 {
                        for (j, e) in (stackIndex...(stackIndex+stack)).enumerated() {
                            eventViewModels[e].eventUIInfo.width = (eventViewWidth / CGFloat(stack+1))
                            eventViewModels[e].eventUIInfo.leftPoint = j != 0 ? (eventViewWidth / CGFloat(stack+1)) * CGFloat(j) : CGFloat(0)
                        }
                    }
                    // 스택 초기화
                    stack = 0
                    stackIndex = -1
                }
            }
        }
    }
    
    // 시간에 맞춰 row길이를 설정함.
    func caculateRowHeight(sDate:Date, eDate: Date) -> CGFloat {
        var result = Double(eDate.timeIntervalSince(sDate))
        let digit: Double = pow(10, 2)
        // 시간 단위로 변환 0.5 = 30분
        result = result / 60 / 60
        // 2자리 반올림
        
        result = round(result * digit) / digit
        
        // 15분보다 작으면 15분길이로 설정함.
        // 여기서 길이설정을 하려고 하였으나
        // 길이 비교를 endDate로 하기 때문에, endDate에 Date()를 넣어버리면
        // 이전의index 와 비교가 안됨 ㅠ
        //result = result < 0.5 ? 0.5 : result
        
        return CGFloat(result)
        
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
}
