//
//  DatePopupController.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/08.
//

import UIKit

protocol DatePopupControllerDelegate: class {
    func handleDatePicker(_ sender: UIDatePicker)
}

class DatePopupController: UIViewController {
    // MARK: - Properties
    weak var delegate: DatePopupControllerDelegate?
    var viewModel: MainViewModel? {
        didSet {
            selectedDate = viewModel?.selectDate ?? Date()
            titleLabel.text = viewModel?.titleLabel ?? ""
        }
    }
    private var selectedDate = Date()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    // 날짜선택에 사용될 UIDatePicker
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ko-KR")
        picker.timeZone = .autoupdatingCurrent
        picker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        picker.backgroundColor = .white
        picker.setDate(selectedDate, animated: false)
        return picker
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
    }
    
    // MARK: - Selector
    @objc func handleTitleNavTap() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        viewModel?.selectDate = sender.date
        delegate?.handleDatePicker(sender)
    }
    
    @objc func backgroundHandleTap() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        // background tap
        let bgtap = UITapGestureRecognizer(target: self, action: #selector(backgroundHandleTap))
        self.view.addGestureRecognizer(bgtap)
        self.view.isUserInteractionEnabled = true
        
        // datePicker 추가
        view.addSubview(datePicker)
        datePicker.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        self.datePicker.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        
        // datePicker Animation
        UIView.animate(withDuration: 0.2) {
            // 높이변경 반영
            self.datePicker.frame = CGRect(x: 0, y: 0, width: 0, height: 300)
        }
         
    }
    
    // 상단 네비게이션을 설정하는 함수
    func configureNavigation() {
        navigationController?.navigationBar.barTintColor = .white
        
        let downArrowImage = UIImageView(image: UIImage(named: "down_arrow"))
        downArrowImage.setDimensions(width: 15, height: 15)
        downArrowImage.contentMode = .scaleAspectFit
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel,downArrowImage])
        titleStack.spacing = 4
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        
        let titleNavTap = UITapGestureRecognizer(target: self, action: #selector(handleTitleNavTap))
        titleStack.addGestureRecognizer(titleNavTap)
        navigationItem.titleView = titleStack
    }
}
