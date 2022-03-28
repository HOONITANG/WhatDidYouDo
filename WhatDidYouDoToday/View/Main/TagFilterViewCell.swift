//
//  TagTabViewCell.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import Foundation

import UIKit

class TagFilterViewCell: UICollectionViewCell {
    // MARK: - Properties
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Test Filter"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
            titleLabel.textColor = isSelected ? .black: .systemGray
            underlineView.isHidden = !isSelected
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, height: 2)
        //underlineView.anchor(bottom: bottomAnchor, paddingBottom: 0, width: frame.width, height: 2)
        underlineView.centerX(inView: self)
        underlineView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

