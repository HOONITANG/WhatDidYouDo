//
//  DailyPieTableView.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/21.
//

import UIKit

class DailyPieTableViewCell: UITableViewCell {
    
    var viewModel: PieEventViewModel? {
        didSet {
            configureUI()
        }
    }
    
    // 왼쪽 사이드에 표현 될 뷰, pieChart의 색과 동일해야함.
    private var leftAccessoryView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 4).isActive = true
        view.layer.cornerRadius = 2
        view.backgroundColor = .systemPink
        return view
    }()
    
    // Event의 제목 Label
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    // Event의 시간 label
    private var hourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, hourLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 8
        labelStackView.alignment = .leading
        
        let accessoryStackView = UIStackView(arrangedSubviews: [leftAccessoryView, labelStackView])
        accessoryStackView.axis = .horizontal
        accessoryStackView.spacing = 12
        labelStackView.alignment = .leading
        
        addSubview(accessoryStackView)
        
        accessoryStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 16, paddingRight: 0)
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helper
    func configureUI() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.label
        leftAccessoryView.backgroundColor = viewModel.backgroundColor
        hourLabel.text = viewModel.durationTime
    }
    
    // MARK: -Selector
    
    
}
