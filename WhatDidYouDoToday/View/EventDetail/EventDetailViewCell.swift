//
//  EventDetailViewCell.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/15.
//

import UIKit

protocol EventDetailViewCellDelegate: class {
    func datePickerChanged(picker: UIDatePicker, detailViewModel: EventDetailViewModel)
}

class EventDetailViewCell: UITableViewCell {
    typealias dayBoundary = (startOfDay: Date?, endOfDay: Date?)
    weak var delegate: EventDetailViewCellDelegate?
    
    // var dateForUpdate: Date?
    
    var detailViewModel: EventDetailViewModel? {
        didSet {
            configureUI()
        }
    }
    
    // cell update를 우한 변수
    lazy var dateBoundary: dayBoundary = (detailViewModel?.startDate, detailViewModel?.endDate ){
        didSet {
            createThroughLabelLine(dateBoundary.startOfDay, dateBoundary.endOfDay)
            removeThroughLabelLine(dateBoundary.startOfDay, dateBoundary.endOfDay)
        }
    }
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "시작"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    var dateLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "2022. 1. 20. 오후 1:30"
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.date = Date()
        // datePicker.preferredDatePickerStyle = .inline
        if #available(iOS 14.0, *) {
             datePicker.preferredDatePickerStyle = UIDatePickerStyle.inline
        }
        if #available(iOS 13.4, *) {
            datePicker.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 250.0)
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var datePickerView: UIView = {
        let view = UIView()
        
        view.addSubview(datePicker)
        datePicker.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        return view
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        stackView.axis = .horizontal
        
        let dateStackView = UIStackView(arrangedSubviews: [stackView, datePickerView])
        dateStackView.axis = .vertical
        dateStackView.spacing = 8
        
        addSubview(dateStackView)
        dateStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            datePickerView.isHidden = false
            dateLabel.textColor = .systemOrange
        } else {
            datePickerView.isHidden = true
            dateLabel.textColor = .black
        }
    }
    
    // MARK: - Helper
    func configureUI() {
        guard let viewModel = detailViewModel else {
            return
        }
        
        datePicker.date = viewModel.pickerDate
        titleLabel.text = viewModel.cellOption.description
        dateLabel.text = viewModel.date
    }
    
    fileprivate func removeThroughLabelLine(_ startDate: Date?, _ endDate: Date?) {
        guard let viewModel = self.detailViewModel else {
            return
        }
        
        guard let startDate = startDate, let endDate = endDate else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = viewModel.cellOption == EventViewDetailCellOption.start ? "yyyy. MM. dd. a HH:mm" :  "a HH:mm"
        
        let date = viewModel.cellOption == EventViewDetailCellOption.start ? startDate : endDate
        
        if startDate < endDate {
            let attributeString =  NSMutableAttributedString(string: formatter.string(from: date))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: attributeString.length))
            dateLabel.attributedText = attributeString
        }
    }
    
    fileprivate func createThroughLabelLine(_ startDate: Date?, _ endDate: Date?) {
        guard let viewModel = self.detailViewModel else {
            return
        }
        
        guard let startDate = startDate, let endDate = endDate else {
            return
        }
        
        // 선택한 cell 일 경우 동작함
        if isSelected == true {
            let formatter = DateFormatter()
            formatter.dateFormat = viewModel.cellOption == EventViewDetailCellOption.start ? "yyyy. MM. dd. a HH:mm" :  "a HH:mm"
            let date = viewModel.cellOption == EventViewDetailCellOption.start ? startDate : endDate
            
            if startDate > endDate  {
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: formatter.string(from: date))
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
                dateLabel.attributedText = attributeString
            }
        }
    }
    
    
    // MARK: -Selector
    
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        // dateForUpdate = picker.date
        guard var viewModel = self.detailViewModel else {
            return
        }
        
        // picker로 선택한 Date와 tableview에서 전달된 Date로 설정한다.
        switch viewModel.cellOption {
        case .start:
            viewModel.startDate = picker.date
            viewModel.endDate = dateBoundary.endOfDay ?? Date()
        case .end:
            viewModel.endDate = picker.date
            viewModel.startDate = dateBoundary.startOfDay ?? Date()
        }
        
        // 현재 cell 말고 다른 cell에게도 전달하기 위한 함수
        delegate?.datePickerChanged(picker: picker, detailViewModel: viewModel)
    }
}
