//
//  LanguageSettingViewController.swift
//
//  Created by Taehoon Kim on 2022/01/27.
//

import UIKit

class LanguageSettingViewController: UITableViewController {
    private enum LanguageOption: Int, CaseIterable {
        case language
    }
    
    private enum ContentType: Int {
        case korea
        case japan
        case america
    }
    
    private struct LanguageViewModel {
        var option: LanguageOption
        
        // table Section의 이름
        var sectionName: String {
            switch option {
            case .language:
                return I18NStrings.Setting.languageSelect
            }
        }
        
        // table Row의 이름
        var contentName: [[String: Any]] {
            switch option {
            case .language:
                return [["language": "English", "type": ContentType.america],["language": "한국어","type": ContentType.korea],["language": "日本語", "type": ContentType.japan]]
            }
        }
        
        
    }
    
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        navigationItem.title = "Language"
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView = UITableView(frame: .zero, style: .grouped)
    }
    
    //MARK: -Helper
    
}

//MARK: -UITableViewDelegate

extension LanguageSettingViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let option = LanguageOption(rawValue: indexPath.section) else {
            return
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = LanguageViewModel(option: option)
        
        let dictionary = viewModel.contentName[indexPath.row]
        if let type = dictionary["type"] as? ContentType {
            switch type {
            case .korea:
                print("korea")
            case .japan:
                print("japan")
            case .america:
                print("america")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
//MARK: -UITableViewDataSource
extension LanguageSettingViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return LanguageOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 해당 section에 맞는 타입을 불러옴
        guard let option = LanguageOption(rawValue: section) else {
            return 0
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = LanguageViewModel(option: option)
        
        return viewModel.contentName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        // 해당 section에 맞는 타입을 불러옴
        guard let option = LanguageOption(rawValue: indexPath.section) else {
            return cell
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = LanguageViewModel(option: option)
        
        let dictionary = viewModel.contentName[indexPath.row]
        if let text = dictionary["language"] as? String {
            cell.textLabel?.text = text
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 해당 section에 맞는 타입을 불러옴
        guard let option = LanguageOption(rawValue: section) else {
            return ""
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = LanguageViewModel(option: option)
        
        return viewModel.sectionName
    }
    
}
