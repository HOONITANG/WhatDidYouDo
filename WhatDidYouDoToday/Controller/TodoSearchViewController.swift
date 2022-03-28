//
//  TodoSearchViewController.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/22.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "TodoSearchViewCell"

class TodoSearchViewController: UITableViewController {
    
    // MARK: Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let todoRepeats: Results<TodoRepeat>?
    private var todosArray = [TodoSearchViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var filteredTodos = [TodoSearchViewModel]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive &&
            !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: LifeCycle
    override init(style: UITableView.Style) {
        self.todoRepeats = MainViewService.shared.fetchAllTodoRepeats()
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Total Time"
        
        configureTableView()
        configureSearchController()
    }
    
    // MARK: - Selector
    @objc func handleDissal() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func configureTableView() {
        tableView.register(TodoSearchViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        // dataSet
        guard let todoRepeats = self.todoRepeats else {
            return
        }
        todoRepeats.forEach({ (todoRepeat) in
            if todoRepeat.todos.count > 0 {
                todosArray.append(TodoSearchViewModel(todos: todoRepeat.todos))
            }
        })
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a title"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
}

// MARK: - UITableViewDataSource
extension TodoSearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return inSearchMode ? filteredTodos.count : todosArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TodoSearchViewCell

        // todos를 하나의 배열로 합쳐야함.
        let viewModel = inSearchMode ? filteredTodos[indexPath.row] : todosArray[indexPath.row]
        
        cell.viewModel = viewModel
    
        return cell
    }
    
}

//MARK: - UISearchResultsUpdating
extension TodoSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredTodos = todosArray.filter({ return $0.title.lowercased().contains(searchText)})
    }
    
}
