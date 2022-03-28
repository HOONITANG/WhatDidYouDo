//
//  NoticeViewController.swift
//
//  Created by Taehoon Kim on 2022/01/25.
//

import UIKit

private let reuseIdentifier = "NoticeViewCell"
class NoticeViewController: UITableViewController {
    
    //MARK: - Properties
    private let noticeData: [[String : AnyObject]] = {
        if  Locale.current.isKorean {
            return RemoteConfigManager.shared.json(forKey: .krNotice)
        }
        if  Locale.current.isEnglish {
            return RemoteConfigManager.shared.json(forKey: .enNotice)
        }
        if  Locale.current.isJapan {
            return RemoteConfigManager.shared.json(forKey: .jpNotice)
        }
        return RemoteConfigManager.shared.json(forKey: .enNotice)
    }()
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        navigationItem.title = "Notice"
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoticeViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: -Helper
    
}

//MARK: -UITableViewDelegate
extension NoticeViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
//MARK: -UITableViewDataSource
extension NoticeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoticeViewCell
        
        let viewModel = NoticeViewModel(dictionary: noticeData[indexPath.row])
        cell.viewModel = viewModel
        
        return cell
    }
  
}

