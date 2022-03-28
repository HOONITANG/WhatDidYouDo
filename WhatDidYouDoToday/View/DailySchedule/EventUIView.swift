//
//  EventUIView.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/15.
//

import UIKit

class EventUIView: UIView {
    //MARK: - Properties
    
    var viewModel: EventViewModel? {
        didSet {
            configureUI()
        }
    }
    
//    private let clockImageView: UIImageView = {
//        let iv = UIImageView(image: UIImage(named: "event_clock"))
//        iv.setDimensions(width: 12, height: 12)
//        iv.contentMode = .scaleAspectFit
//
//        return iv
//    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "치과 진료"
        return label
    }()
    
//    private var timeLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textColor = .black
//        label.text = "1.1hours"
//        return label
//    }()
    
//    private lazy var hourStackView: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [clockImageView, timeLabel])
//        stack.axis = .horizontal
//        stack.spacing = 8
//
//        return stack
//    }()
    
//    private lazy var titleStack: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [titleLabel, hourStackView])
//        stack.axis = .vertical
//        stack.spacing = 20
//
//        return stack
//    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    private let verticalLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .black
        return view
    }()
    
    private let backgroundView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundView)
        backgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4)
        
        backgroundView.addSubview(verticalLine)
        
        verticalLine.anchor(top: backgroundView.topAnchor, left: backgroundView.leftAnchor, bottom: backgroundView.bottomAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4)
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.widthAnchor.constraint(equalToConstant: 4).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [timeLabel, titleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        
        backgroundView.addSubview(stack)
   
        stack.anchor(top: backgroundView.topAnchor, left: verticalLine.rightAnchor, right: backgroundView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingRight: 4)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0).isActive = true
//        stack.leftAnchor.constraint(lessThanOrEqualTo: verticalLine.rightAnchor, constant: 4).isActive = true
//        stack.rightAnchor.constraint(lessThanOrEqualTo: backgroundView.rightAnchor, constant: 4).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Helper
    func configureUI() {
        guard let viewModel = viewModel else { return }
        

        // eventUIInfo.height * rowHeight
//        if viewModel.eventUIInfo.height * K.EventRowHeight < 25 {
//            titleLabel.isHidden = true
//        }
        // 사용자가 설정한 Todo Title 색
        let color = UIColor(rgb: viewModel.todo?.textColor ?? 0)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let startDate = formatter.string(from: viewModel.startTimestamp)
        let endDate = formatter.string(from: viewModel.endTimestamp)
        
        timeLabel.text = viewModel.stats ==  TodoType.Start ? "\(startDate) ~ " : "\(startDate) - \(endDate)"
        titleLabel.text = "\(viewModel.title)"
        
        if viewModel.stats == .Start && viewModel.isActiveEvent  {
            verticalLine.backgroundColor = color
            backgroundView.backgroundColor = color.withAlphaComponent(0.1)
        } else {
            let color = UIColor(rgb: viewModel.todo?.textColor ?? 0)
            backgroundView.backgroundColor = .clear
            backgroundView.backgroundColor = .white
            verticalLine.backgroundColor = color
        }
    }
    
    // MARK: - Selector
    
    
}
