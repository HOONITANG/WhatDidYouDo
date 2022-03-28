//
//  AppInfoViewController.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/24.
//

import UIKit

class AppInfoViewController: UITableViewController {
    private enum AppInfoOption: Int, CaseIterable {
        case license
        case library
    }
    
    private struct AppInfoViewModel {
        var option: AppInfoOption
        
        // table Section의 이름
        var sectionName: String {
            switch option {
            case .license:
                return "License"
            case .library:
                return "Library"
            }
        }
        
        // table Row의 이름
        var contentName: [[String: Bool]] {
            switch option {
            case .license:
                return [["icons8": true],["Feather Icons": true]]
            case .library:
                return [["FSCalendar": false],["FloatingPanel": false],["RealmSwift": false],["RandomColorSwift": false],["Developer: kemiz": false]]
            }
        }
        
    }
    
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        navigationItem.title = "AppInfo"
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView = UITableView(frame: .zero, style: .grouped)
    }
    
    //MARK: -Helper
    
}

//MARK: -UITableViewDelegate

extension AppInfoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let option = AppInfoOption(rawValue: indexPath.section) else {
            return
        }
        
        switch option {
        case .license:
            if indexPath.row == 0 {
                if let url = URL(string: "https://icons8.com/") {
                    UIApplication.shared.open(url, options: [:])
                }
            }
            if indexPath.row == 1 {
                print("fether")
                if let url = URL(string: "https://feathericons.com/") {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        case .library:
            // TestFlight 상태일 때, 광고 안뜨게 하기 위해 추가함.
            if indexPath.row == 4 {
                if !Bundle.main.isProduction {
                    UserDefaults.standard.set(true, forKey: InAppProducts.product)
                    print("celcki")
                }
                print("celcki")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
//MARK: -UITableViewDataSource
extension AppInfoViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 해당 section에 맞는 타입을 불러옴
        guard let option = AppInfoOption(rawValue: section) else {
            return 0
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = AppInfoViewModel(option: option)
        
        return viewModel.contentName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        // 해당 section에 맞는 타입을 불러옴
        guard let option = AppInfoOption(rawValue: indexPath.section) else {
            return cell
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = AppInfoViewModel(option: option)
        
        // 배열안에 있는 ditionary의 Key값을 부름
        // dictionary는 순서를 보장하지 않기 때문에 이런 방식을 사용하였음
        cell.textLabel?.text = viewModel.contentName[indexPath.row].keys.first
        
        if viewModel.contentName[indexPath.row].values.first ?? false {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 해당 section에 맞는 타입을 불러옴
        guard let option = AppInfoOption(rawValue: section) else {
            return ""
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = AppInfoViewModel(option: option)
        
        return viewModel.sectionName
    }
    
}
