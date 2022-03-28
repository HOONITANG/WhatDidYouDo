//
//  DailyViewCell.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/15.
//

import UIKit

class DailyViewCell: UITableViewCell {
    
    var hour: Int = 0{
        didSet {
            let hourStr = String(hour)
            hourLabel.text = hour < 12 ? hourStr+" am": hourStr+" pm"
        }
    }
    
    var hourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 44).isActive = true
        label.textAlignment = .center
        return label
    }()
    
    private var verticalGrayLine: UIView = {
        let uv = UIView()
        uv.backgroundColor = .systemGray4
        uv.translatesAutoresizingMaskIntoConstraints = false
        uv.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return uv
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        selectionStyle = .none
        addSubview(hourLabel)
        hourLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 0, paddingLeft: 8)
        
        addSubview(verticalGrayLine)
        verticalGrayLine.anchor(top: topAnchor, left: hourLabel.rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0)
        
        
    }
    
}
