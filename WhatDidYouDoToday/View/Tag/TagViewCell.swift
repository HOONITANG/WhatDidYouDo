//
//  TagViewCell.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//

import UIKit

protocol TagViewCellDelegate: class {
    func handleDeleteImageTapped(selectedTag: Tag)
    func tagFieldChangeHandler(_ textField: UITextField, selectedTag: Tag)
    
}

class TagViewCell: UITableViewCell {
    // MARK: - Properties
    weak var delegate:TagViewCellDelegate?
    var viewModel: TagViewModel? {
        didSet {
            configureUI()
        }
    }
    var tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var tagTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textAlignment = .left
        tf.textColor = .black
        return tf
    }()
    
    private lazy var deleteImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "delete_button")
        iv.setDimensions(width: 24, height: 24)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDeleteImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let dragImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "drag_menu_button")
        iv.setDimensions(width: 24, height: 24)
        return iv
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(dragImageView)
        dragImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        
        contentView.addSubview(deleteImageView)
        deleteImageView.centerY(inView: self)
        deleteImageView.anchor(right: rightAnchor, paddingRight: 16)
        
        contentView.addSubview(tagTextField)
        tagTextField.anchor(top: topAnchor, left: dragImageView.rightAnchor, bottom: bottomAnchor, right: deleteImageView.leftAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16)
        tagTextField.delegate = self
        
        addSubview(tagLabel)
        tagLabel.anchor(top: topAnchor, left: dragImageView.rightAnchor, bottom: bottomAnchor, right: deleteImageView.leftAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func configureUI() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        tagLabel.isHidden = !viewModel.isSelectView
        tagLabel.text = viewModel.title
        
        tagTextField.isHidden = viewModel.isSelectView
        tagTextField.text = viewModel.title
    }
    
    
    //MARK: - Selector
    @objc func handleDeleteImageTapped() {
        
        guard let viewModel = self.viewModel, let tag = viewModel.tag  else {
            return
        }
        delegate?.handleDeleteImageTapped(selectedTag: tag)
    }
    
}


extension TagViewCell: UITextFieldDelegate {
    // text Field가 focusing 되었을 때 호출됨
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // print("DEBUG: textFieldDidBeginEditing is call")
    }
    
    // return 버튼을 눌렀을 때 호출됨
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let viewModel = self.viewModel, let tag = viewModel.tag else { return true }
        
        delegate?.tagFieldChangeHandler(textField, selectedTag: tag)
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
        //textField.text = ""
    }
}
