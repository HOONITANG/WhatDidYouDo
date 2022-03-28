//
//  TodoSearchViewCell.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/22.
//


import UIKit

class TodoSearchViewCell: UITableViewCell {
    
    // MARK: - Properties
    var viewModel: TodoSearchViewModel? {
        didSet {
            configureUI()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let hourMinuteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let clockImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "event_clock")?.withRenderingMode(.alwaysTemplate)
        iv.setDimensions(width: 15, height: 15)
        iv.tintColor = .gray
        return iv
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let timeStackView = UIStackView(arrangedSubviews: [clockImageView, hourMinuteLabel])
        timeStackView.axis = .horizontal
        timeStackView.spacing = 8
        
        let horizontalStackView = UIStackView(arrangedSubviews: [periodLabel, timeStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalCentering
        horizontalStackView.spacing = 0
        
        let verticalStackView = UIStackView(arrangedSubviews: [titleLabel,horizontalStackView])
        verticalStackView.axis = .vertical
        
        addSubview(verticalStackView)
        verticalStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helper
    func configureUI() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        titleLabel.text = viewModel.title
        periodLabel.text = "\(viewModel.startDate) ~ \(viewModel.endDate)"
        hourMinuteLabel.text = "\(viewModel.hours) \(viewModel.minutes)"
    }
    
    // MARK: -Selector
    
    
}
