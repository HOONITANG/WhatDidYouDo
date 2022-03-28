//
//  PremiumViewCell.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/23.
//

import UIKit

class PremiumViewCell: UICollectionViewCell {

    // MARK: - Properties
    var viewModel: PremiumViewModel? {
        didSet {
            configureUI()
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "premium_add_tag"))
        iv.setDimensions(width: 40, height: 40)
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let subLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, subLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.spacing = 8
        
        let imageStack = UIStackView(arrangedSubviews: [imageView, labelStack])
        imageStack.axis = .horizontal
        imageStack.alignment = .center
        imageStack.spacing = 16

        addSubview(imageStack)
        imageStack.centerY(inView: self)
        imageStack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 50, paddingRight: 50)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    func configureUI() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
        subLabel.text = viewModel.description
    }
}
