//
//  ActionSheetCell.swift
//
//  Created by Taehoon Kim on 2022/01/17.
//

import UIKit

class ActionSheetCell: UITableViewCell {

    // MARK: - Properties
    var option: TodoType? {
        didSet {
            configure()
        }
    }
    var isActive: Bool = true
    
    private let optionImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Test Option"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left: leftAnchor, paddingLeft: 20)
        optionImageView.setDimensions(width: 24, height: 24)

        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImageView.rightAnchor, paddingLeft: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let option = option else {
            return
        }
        titleLabel.text = option.description
        optionImageView.image = UIImage(named: option.imageName)?.withRenderingMode(.alwaysTemplate)
        
        titleLabel.textColor = isActive ? .black : .lightGray
        optionImageView.tintColor = isActive ? .black : .lightGray
        
        if option == .delete {
            titleLabel.textColor = .red
            optionImageView.tintColor = .red
        }
    }
}
