//
//  DayFilterViewCell.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import UIKit

class DayFilterViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var viewModel: DayFilterViewModel? {
        didSet { configureUI() }
    }

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "월"
        return label
    }()
    
    private let dayView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            dayView.backgroundColor = isSelected ? .systemBlue : .systemGray6
            dayLabel.textColor = isSelected ? .white : .systemGray
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(dayView)
        dayView.addConstraintsToFillView(self)

        dayView.addSubview(dayLabel)
        dayLabel.center(inView: dayView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureUI() {
        guard let viewModel = viewModel else {
            return
        }
        dayLabel.text = viewModel.content.description
    }
   
    
}

