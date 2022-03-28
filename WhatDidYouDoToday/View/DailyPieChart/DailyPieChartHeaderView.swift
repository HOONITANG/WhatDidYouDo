//
//  DailyPieChartHeaderView.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/21.
//

import UIKit

class DailyPieChartHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    var viewModel: DailyPieChartViewModel? {
        didSet {
            configureUI()
        }
    }
    
    private let pieChartLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Daily Report"
        label.textColor = .black
        return label
    }()
    
    private let useTimeLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let remainTimeLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let dailyPieChartView = DailyPieChartView()
    
    // MARK: LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dailyPieChartView.setNeedsLayout()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(pieChartLabel)
        pieChartLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dailyPieChartView)
        dailyPieChartView.anchor(top: pieChartLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 300)
        
        let timeLabelStackView = UIStackView(arrangedSubviews: [useTimeLabel, remainTimeLabel])
        timeLabelStackView.spacing = 4
        timeLabelStackView.axis = .vertical
        
        addSubview(timeLabelStackView)
        timeLabelStackView.anchor(top: dailyPieChartView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Helper
    func configureUI() {
        guard let viewModel = viewModel  else {
            return
        }
        dailyPieChartView.viewModel = viewModel.pieEventViewModels
        
        useTimeLabel.attributedText = viewModel.useAllHourAttribute
        remainTimeLabel.attributedText = viewModel.remainHourAttribute
        
    }
    
}
