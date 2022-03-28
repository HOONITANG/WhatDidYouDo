//
//  TagViewController.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//


import UIKit
import RealmSwift

private let reuseIdentifier = "TagViewCell"

protocol TagViewControllerDelegate: class {
    func didSelectTagCell(tag: Tag)
}

class TagViewController: UITableViewController {
    // MARK: - Properties
    weak var delegate: TagViewControllerDelegate?
    private var viewModel: TagViewModel
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleLeftNavTap))
        return button
    }()
    
    private lazy var tagHeaderview = TagHeaderView(type: viewModel.type)
    
    // MARK: - Lifecycle
    
    init(type: TagOpenType) {
        self.viewModel = TagViewModel(type: type)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigation()
        configureTableView()
    }
    
    // MARK: - Selector
    @objc func handleLeftNavTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureNavigation() {
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationItem.title = I18NStrings.Tag.tag
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 60
        
        tableView.register(TagViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.tableHeaderView = tagHeaderview
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        
        tagHeaderview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 126)
        tagHeaderview.delegate = self
        
        // extra cell remove
        tableView.tableFooterView = UIView()
    }
}



// MARK: - UITableViewDataSource

extension TagViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tags = viewModel.tags else { return 0 }
        return tags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! TagViewCell
        guard let tags = viewModel.tags else { return cell }
        
        viewModel.tag = tags[indexPath.row]
        
        
        
        cell.delegate = self
        cell.viewModel = viewModel
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TagViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let tags = viewModel.tags else { return }
        
        delegate?.didSelectTagCell(tag: tags[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - UITableViewDragDelegate

extension TagViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        guard let tags = viewModel.tags else { return [ dragItem ] }
        
        dragItem.localObject = tags[indexPath.row]
        return [ dragItem ]
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        // guard let tags = tags else { return }
        
        //let mover = tags.remove(at: sourceIndexPath.row)
        //tags.insert(mover, at: destinationIndexPath.row)
    }
}

// MARK: - TagViewCellDelegate
extension TagViewController: TagViewCellDelegate {
    func tagFieldChangeHandler(_ textField: UITextField, selectedTag: Tag) {
        if textField.text == "" {
            AlertHelper.showAlert(title: "", message: I18NStrings.Tag.changeEmptyTagMessage, over: self) { (_) in
                self.tableView.reloadData()
            }
            return
        }
        guard let title = textField.text else {
            return
        }
        
        let dict: [String: Any?] = ["title": title]
        
        RealmService.shared.update(selectedTag, with: dict)
       
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mainViewReload"), object: nil)

        tableView.reloadData()
    }
    
    func handleDeleteImageTapped(selectedTag: Tag) {
        if !selectedTag.isDefault {
            AlertHelper.showAlert(title: "", message: I18NStrings.Tag.removeAllTaskMessage, type: .delete, over: self) { (_) in
                RealmService.shared.delete(selectedTag)
                self.tableView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mainViewReload"), object: nil)
            }
            
        } else {
            AlertHelper.showAlert(title: "", message: I18NStrings.Tag.removeDefaultTagMessage, over: self)
        }
        
        tableView.reloadData()
    }
}

// MARK: - TagHeaderViewDelegate
extension TagViewController: TagHeaderViewDelegate {
    func textFieldReturnHandler(_ textField: UITextField) {
        if textField.text == "" {
            AlertHelper.showAlert(title: "", message: I18NStrings.Tag.emptyTagMessage, over: self)
            return
        }
        guard let title = textField.text else {
            return
        }
        let tag = Tag(title: title)
        RealmService.shared.create(tag)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mainViewReload"), object: nil)
        
        tableView.reloadData()
    }
}


