//
//  AddTodoViewCell.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import UIKit

protocol AddTodoViewCellDelegate: class {
    func textDidChangeHandle(_ textField: UITextField)
    func didSelectDayFilterView(repeatTypes: String)
    func didDeselectDayFilterview(repeatTypes: String)
}


class AddTodoViewCell: UITableViewCell {
    
    // MARK: - Properties
    var viewModel: AddTodoViewModel? {
        didSet { configureUI() }
    }
    
    weak var delegate: AddTodoViewCellDelegate?
    
    private lazy var titleTextField: UITextField = {
        let tf = UITextField()
        // tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textAlignment = .left
        tf.textColor = .black
        tf.placeholder = "title"
        tf.delegate = self
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)),
                     for: .editingChanged)
        return tf
    }()
    
    private var tagLabel = UILabel()
    private var repeatLabel = UILabel()
    private let dayFilter = DayFilterView()
    
    private var colorLabel = UILabel()
    private let tagSubTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray2
        return label
    }()
    
    private let colorSubTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray2
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tagLabel = templateTitleLabel(text: I18NStrings.Tag.tag)
        repeatLabel = templateTitleLabel(text: I18NStrings.Tag.repeatDay)
        colorLabel = templateTitleLabel(text: I18NStrings.Tag.color)
        
        contentView.addSubview(titleTextField)
        titleTextField.centerY(inView: self)
        titleTextField.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        
        addSubview(tagLabel)
        tagLabel.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        addSubview(tagSubTitle)
        tagSubTitle.centerY(inView: self)
        tagSubTitle.anchor(right: rightAnchor, paddingRight: 40)
        
        addSubview(repeatLabel)
        repeatLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        dayFilter.delegate = self
        contentView.addSubview(dayFilter)
        dayFilter.anchor(top: repeatLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,  paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 40)
        
        addSubview(colorLabel)
        colorLabel.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        addSubview(colorSubTitle)
        colorSubTitle.centerY(inView: self)
        colorSubTitle.anchor(right: rightAnchor, paddingRight: 40)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.textDidChangeHandle(textField)
    }
    
    // MARK: - Helpers
    func configureUI() {
        guard let viewModel = viewModel else {
            return
        }
        
        titleTextField.isHidden = !viewModel.isTitleField
        if viewModel.isTitleField { titleTextField.becomeFirstResponder() }
        titleTextField.text = viewModel.todo.title
        
        tagLabel.isHidden = !viewModel.isTagField
        tagSubTitle.isHidden = !viewModel.isTagField
        
        repeatLabel.isHidden = !viewModel.isRepeatDayField
        dayFilter.isHidden = !viewModel.isRepeatDayField
        dayFilter.repeatTypes = viewModel.repeatTypes
        
        colorLabel.isHidden = !viewModel.isColorField
        colorSubTitle.isHidden = !viewModel.isColorField
        
        selectionStyle = .none
        
        if viewModel.isTagField || viewModel.isColorField {
            selectionStyle = .default
            accessoryType = .disclosureIndicator
        }
        
        tagSubTitle.text = viewModel.tag.title
        colorSubTitle.textColor = UIColor(rgb: viewModel.todo.textColor)
        
        colorSubTitle.text = "• \(viewModel.colorTypeDescription)"
    }
    
    func templateTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }
    
}

//MARK: TextField Delegate
extension AddTodoViewCell: UITextFieldDelegate {
    
    // text Field가 focusing 되었을 때 호출됨
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // print("DEBUG: textFieldDidBeginEditing is call")
    }
    
    // return 버튼을 눌렀을 때 호출됨
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("DEBUG: textFieldShouldReturn is call")
        textField.resignFirstResponder()
        return true
    }
    
    // first responder로서 끝나기 전에, 호출됨. 유효성 검사에 사용되는 함수
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //print("DEBUG: textFieldShouldEndEditing is call")
        return true
    }
    
    
    // TextField가 종료되었을 때 호출됨
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("DEBUG: textFieldDidEndEditing is call")
    }
}

extension AddTodoViewCell: DayFilterViewDelegate {
    func didSelectDayFilterView(repeatTypes: String) {
        delegate?.didSelectDayFilterView(repeatTypes: repeatTypes)
    }
    
    func didDeselectDayFilterview(repeatTypes: String) {
        delegate?.didDeselectDayFilterview(repeatTypes: repeatTypes)
    }
    
}
