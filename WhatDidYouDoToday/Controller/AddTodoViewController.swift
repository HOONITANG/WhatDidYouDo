//
//  AddTodoViewController.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import UIKit
import RealmSwift
import GoogleMobileAds

private let reuseIdentifier = "AddTodoViewCell"
class AddTodoViewController: UIViewController {
    
    // MARK: - Properties
    private let realm = RealmService.shared.realm
    private let tableView = UITableView()
    private var interstitial: GADInterstitialAd?
    private var clickCount = 0 // 버튼 중첩 클릭 방지를 위해 사용.
    
    var viewModel: AddTodoViewModel
    let adRootController: UIViewController
    
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleLeftNavTap))
        
        return button
        
    }()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: viewModel.type.actionTitle, style: .plain, target: self, action: #selector(handleRightNavTap))
        
        return button
    }()
    
    
    // MARK: - LifeCycle
    init(viewModel: MainViewModel, todo: Todo, type: AddTodoOpenType, adRootController: UIViewController) {
        self.viewModel = AddTodoViewModel(tag: viewModel.selectTag!, todo: todo, date: viewModel.selectDate, type: type)
        self.adRootController = adRootController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        
        // 전면 광고 등록
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:K.interstitialAdKey,
                               request: request,
                               completionHandler: { [self] ad, error in
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
                               }
        )
    }
    
    // MARK: - Selector
    @objc func handleLeftNavTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 저장 시 동작하는 메서드
    @objc func handleRightNavTap() {
        
        // 중첩 클릭 방지를 위해 사용함.
        if clickCount > 0 {
            return
        }
        
        clickCount += 1
        
        let type = viewModel.type
        let todo = viewModel.todo
        
        // todo의 titie이 없다면, Alert을 띄움
        if viewModel.todo.title == "" {
            AlertHelper.showAlert(title: "", message: type.alertMessage, over: self)
            return
        }
        
        switch type {
        case .set:
            // 오늘 이거나, 오늘 이후 일 경우
            guard let specificTodo = realm.object(ofType: Todo.self, forPrimaryKey: viewModel.originTodoId)  else { return }
            guard let todoRepeat = specificTodo.todoRepeat.first else { return }
            
            if viewModel.isAfterToday {
                // todo의 키값을 통해 todo를 찾은후, 변경된 todo로 바꿔준다.
                //guard let todo = tagTodo.todo else { return }
                // tag가 안들어가서 넣어줌. tag dictionary객체는 nil로 들어가 버림
                var dictionary = todo.toDictionary()
                dictionary["tag"] = viewModel.tag
                
                // repeat 업데이트, todo 업데이트
                RealmService.shared.update(todoRepeat, with: ["repeatTypes": viewModel.repeatTypes])
                RealmService.shared.update(specificTodo, with: dictionary)
                
                // 선택한 TagTodo를 변경 후
                // 선택한 tagTodo 날짜 기준으로 지워질 데이터를 부름
                let startDate = todo.date
                
                let toBeDeleteTodo = todoRepeat.todos.filter("isAddDay == true AND date > %@",startDate)
                
                // 검색한 오늘 이후 모든 tagTodo 제거
                toBeDeleteTodo.forEach { (todo) in
                    RealmService.shared.delete(todo)
                }
                
                // 선택한 Todo의 뒤 날짜로 검색하여, 날짜로 추가된 Todo가 아닌 항목들을 모두 수정해줌.
                // 다음날 Tagtodo가 존재할 경우, 위에서 다지웠음에도 존재하기때문에 날짜로 추가된 것은 아님
                let afterTodo = todoRepeat.todos.filter("date > %@",startDate)
                
                afterTodo.forEach { (todo) in
                    RealmService.shared.update(todo, with: dictionary)
                }
            }
            // 오늘 이전 일 경우
            else {
                // 기존 Todo만 업데이트함
                // tag가 안들어가서 넣어줌. tag dictionary객체는 nil로 들어가 버림
                var dictionary = todo.toDictionary()
                dictionary["tag"] = viewModel.tag
                
                RealmService.shared.update(todoRepeat, with: ["repeatTypes": viewModel.repeatTypes])
                RealmService.shared.update(specificTodo, with: dictionary)
            }
            
            self.dismiss(animated: true, completion: nil)
            
            
        case .add:
            // viewModel에 새로 생성한 todo를 생성해줌.
            todo.tag = viewModel.tag
            todo.date = viewModel.date
            RealmService.shared.create(todo)
            
            //todoRepeat에 생성한 todos를 추가해줌
            
            let todoRepeat = TodoRepeat()
            RealmService.shared.create(todoRepeat)
            RealmService.shared.update(todoRepeat, with: ["repeatTypes": viewModel.repeatTypes])
            do {
                try realm.write {
                    todoRepeat.todos.append(todo)
                }
            } catch let error as NSError {
                print("Debug: error is \(error)")
            }
            
            
            let adAlert = UserDefaults.standard.bool(forKey: "adAlert")
            if adAlert {
                AlertHelper.showAlert(title: I18NStrings.Alert.advertisement, message:I18NStrings.Alert.advertisementMessage, over: self, handler: { _ in
                    UserDefaults.standard.set(false, forKey: "adAlert")
                    self.createAd()
                })
            } else {
                createAd()
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mainViewReload"), object: nil)
    }
    
    // MARK: - Helper
    func configureUI() {
        view.backgroundColor = .white
        //view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        configureNavigation()
        configureTableView()
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func configureNavigation() {
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = .systemRed
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.register(AddTodoViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        // extra cell remove
        tableView.tableFooterView = UIView()
    }
    
    func createAd() {
        let purchased = UserDefaults.standard.bool(forKey: InAppProducts.product)
        if purchased {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.dismiss(animated: true, completion: {
                if self.interstitial != nil {
                    self.interstitial?.present(fromRootViewController: self.adRootController)
                }
            })
        }
    }
    
}


// MARK: - UITableViewDataSource

extension AddTodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddTodoCotents.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AddTodoViewCell
        
        guard let content = AddTodoCotents(rawValue: indexPath.row) else {
            return cell
        }
        viewModel.content = content
        
        cell.delegate = self
        cell.viewModel = viewModel
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddTodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let content = AddTodoCotents(rawValue: indexPath.row) else {
            return 0
        }
        
        return content  == .repeatDay ? 116 : 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let content = AddTodoCotents(rawValue: indexPath.row) else {
            return
        }
        
        switch content {
        case .title:
            print("DEBUG: title")
        case .tag:
            let controller = TagViewController(type: .select)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            present(nav, animated: true, completion: nil)
            
        case .color:
            print("DEBUG: color")
            let todo = viewModel.todo
            let controller = ColorViewController(todo: todo)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            present(nav, animated: true, completion: nil)
            
        case .repeatDay:
            print("DEBUG: repeatDay")
            
        }
        
        
    }
    
}

//// MARK: - AddTodoViewCellDelegate
extension AddTodoViewController: AddTodoViewCellDelegate {
    func didSelectDayFilterView(repeatTypes: String) {
        viewModel.repeatTypes = repeatTypes
    }
    
    func didDeselectDayFilterview(repeatTypes: String) {
        viewModel.repeatTypes = repeatTypes
    }
    
    func textDidChangeHandle(_ textField: UITextField) {
        guard let title = textField.text else {
            return
        }
        
        viewModel.todo.title = title
    }
    
}
//
////MARK: - TagViewControllerDelegate
//
extension AddTodoViewController: TagViewControllerDelegate {
    func didSelectTagCell(tag: Tag) {
        self.viewModel.tag = tag
        
        let indexPath:IndexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
//
//// MARK: - ColorViewControllerDelegate
//
extension AddTodoViewController: ColorViewControllerDelegate {
    func didSelectColor(viewModel: ColorViewModel) {
        self.viewModel.todo.textColor = viewModel.bgColor
        self.viewModel.todo.colorIndex = viewModel.index
        self.viewModel.todo.colorType = viewModel.type
        
        let indexPath:IndexPath = IndexPath(row: 2, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        // tableView.reloadData() // 이것 때문에 칼라 선택 시 키보드가 올라온다.
    }
}


// MARK : GADInterstitialDelegate
extension AddTodoViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("didFailToPresentFullScreenContentWithError is call")
        print("error is \(error)")
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidPresentFullScreenContent is call")
        
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidDismissFullScreenContent is call")
        //self.dismiss(animated: true, completion: nil)
    }
}
