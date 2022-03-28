//
//  DailyChartViewController.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/20.
//

import UIKit
import FSCalendar

private let reuseIdentifier = "DailyPieTableViewCell"
private let reuseIdentifierHeaderView = "DailyPieChartHeaderView"

class DailyPieChartViewController: UIViewController {
    // MARK: - Properties
    private var calendar = FSCalendar()
    private var viewModel: DailyPieChartViewModel
    private var calendarHeightConstraint : NSLayoutConstraint?
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var monthLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = viewModel.monthLabel
        label.textColor = .black
        
        return label
    }()
    
    private let calendarWrapperView:UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    
    // MARK: - LifeCycle
    init(date: Date) {
        self.viewModel = DailyPieChartViewModel(from: date)
        calendar.select(date)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        configureCalendar()
        configureTableView()
        configureUI()
    }
    
    // MARK: - Helper
    
    
    func configureUI() {
        
        calendar.dataSource = self
        calendar.delegate = self
        
        // CalendarViewWrapper
        view.addSubview(calendarWrapperView)
        calendarWrapperView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        // Label
        view.addSubview(monthLabel)
        monthLabel.anchor(top: calendarWrapperView.topAnchor, left: calendarWrapperView.leftAnchor, right: calendarWrapperView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 8)
        
        // Calendar
        view.addSubview(calendar)
        calendar.anchor(top: monthLabel.bottomAnchor, left: calendarWrapperView.leftAnchor, bottom: calendarWrapperView.bottomAnchor, right: calendarWrapperView.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)

        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 300)
        calendarHeightConstraint?.isActive = true
        
        // pie chart tableView
        view.addSubview(tableView)
        
        tableView.anchor(top: calendarWrapperView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,  paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 16)
        
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(DailyPieTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(DailyPieChartHeaderView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifierHeaderView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = false

        tableView.showsVerticalScrollIndicator = false
        
        tableView.layer.cornerRadius = 16
        // extra cell remove
        tableView.tableFooterView = UIView()
    }
    
    func configureCalendar() {
        calendar.scope = .week
        calendar.layer.cornerRadius = 15
        calendar.headerHeight = 0
        
        // weekday 폰트,색 설정
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 16)
        
        // date 폰트,색 설정
        calendar.appearance.todayColor = .systemBlue
        calendar.appearance.titleTodayColor = .white
        
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16)
        calendar.appearance.selectionColor = .black
    }
    
}

// MARK: - Calendar
extension DailyPieChartViewController: FSCalendarDelegate, FSCalendarDataSource {
    // 날짜를 선택했을 때 동작하는 함수
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.date = date
        tableView.reloadData()
        tableView.reloadSections(IndexSet(0...0), with: .automatic)
        monthLabel.text = viewModel.monthLabel
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let count = 0
        return count
    }
    
    // Month를 변경했을 때 동작하는 함수
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        viewModel.date =  calendar.currentPage
        monthLabel.text = viewModel.monthLabel
        
        tableView.reloadData()
        tableView.reloadSections(IndexSet(0...0), with: .automatic)
        
        calendar.select(calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint?.constant = bounds.height;
        self.view.layoutIfNeeded()
    }
    
    

}


// MARK: - UITableViewDataSource
extension DailyPieChartViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.pieEventViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DailyPieTableViewCell
        
        let viewModel = self.viewModel.pieEventViewModels[indexPath.row]
        cell.viewModel = viewModel
        
        return cell
    }
    
    // section 갯수 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // section height 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    // section 뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifierHeaderView) as! DailyPieChartHeaderView
        header.viewModel = viewModel
      
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        // grouped tableview의 기본 heightrk 17.5여서, 계속해서 constraint에러가 발생함.
        // 414로 header가 보통 표현되기 때문에 414로 설정함.
        return 414
    }
    
    
}

// MARK: - UITableViewDelegate
extension DailyPieChartViewController: UITableViewDelegate{
    
}

