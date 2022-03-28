//
//  ActionSheetLauncher.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import UIKit

private let reuseIdentifier = "ActionSheetCell"

protocol ActionSheetLauncherDelegate: class {
    func didSelect(option: TodoType, isToday: Bool)
}

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    var todo = Todo() {
        didSet {
            viewModel = ActionSheetViewModel(todo: todo)
            tableView.reloadData()
            isToday = (CalendarHelper().getStandardDate(todo.date) - CalendarHelper().getStandardDate(Date())).day == 0
        }
    }
    
    private var isToday = true
    
    private let tableView = UITableView()
    private var window: UIWindow?
    private var tableViewHeight: CGFloat?
    
    // lazy var일경우
    // let tagTodo 가 먼저 컴파일러가 메모리에 올리기 때문에 tagTodo을 사용할 수 있음
    private lazy var viewModel = ActionSheetViewModel(todo: todo)
    
    weak var delegate: ActionSheetLauncherDelegate?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDimissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.addTarget(self, action: #selector(handleDimissal), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        configureTableView()
    }
    
    // MARK: - Selectors
    
    @objc func handleDimissal() {
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.showTableView(false)
        }
    }
    
    // MARK: -Helper
    
    // 전체 window 크기를 Y좌표로 잡고, tableView의 height만큼 Y좌표를 위로 움직임
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = tableViewHeight else { return }
        let y = shouldShow ? window.frame.height - height : window.frame.height
        
        tableView.frame.origin.y = y
    }
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        // 옵션의 갯수 만큼 tableViewHeight의 높이를 지정해줌
        let height = CGFloat(viewModel.options.count * 60) + 100
        self.tableViewHeight = height
        
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 1
            self.showTableView(true)
        }
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}


// MARK: - UITableViewDataSource

extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        
        cell.isActive = isToday
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ActionSheetLauncher: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.showTableView(false)
        } completion: { _ in
            self.delegate?.didSelect(option: option, isToday: self.isToday)
        }
        
    }
}


