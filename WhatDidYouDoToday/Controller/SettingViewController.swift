//
//  SettingViewController.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/16.
//

import UIKit
import StoreKit
private let reuseIdentifier = "SettingViewCell"

class SettingViewController: UIViewController {
    //MARK: - Properties
    private let reviewUrl: String = RemoteConfigManager.shared.​string(forKey: .reviewUrl)
    
    // MARK: - Properties
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        view.backgroundColor = .white
        navigationItem.title = I18NStrings.Setting.setting
        
        tableConfigure()
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
        // 리뷰 요청
        DispatchQueue.main.async {
            guard let scene = self.view.window?.windowScene else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            AppStoreReviewManager.requestReviewIfAppropriate(scene: scene)
        }
        
    }
    
    // MARK: - Selector
    
    
    // MARK: - Helper
    func tableConfigure() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SettingViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let type = SettingType(rawValue: indexPath.section) else {
            return
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = SettingViewModel(type: type)
        
        // 배열안에 있는 ditionary의 action값을 부름
        // dictionary는 순서를 보장하지 않기 때문에 이런 방식을 사용하였음
        guard let actionType = viewModel.contentAction[indexPath.row].values.first else {
            return
        }
        
        switch actionType {
        case .DiscoverPremium:
            let controller = PremiumViewController(collectionViewLayout: UICollectionViewFlowLayout())
            present(controller, animated: true, completion: nil)
        case .ThemeColorSettings:
            print("ThemeColorSettings")
        case .FontSettings:
            print("FontSettings")
        case .ICloud:
            let controller = StorageManageViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        case .AppInfo:
            let controller = AppInfoViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        case .Notice:
            let controller = NoticeViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        case .ContactUs:
            UIPasteboard.general.string = "vinieo0000@gmail.com"
            self.toastMessage(I18NStrings.Setting.contactUsMessage)
            
            print("ContactUs")
        case .AppReview:
            if let appstoreURL = URL(string: reviewUrl) {
                var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
                components?.queryItems = [
                  URLQueryItem(name: "action", value: "write-review")
                ]
                guard let writeReviewURL = components?.url else {
                    return
                }
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
            }
            
            print("AppReview")
        case .LanguageSettings:
            let controller = LanguageSettingViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            
            print("LanguageSettings")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 해당 section에 맞는 타입을 불러옴
        guard let type = SettingType(rawValue: section) else {
            return 0
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = SettingViewModel(type: type)
        
        return viewModel.contentName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! SettingViewCell
        
        // 해당 section에 맞는 타입을 불러옴
        guard let type = SettingType(rawValue: indexPath.section) else {
            return cell
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = SettingViewModel(type: type)
        
        // 배열안에 있는 ditionary의 Key값을 부름
        // dictionary는 순서를 보장하지 않기 때문에 이런 방식을 사용하였음
        cell.textLabel?.text = viewModel.contentName[indexPath.row].keys.first
        
        if viewModel.contentName[indexPath.row].values.first ?? false {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 해당 section에 맞는 타입을 불러옴
        guard let type = SettingType(rawValue: section) else {
            return ""
        }
        
        // 타입에 맞는 content를 불러옴
        let viewModel = SettingViewModel(type: type)
        
        return viewModel.sectionName
    }
    
}


extension SettingViewController {
    func toastMessage(_ message: String){
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = keyWindow else {return}
        
        let messageLbl = UILabel()
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = UIFont.systemFont(ofSize: 16)
        messageLbl.numberOfLines = 0
        messageLbl.textColor = .white
        messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.5)

        let textSize:CGSize = messageLbl.intrinsicContentSize
        let labelWidth = min(textSize.width, window.frame.width - 40)

        messageLbl.frame = CGRect(x: 20, y: window.frame.height - 90, width: labelWidth + 40, height: textSize.height + 20)
        messageLbl.center.x = window.center.x
        messageLbl.layer.cornerRadius = messageLbl.frame.height/2
        messageLbl.layer.masksToBounds = true
        window.addSubview(messageLbl)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

        UIView.animate(withDuration: 1, animations: {
            messageLbl.alpha = 0
        }) { (_) in
            messageLbl.removeFromSuperview()
        }
        }
    }
}
