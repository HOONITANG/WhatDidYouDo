//
//  TodoCollectionViewCell.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import UIKit

protocol TodoCollectionViewCellDelegate: class {
    func moreImageViewTapped(viewModel: TodoViewModel)
    func statusImageViewTapped(viewModel: TodoViewModel)
}

class TodoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    weak var delegate: TodoCollectionViewCellDelegate?
    
    //timer 1초마다 cell의 시간을 업데이트 시킨다.
    lazy var timer = TimerHelper { (seconds) in
        guard let viewModel = self.viewModel else { return }
        // print("timer 동작중")
        self.hourLabel.text = viewModel.timeStamp
    }
    
    var viewModel: TodoViewModel? {
        didSet {
            configureUI()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "운동하기"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let hourLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray3
        return label
    }()
    
    private lazy var moreImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image =  UIImage(named: "more_vertical")?.withRenderingMode(.alwaysTemplate)
        iv.setDimensions(width:30, height: 30)
        let tap = UITapGestureRecognizer(target: self, action: #selector(moreImageViewTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private lazy var statusImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width:30, height: 30)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(statusImageViewTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel])
        labelStack.axis = .horizontal
        labelStack.spacing = 8
        labelStack.alignment = .center
        
        let imageStack = UIStackView(arrangedSubviews: [statusImageView, moreImageView])
        imageStack.axis = .horizontal
        imageStack.spacing = 8
        imageStack.alignment = .leading
        
        let imageLabelStack = UIStackView(arrangedSubviews: [labelStack, imageStack])
        imageLabelStack.axis = .horizontal
        imageLabelStack.spacing = 16
        imageLabelStack.alignment = .center
        
        let contentStack = UIStackView(arrangedSubviews: [imageLabelStack, hourLabel])
        contentStack.axis = .vertical
        contentStack.spacing = 4
        
        addSubview(contentStack)
        contentStack.anchor(top:topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        
        
        addSubview(underLineView)
        
        underLineView.anchor(top: contentStack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 6, paddingLeft: 16, paddingBottom: 6, paddingRight: 16)
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        underLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureUI() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.textColor
        statusImageView.image = viewModel.statusImage
        titleLabel.attributedText = viewModel.attributeString
        
        if viewModel.isStart {
            titleLabel.textColor = UIColor.white
            backgroundColor = viewModel.textColor
            statusImageView.tintColor = .white
            moreImageView.tintColor = .white
        } else {
            backgroundColor = .white
            statusImageView.tintColor = .black
            moreImageView.tintColor = .black
        }
        
        // 화면이 새로고침 될 때 마다 계산해서 넣어야함
        // 1분마다 -> 시작중인 event의 endDate를 현재 시간으로 수정
        // 종료를 누르면 해당 endDate를 db에 저장
        // 종료 시 tagTodo allHour 업데이트 해줌
        
        // 1분마다 시작중인 event endDate를 더하고,
        // 그전에 행했던 event도 같이 더해야함(DB에 저장된 event) + 시작중인 event
        
        // 1. 시작중인 tagTodo에 해당하는 시작하는 event의 startDate를 얻음.
        // 2. 현재시간과 startDate를 뺀 시간을 넣음
    
        if viewModel.isToday {
            if viewModel.isStart {
                timer.start()
            } else {
                timer.stop()
            }
        }
        // 하루지났을 때 tagTodo.Type을 종료해주지만
        // 혹시라도 실행되어있을까봐 넣어준 로직.
        // 날짜가 지났을 경우 Stop
        else {
            timer.stop()
        }
        hourLabel.text = viewModel.timeStamp
    }
   
    // MARK: - Selector
    @objc func moreImageViewTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.moreImageViewTapped(viewModel: viewModel)
    }
    @objc func statusImageViewTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.statusImageViewTapped(viewModel: viewModel)
    }
}
