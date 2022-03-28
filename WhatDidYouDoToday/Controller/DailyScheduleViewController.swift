//
//  DailyScheduleViewController.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//


import UIKit
import RealmSwift

private let reuseIdentifier = "dailyViewCell"

class DailyScheduleViewController: UIViewController {
    
    // MARK: - Properties
    private let realm = RealmService.shared.realm
    let tableView = UITableView()
    /// tableView rowHeight
    let rowHeight = CGFloat(80)
    
    /// tableView  Hour Width
    let dayViewWidth = CGFloat(44 + 8 + 8 + 1)
    
    private lazy var eventViewWidth = view.frame.width - dayViewWidth
    
    var viewModel: DailyScheduleViewModel
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = viewModel.titleLabel
        return label
    }()
    // MARK: - LifeCycle
    init(date: Date) {
        self.viewModel = DailyScheduleViewModel(from: date)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
        configureTableView()
        
        // 기존에 존재하는 subView(EventView) 모두 제거
        tableView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        viewModel.eventViewModelSet(width: eventViewWidth)
        
        // 상위로 이동해서 그림
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let indexPath:IndexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        drawEventView()
       
        // present 시 0.1초 텀을 주어야 이동함.
        // 광고를 제거 하거나, present를 사용 안 할시 0.1 지연시간 제거함
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let indexPath:IndexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            
            let hour = Calendar.current.component(.hour, from: Date())
            let indexPath2:IndexPath = IndexPath(row: hour, section: 0)
            self.tableView.scrollToRow(at: indexPath2, at: .top, animated: false)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(dailyScheduleReload), name: NSNotification.Name(rawValue: "dailyScheduleReload"), object: nil)
        
    }
    
    
    // MARK: - Selector
    @objc func dailyScheduleReload() {
        // 기존에 존재하는 subView(EventView) 모두 제거
        tableView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        // fetch Event Data
        self.viewModel = DailyScheduleViewModel(from: viewModel.date)
        
        // event Data set.
        viewModel.eventViewModelSet(width: eventViewWidth)
        
        // 상위로 이동해서 그림
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let indexPath:IndexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        // eventDraw
        drawEventView()
        
        // Scroll View - tableView의 Height를 변경하기 위해서 맨위부터 스크롤함.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let indexPath:IndexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            
            let hour = Calendar.current.component(.hour, from: Date())
            let indexPath2:IndexPath = IndexPath(row: hour, section: 0)
            self.tableView.scrollToRow(at: indexPath2, at: .top, animated: false)
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        // grabberHeight + rowHeight * (index) = tablViewCell의 첫 위치
        // K.grabberViewHeight + rowHeight * 3
        // Navigation Title
        navigationItem.titleView = titleLabel
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 80)
        tableView.rowHeight = rowHeight
        tableView.backgroundColor = .white
        
        tableView.separatorStyle = .none
        tableView.register(DailyViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        let footerView = UIView()
        tableView.tableFooterView = footerView
    }
    
    
    func drawEventView() {
        // 실제 Event을 보여주는 계산
        for eventViewModel in viewModel.eventViewModels {
            let eventUIInfo = eventViewModel.eventUIInfo
            
            let eventView = EventUIView() // event: event, type: .low
            
            // EventView Tap 등록
            let tap = EventTapGesture(target: self, action: #selector(handleEventViewTapped))
            tap.viewModel = eventViewModel
            eventView.addGestureRecognizer(tap)
            eventView.isUserInteractionEnabled = true
            
            // event View 등록
            eventView.viewModel = eventViewModel
            tableView.addSubview(eventView)
            eventView.setDimensions(width: eventUIInfo.width, height: eventUIInfo.height * rowHeight)
            eventView.anchor(top: tableView.topAnchor, left: tableView.leftAnchor, paddingTop: eventUIInfo.startPoint * rowHeight, paddingLeft: dayViewWidth + eventUIInfo.leftPoint)
            
        }
    }
    
    // MARK: - Selector
    @objc func handleEventViewTapped(sender : EventTapGesture) {
        guard let viewModel = sender.viewModel else {
            return
        }
        
        let todo = sender.viewModel?.todo ?? Todo()
        let event = sender.viewModel?.selectdEvent ?? Event()
        
        //만약 시작중이라면 종료하시겠습니까 알람을 띄운다.
        if todo.type == .Start && viewModel.isActiveEvent {
            AlertHelper.showAlert(title: "", message: I18NStrings.Event.eventCompleteMessage, type: .delete, over: self) { (_) in
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mainViewReload"), object: nil)
                
                // todo의 allHours 변경
                let diff = (Date() - event.startDate).second ?? 0
                let allHours = todo.allHours + diff
                RealmService.shared.update(todo, with: ["allHours": allHours, "type": TodoType.Complete])
                RealmService.shared.update(event, with: ["endDate": Date()])
                
                self.dailyScheduleReload()
            }
        }
        else {
            let controller = EventDetailViewController(viewModel: viewModel)
            let nav = UINavigationController(rootViewController: controller)
            present(nav, animated: true, completion: nil)
            return
        }
    }
    
    
}


// MARK: - UITableViewDataSource

extension DailyScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! DailyViewCell
        cell.hour = viewModel.hours[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DailyScheduleViewController: UITableViewDelegate {
    
    
}


class EventTapGesture: UITapGestureRecognizer {
    var viewModel:EventViewModel?
}
