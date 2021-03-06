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
    
    // CollectionView??? ?????? ?????? ???
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension PremiumViewController: UICollectionViewDelegateFlowLayout {
    
    // ??? ?????? ?????? -> Horizontal??? ??? ?????????
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 34
    }
    
    // ????????? -> Horizontal??? ??? ??? ??????
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 34
    }
    
    // header Size, item??? header????????? ????????? ???????????? ????????? ???????????????.
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
        
        // IAP ????????????
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
    
    // ?????? ?????? ?????? ????????? ???
    func handlePuchaseButtonTapped() {
        if let product = products.first {
            InAppProducts.store.buyProduct(product) // ????????????
        }
        
    }
    
    // ???????????? ?????? ?????? ??? ???????????? ?????????
    func handleRestoreButtonTapped() {
        InAppProducts.store.restorePurchases()
    }
    
    // ?????? ??? Notification??? ?????? ??????
       @objc func handleIAPPurchase(_ notification: Notification) {
           guard let success = notification.object as? Bool else { return }
           
           if success {
            // ???????????? Alert
                print("?????? ??????")
               DispatchQueue.main.async {
                AlertHelper.showAlert(title: I18NStrings.Alert.purchaseNotice, message: I18NStrings.Alert.purchaseSuccess, type: .basic, over: self, handler: nil)
               }

           } else {
            // ???????????? Alert
            print("?????? ??????")
               DispatchQueue.main.async {
                AlertHelper.showAlert(title: I18NStrings.Alert.purchaseNotice, message: I18NStrings.Alert.purchaseFailed, type: .basic, over: self, handler: nil)
               }
           }
       }
}
