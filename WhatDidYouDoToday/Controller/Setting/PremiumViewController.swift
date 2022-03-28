//
//  PremiumViewController.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/23.
//

import UIKit
import StoreKit
private let reuseIdentifier = "PremiumViewCell"
private let headerIdentifier = "PremiumViewHeader"
private let footerIdentifier = "PremiumViewFooter"

class PremiumViewController: UICollectionViewController {
    // MARK: - Properties
    var products:[SKProduct] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .red
        configureUI()
        initIAP()
    }
    
    // MARK: - Selector
    
    // MARK: - Helpers
    func configureUI() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        collectionView.backgroundColor = .white
        
        collectionView.register(PremiumViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.register(PremiumViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        collectionView.register(PremiumViewFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
    }
}


// MARK: - UICollectionViewDataSource

extension PremiumViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PremiumOption.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PremiumViewCell
        
        guard let option = PremiumOption(rawValue: indexPath.row) else {
            return cell
        }
        
        cell.viewModel = PremiumViewModel(option: option)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! PremiumViewHeader
            
            return header
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! PremiumViewFooter
            footerView.delegate = self
            return footerView
            
        default:
            assert(false, "Unexpected element kind")
            return UIView() as! UICollectionReusableView
        }
        
        
    }
}

// MARK: - UICollectionViewDelegate

extension PremiumViewController {
    
    // CollectionView을 선택 했을 때
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PremiumViewController: UICollectionViewDelegateFlowLayout {
    
    // 위 아래 간격 -> Horizontal일 땐 옆간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 34
    }
    
    // 옆간격 -> Horizontal일 땐 위 아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 34
    }
    
    // header Size, item과 header사이의 여백을 생각해서 높이를 지정해준다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let height: CGFloat = 320
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let height: CGFloat = 160
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    // cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: view.frame.width, height: 40)
    }
}


// MARK: IAP
extension PremiumViewController {
    private func initIAP() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleIAPPurchase(_:)), name: .IAPHelperPurchaseNotification, object: nil)
        
        // IAP 불러오기
        InAppProducts.store.requestProducts { [weak self] (success, products) in
            guard let self = self, success else { return }
            if success {
                self.products = products!
            }
        }
    }
}

// MARK: PremiumViewFooterDelegate
extension PremiumViewController: PremiumViewFooterDelegate {
    
    // 인앱 결제 버튼 눌렀을 때
    func handlePuchaseButtonTapped() {
        if let product = products.first {
            InAppProducts.store.buyProduct(product) // 구매하기
        }
        
    }
    
    // 구매복원 버튼 클릭 시 동작하는 메서드
    func handleRestoreButtonTapped() {
        InAppProducts.store.restorePurchases()
    }
    
    // 결제 후 Notification을 받아 처리
       @objc func handleIAPPurchase(_ notification: Notification) {
           guard let success = notification.object as? Bool else { return }
           
           if success {
            // 구매성공 Alert
                print("구매 성공")
               DispatchQueue.main.async {
                AlertHelper.showAlert(title: I18NStrings.Alert.purchaseNotice, message: I18NStrings.Alert.purchaseSuccess, type: .basic, over: self, handler: nil)
               }

           } else {
            // 구매실패 Alert
            print("구매 실패")
               DispatchQueue.main.async {
                AlertHelper.showAlert(title: I18NStrings.Alert.purchaseNotice, message: I18NStrings.Alert.purchaseFailed, type: .basic, over: self, handler: nil)
               }
           }
       }
}
