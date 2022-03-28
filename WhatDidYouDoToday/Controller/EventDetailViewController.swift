//
//  EventDetailViewController.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/15.
//

import UIKit

private let reuseIdentifier = "EventDetailViewCell"

class EventDetailViewController: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView()
    private var viewModel: EventViewModel?
    
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleLeftNavTap))
        return button
    }()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleRightNavTap))
        return button
    }()
    
    lazy var deleteFooterView: UIView = {
        let view = UIView()
        // 삭제 이미지
        let iv = UIImageView(image: UIImage(named: "delete_option")?.withRenderingMode(.alwaysTemplate))
        iv.setDimensions(width: 24, height: 24)
        iv.tintColor = .systemRed
        // 삭제 라벨
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemRed
        label.text = I18NStrings.Alert.remove
        
        let stack = UIStackView(arrangedSubviews: [iv, label])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center
        
        view.addSubview(stack)
        stack.center(inView: view)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteImageViewTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    // MARK: - Lifecycle
    init(viewModel: EventViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        configureTableView()
    }
    
    // MARK: - Selector
    @objc func handleLeftNavTap() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleRightNavTap() {
        guard let viewModel = viewModel else { return }
        guard let event = viewModel.selectdEvent else { return }
        
        // 변경이 가능할 경우
        if viewModel.startTimestamp < viewModel.endTimestamp {
            EventDetailService.shared.updateTodoHour(event: event, stratDate: viewModel.startTimestamp, endDate: viewModel.endTimestamp)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dailyScheduleReload"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mainViewReload"), object: nil)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        // startDate가 endDate보다 이후일 경우 등 변경을 할 수 없음을 알린다.
        else {
            AlertHelper.showAlert(title: I18NStrings.Event.eventChangeFailTitle, message: I18NStrings.Event.eventChangeFailMessage , type: .basic, over: self, handler: nil)
        }
        
    }
    @objc func deleteImageViewTapped() {
        guard let viewModel = viewModel else { return }
        guard let event = viewModel.selectdEvent else { return }
        
        AlertHelper.showAlert(title: I18NStrings.Event.eventRemoveTitle, message: I18NStrings.Event.eventCompleteMessage, type: .delete, over: self) { (_) in
            EventDetailService.shared.deleteEvent(event: event)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dailyScheduleReload"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mainViewReload"), object: nil)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(deleteFooterView)
        deleteFooterView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 65)
      
        view.addSubview(underLineView)
        underLineView.anchor(left: view.leftAnchor, bottom: deleteFooterView.topAnchor, right: view.rightAnchor, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: view.frame.width, height: 1)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: underLineView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
    }
    
    func configureNavigation() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        titleLabel.text = viewModel.title
        navigationItem.titleView = titleLabel
        
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = .systemRed
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.register(EventDetailViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        // extra cell remove
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        
    }
}

// MARK: - UITableViewDataSource

extension EventDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventViewDetailCellOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventDetailViewCell
        guard let cellOption = EventViewDetailCellOption(rawValue: indexPath.row), let viewModel = viewModel else {
            return cell
        }
        cell.delegate = self
        cell.detailViewModel = EventDetailViewModel(viewModel: viewModel, cellOption: cellOption)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EventDetailViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set the row height based on whether or not the Int associated with that row is contained in the expandedCells array
      
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 높이조절을 위한 index
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}

// MARK: EventDetailViewCellDelegate
extension EventDetailViewController: EventDetailViewCellDelegate {
    func datePickerChanged(picker: UIDatePicker, detailViewModel: EventDetailViewModel) {
        self.tableView.beginUpdates()
        for (index, _) in EventViewDetailCellOption.allCases.enumerated() {
            // 선택한 Cell 전송을 위해 사용됨.
            let indexPath = IndexPath(row: index, section: 0)
            
            // 다른 cell에게도 날짜 변경 전달
            if let cell = tableView.cellForRow(at: indexPath) as? EventDetailViewCell {
                cell.dateBoundary = (detailViewModel.startDate, detailViewModel.endDate)
            }
        }
        self.tableView.endUpdates()
        
        // event 데이터 업데이트
        self.viewModel?.startTimestamp = detailViewModel.startDate
        self.viewModel?.endTimestamp = detailViewModel.endDate
    }
}
