//
//  ColorHeaderView.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//

import UIKit

class ColorHeaderView: UIView {
    // MARK: - Properties
    
    var textColor: Int? {
        didSet {
            configureUI()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Todo Title"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let hourLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray3
        return label
    }()
    
    let moreImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "more_vertical")
        iv.setDimensions(width: 20, height: 20)
        return iv
    }()
    
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        backgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, hourLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 8
        labelStack.alignment = .leading
        
        let contentStack = UIStackView(arrangedSubviews: [labelStack, moreImageView])
        contentStack.axis = .horizontal
        contentStack.spacing = 16
        contentStack.alignment = .center
        
        addSubview(contentStack)
        contentStack.anchor(top:backgroundView.topAnchor, left: backgroundView.leftAnchor, right: backgroundView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        
        addSubview(underLineView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Helper
    func configureUI() {
        guard let textColor = textColor else { return }
        titleLabel.textColor = UIColor(rgb: textColor)
    }
    
}
