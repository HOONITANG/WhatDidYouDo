//
//  ColorViewController.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//

import UIKit


private let reuseIdentifier = "ColorViewCell"

protocol ColorViewControllerDelegate: class {
    func didSelectColor(viewModel: ColorViewModel)
}

class ColorViewController: UITableViewController {
    // MARK: - Properties
    private let todo: Todo
    
    var delegate: ColorViewControllerDelegate?
    
    // 중복선택을 막기위해 최상위에서 선언
    var selectedItem: [String: Any] = ["type": ColorType.basic, "index": 0]
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleLeftNavTap))
        return button
    }()
    
    private var colorHeaderView = ColorHeaderView()
    
    // MARK: - Lifecycle
    
    init(todo: Todo) {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigation()
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    @objc func handleLeftNavTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func configureNavigation() {
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationItem.title = "Color"
    }
    
    func configureTableView() {
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .singleLine
        tableView.register(ColorViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.tableHeaderView = colorHeaderView
        colorHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        
        // todo에 저장된 color type,index로 변경(color select)
        selectedItem["type"] = todo.colorType
        selectedItem["index"] = todo.colorIndex
        
        // todo에 저장된 color type으로 HeaderColor 변경
        var viewModel = ColorViewModel(type: todo.colorType, selectedItem: selectedItem)
        viewModel.index = viewModel.selectedItem["index"] as! Int
        colorHeaderView.textColor = viewModel.bgColor
    }
}

// MARK: - UITableViewDataSource

extension ColorViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ColorType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ColorViewCell
        guard let type = ColorType(rawValue: indexPath.row) else { return cell }
        
        let viewModel = ColorViewModel(type: type, selectedItem: selectedItem)
        
        cell.viewModel = viewModel
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ColorViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


// MARK: -  ColorViewCellDelegate

extension ColorViewController: ColorViewCellDelegate {
    func didSelectColor(viewModel: ColorViewModel) {
        var viewModel = viewModel
        
        // cell color check 적용
        self.selectedItem = viewModel.selectedItem
        viewModel.index = viewModel.selectedItem["index"] as! Int
        
        // header color 적용
        colorHeaderView.textColor = viewModel.bgColor
        
        delegate?.didSelectColor(viewModel: viewModel)
        tableView.reloadData()
        
    }
}
