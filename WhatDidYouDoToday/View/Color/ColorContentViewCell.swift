//
//  ColorContentViewCell.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//

import UIKit

class ColorContentViewCell: UICollectionViewCell {
    
    var viewModel: ColorViewModel? {
        didSet {
            configureUI()
        }
    }
    
    private lazy var colorView: UIImageView = {
        let iv = UIImageView()
        //iv.backgroundColor = .systemPurple
        iv.clipsToBounds = true
        iv.layer.cornerRadius = frame.width / 2
        return iv
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(colorView)
        colorView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        colorView.tintColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            configureUI()
        }
    }
    
    // MARK: -Selector
//    @objc func colorViewTapped() {
//    }
    
    // MARK: - Helper
    func configureUI() {
        guard let viewModel = viewModel else { return }
        let selectedColor = UIColor(rgb: viewModel.bgColor)
        
        colorView.backgroundColor = selectedColor
        colorView.image = viewModel.isSelected ? UIImage(named: "color_pick")?.withRenderingMode(.alwaysTemplate) : UIImage()
        
        colorView.tintColor = viewModel.isSelected ? selectedColor : .clear
        colorView.backgroundColor = viewModel.isSelected ? .white : selectedColor
        
    }
}
