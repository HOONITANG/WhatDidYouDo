//
//  TagHeaderView.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//

import UIKit

protocol TagHeaderViewDelegate: class {
    func textFieldReturnHandler(_ textField: UITextField)
}

class TagHeaderView: UIView {
    // MARK: - Properties
    
    weak var delegate: TagHeaderViewDelegate?
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .black
        tf.textAlignment = .left
        tf.placeholder = I18NStrings.Tag.tagPlaceholder
        tf.delegate = self
        return tf
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let headerLabel: UILabel = {
       let label = UILabel()
        label.text = "Tag List"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    // MARK: - Lifecycle
    init(type: TagOpenType) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(backgroundView)
        
        backgroundView.anchor( top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 16, paddingRight: 16)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addSubview(textField)
        textField.anchor(top: backgroundView.topAnchor, left: backgroundView.leftAnchor, bottom: backgroundView.bottomAnchor, right: backgroundView.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12)
        
        addSubview(headerLabel)
        headerLabel.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 16, paddingBottom: 12)
        
        addSubview(underlineView)
        underlineView.anchor( left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 0.5)
        
        // Tag add 일경우 키보드 focus
        if type == .set { textField.becomeFirstResponder() }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension TagHeaderView: UITextFieldDelegate {
    // text Field가 focusing 되었을 때 호출됨
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // print("DEBUG: textFieldDidBeginEditing is call")
    }
    
    // return 버튼을 눌렀을 때 호출됨
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldReturnHandler(textField)
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
        textField.text = ""
        //print("DEBUG: textFieldDidEndEditing is call")
    }
}
