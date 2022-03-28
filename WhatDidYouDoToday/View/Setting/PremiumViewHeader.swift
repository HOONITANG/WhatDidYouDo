//
//  PremiumViewHeader.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/23.
//

import UIKit

class PremiumViewHeader: UICollectionReusableView {
    // MARK: - Lifecycle
    
    private let premiumImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "premium_buy"))
        iv.setDimensions(width: 180, height: 180)
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = I18NStrings.Setting.premiumBenefits
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let subLabel: UILabel = {
       let label = UILabel()
        label.text = I18NStrings.Setting.premiumDescription
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, subLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .center
        labelStack.spacing = 6
        
        let imageStack = UIStackView(arrangedSubviews: [premiumImageView, labelStack])
        imageStack.axis = .vertical
        imageStack.spacing = 20

        addSubview(imageStack)
        imageStack.centerX(inView: self)
        imageStack.anchor(top:topAnchor, paddingTop: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
