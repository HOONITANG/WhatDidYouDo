//
//  ColorViewCell.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//

import UIKit

protocol ColorViewCellDelegate: class {
    func didSelectColor(viewModel: ColorViewModel)
}

class ColorViewCell: UITableViewCell {
    
    weak var delegate: ColorViewCellDelegate?
    
    // MARK: - Properties
    var viewModel: ColorViewModel? {
        didSet {
            configureUI()
        }
    }
    
    private let colorTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "기본"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let colorBackgroundView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var colorContentView = ColorContentView()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        colorContentView.delegate = self
        
        addSubview(colorTitleLabel)
        colorTitleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(colorBackgroundView)
        colorBackgroundView.anchor(top: colorTitleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: (frame.width / 5) + 40 )
        
       
        addSubview(colorContentView)
        colorContentView.centerY(inView: colorBackgroundView)
        colorContentView.anchor(left: colorBackgroundView.leftAnchor, right: colorBackgroundView.rightAnchor, paddingLeft: 16, paddingRight: 16, height: frame.width / 5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Helper
    func configureUI() {
        guard let viewModel = viewModel else { return }
        colorContentView.viewModel = viewModel
        let type = viewModel.type
        let selectedItem = viewModel.selectedItem
        
        colorTitleLabel.text = ColorViewModel(type: type, selectedItem: selectedItem).description
    }
}

extension ColorViewCell: ColorContentViewDelegate {
    func didSelectColor(viewModel: ColorViewModel) {
        delegate?.didSelectColor(viewModel: viewModel)
    }
}
