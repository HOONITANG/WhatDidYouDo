//
//  TodoViewController.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import UIKit

private let reuseIdentifier = "TodoCollectionViewCell"

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    // BottomActionSheet
    private var actionSheetLauncher = ActionSheetLauncher()
    
    // Navigation Title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "gearshape"))
        imageView.tintColor = .black
        imageView.setDimensions(width: 25, height: 25)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let leftTodayImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "t.circle")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .systemOrange
        imageView.isHidden = true
        imageView.setDimensions(width: 25, height: 25)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let rightPlusImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "plus"))
        imageView.tintColor = .black
        //let imageView = UIImageView(image: UIImage(named: "add_schedule"))
        imageView.setDimensions(width: 25, height: 25)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let rightSearchImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .black
        imageView.setDimensions(width: 25, height: 25)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    // TodoList??? ????????? collectionView
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // DailySchduleController??? ???????????? bottom button
    private lazy var bottomButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 100, height: 56)
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "schedule_bottom_button")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBottomButtonTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var bottomPieChartButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 100, height: 56)
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "pie_chart_bottom_button")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBottomButtonTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
//    private lazy var bottomReportButtonImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
//        iv.setDimensions(width: 100, height: 56)
//        iv.backgroundColor = .clear
//        iv.image = UIImage(named: "report_bottom_button")
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBottomButtonTapped))
//        iv.addGestureRecognizer(tap)
//        iv.isUserInteractionEnabled = true
//        return iv
//    }()
   
    
    // ?????? TabBar
    let filterTapBar = TagFilterView()
    
    // viewModel ?????????
    private var viewModel = MainViewModel()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigation()
        configureSwipeGesture()
        
        filterTapBar.delegate = self
        filterTapBar.viewModel = viewModel
        
        collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(filterTapBar)
        filterTapBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingRight: 0, height: 50)
        
        let bottomButtonStackView = UIStackView(arrangedSubviews: [bottomButtonImageView, bottomPieChartButtonImageView])
        bottomButtonStackView.axis = .horizontal
        bottomButtonStackView.spacing = 32
        
        view.addSubview(bottomButtonStackView)
        bottomButtonStackView.centerX(inView: view)
        bottomButtonStackView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 16)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: filterTapBar.bottomAnchor, left: view.leftAnchor, bottom: bottomButtonStackView.topAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0,  paddingBottom: 0,paddingRight: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(mainViewReload), name: NSNotification.Name(rawValue: "mainViewReload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(calendarDayDidChange(notification:)), name: .NSCalendarDayChanged, object: nil)
       
    }
    
    
    // MARK: Selector
    @objc func mainViewReload() {
        filterTapBar.viewModel = viewModel
        collectionView.reloadData()
    }
    
    @objc func calendarDayDidChange(notification : NSNotification) {
        // ????????? ????????? ??? ???????????? ??????
        ComputeDayPass().operate()
        
        DispatchQueue.main.async {
            self.viewModel.selectDate = Date()
            self.titleLabel.text = self.viewModel.titleLabel
            self.leftTodayImageView.isHidden = true
            self.collectionView.reloadData()
        }
    }
    
    @objc func handleLeftNavTap() {
        let controller = SettingViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleLeftTodayTap() {
        viewModel.selectDate = Date()
        titleLabel.text = viewModel.titleLabel
        leftTodayImageView.isHidden = true
        collectionView.reloadData()
    }
    
    @objc func handleTitleNavTap() {
        let controller = DatePopupController()
        controller.delegate = self
        controller.viewModel = viewModel
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .overCurrentContext
        present(nav, animated: false, completion: nil)
    }
    
    @objc func handleRightPlusNavTap() {
        let controller = AddTodoViewController(viewModel: viewModel, todo: Todo(), type: .add, adRootController: self)
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
        
    }
    
    @objc func handleRightSearchNavTap() {
        let controller = TodoSearchViewController(style: .plain)
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
    
    @objc func handleBottomButtonTapped(sender: UITapGestureRecognizer) {
        var controller: UIViewController
        if (sender.view == bottomButtonImageView) {
            controller = DailyScheduleViewController(date: viewModel.selectDate)
        } else if (sender.view == bottomButtonImageView) {
            controller = DailyPieChartViewController(date: viewModel.selectDate)
        } else {
            // Report
            controller = DailyPieChartViewController(date: viewModel.selectDate)
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func handleSwipes(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            // Perform action.
            // ??????????????? ???????????? swipe
            if gestureRecognizer.direction == .left {
                viewModel.selectDate = CalendarHelper().plusDay(from: viewModel.selectDate)
            }
            // ???????????? ??????????????? swipe
            if gestureRecognizer.direction == .right {
                viewModel.selectDate = CalendarHelper().minusDay(date: viewModel.selectDate)
            }
            
            // Today Button ?????? ?????? ??? ?????? ????????????.
            if CalendarHelper().getStandardDate(viewModel.selectDate) == CalendarHelper().getStandardDate() {
                leftTodayImageView.isHidden = true
            } else {
                leftTodayImageView.isHidden = false
            }
            
            titleLabel.text = viewModel.titleLabel
            collectionView.reloadData()
        }
    }
    
    
    // MARK: Helpers
    
    // ??????????????? getstureTemplate
    func addGestureTemplate(view: UIView, action: Selector?) {
        let tap = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tap)
    }
    
    // ?????? ?????????????????? ???????????? ?????????
    func configureNavigation() {
        navigationController?.navigationBar.barTintColor = .white
        
        // Left Navigation
        addGestureTemplate(view: leftImageView, action: #selector(handleLeftNavTap))
        addGestureTemplate(view: leftTodayImageView, action: #selector(handleLeftTodayTap))
        
        let leftStackView = UIStackView(arrangedSubviews: [leftImageView, leftTodayImageView])
        leftStackView.spacing = 16
        leftStackView.axis = .horizontal
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftStackView)
        
        // Right Navigation
        addGestureTemplate(view: rightSearchImageView, action: #selector(handleRightSearchNavTap))
        addGestureTemplate(view: rightPlusImageView, action: #selector(handleRightPlusNavTap))
        
        let rightStackView = UIStackView(arrangedSubviews: [rightSearchImageView, rightPlusImageView])
        rightStackView.spacing = 16
        rightStackView.axis = .horizontal
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightStackView)
        
        
        let downArrowImage = UIImageView(image: UIImage(named: "down_arrow"))
        downArrowImage.setDimensions(width: 15, height: 15)
        downArrowImage.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel,downArrowImage])
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        titleLabel.text = viewModel.titleLabel
        
        addGestureTemplate(view: stackView, action: #selector(handleTitleNavTap))
        
        
        navigationItem.titleView = stackView
    }
    // swipe??? ???????????? ?????????
    func configureSwipeGesture() {
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
}
 
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let todos = self.viewModel.todos else { return }
        let date = self.viewModel.selectDate
        
        // ?????? ????????? ?????? ?????? ????????? ???????????? ??????.
        let isToday = (CalendarHelper().getStandardDate(date) - CalendarHelper().getStandardDate(Date())).day == 0
        if !isToday {
            AlertHelper.showAlert(title: "", message: I18NStrings.Main.changeStatusNotToday, over: self)
            return
        }
        // ?????? ?????? ????????????
        self.viewModel.selectTodo = todos[indexPath.row]
        MainViewService.shared.updateStartStatus(todo: todos[indexPath.row])
        
        // reloadDate?????? at ??? ????????????, Timer??? ????????? ????????? ????????? ?????????.
        collectionView.reloadData()
        filterTapBar.viewModel = viewModel
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let todos = self.viewModel.todos else { return 0 }
       
        return todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TodoCollectionViewCell
        guard let todos = self.viewModel.todos else { return cell }
        let todo = todos[indexPath.row]
        let viewModel = TodoViewModel(todo: todo)
        cell.viewModel = viewModel
        cell.delegate = self
        cell.isUserInteractionEnabled = true
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: TodoCollectionViewCellDelegate
extension MainViewController: TodoCollectionViewCellDelegate {
    func moreImageViewTapped(viewModel: TodoViewModel) {
        let controller = AddTodoViewController(viewModel: self.viewModel, todo: viewModel.todo, type: .set, adRootController: self)
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
    func statusImageViewTapped(viewModel: TodoViewModel) {
        self.viewModel.selectTodo = viewModel.todo
        actionSheetLauncher.todo = viewModel.todo
        
        actionSheetLauncher.delegate = self
        
        // bottomActionSheet ?????? ?????????
        actionSheetLauncher.show()
    }
    
}

extension MainViewController: ActionSheetLauncherDelegate {
    func didSelect(option: TodoType, isToday: Bool) {
        // ????????? ?????????, status??? ?????? ??? ??? ??????.
        // ????????? ??????
        if !isToday && option != .delete {
            AlertHelper.showAlert(title: "", message: I18NStrings.Main.changeStatusNotToday, over: self)
            return
        }
        // filterTapBar.viewModel = viewModel
        
        MainViewService.shared.updateTodoStatus(todo: viewModel.selectTodo, status: option, controller: self) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
}

extension MainViewController: TagTabViewDelegate {

    func didSelectTagItem(tag: Tag) {
        viewModel.selectTag = tag
        filterTapBar.viewModel = viewModel
        collectionView.reloadData()
    }
    
    func tagDetailImageTapped() {
        let controller = TagViewController(type: .set)
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
}

extension MainViewController: DatePopupControllerDelegate {
    func handleDatePicker(_ sender: UIDatePicker) {
        viewModel.selectDate = sender.date
        
        if CalendarHelper().getStandardDate(viewModel.selectDate) == CalendarHelper().getStandardDate() {
            leftTodayImageView.isHidden = true
        } else {
            leftTodayImageView.isHidden = false
        }
        
        titleLabel.text = viewModel.titleLabel
        collectionView.reloadData()
    }
}
