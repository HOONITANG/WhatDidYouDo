//
//  PremiumViewFooter.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/23.
//

import UIKit

protocol PremiumViewFooterDelegate: class {
    func handlePuchaseButtonTapped()
    func handleRestoreButtonTapped()
}

class PremiumViewFooter: UICollectionReusableView {
    // MARK: Properties
    weak var delegate:PremiumViewFooterDelegate?
    
    private lazy var purchaseButton: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 50 / 2
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let label = UILabel()
        label.text = I18NStrings.Setting.purchase
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        
        view.addSubview(label)
        label.center(inView: view)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePuchaseButtonTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var restoreButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = I18NStrings.Setting.purchaseHistoryRecovery
        view.addSubview(label)
        label.center(inView: view)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleRestoreButtonTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [purchaseButton, restoreButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        // stackView.contentMode = .scaleToFill
        
        addSubview(stackView)
        stackView.anchor(left:leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 24, paddingBottom: 16, paddingRight: 24)
        
//        addSubview(purchaseButton)
//        addSubview(restoreButton)
//
//        purchaseButton.anchor(top: topAnchor, left: leftAnchor,  right: rightAnchor, paddingTop: 16, paddingLeft: 16,  paddingRight: 16)
//
//        restoreButton.anchor(top: purchaseButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Selectors
    
    @objc func handlePuchaseButtonTapped() {
        delegate?.handlePuchaseButtonTapped()
    }
    
    @objc func handleRestoreButtonTapped() {
        delegate?.handleRestoreButtonTapped()
    }
}
