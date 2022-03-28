//
//  ColorContentView.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//

import UIKit

private let reuseIdentifier = "ColorContentViewCell"

protocol ColorContentViewDelegate: class {
    func didSelectColor(viewModel: ColorViewModel)
}

class ColorContentView : UIView {
    
    weak var delegate: ColorContentViewDelegate?

    var viewModel: ColorViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK - Properties
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(ColorContentViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        // viewModel의 값으로 기본 선택을 설정함.
//        let selectedIndexPath = IndexPath(row: 0, section: 0)
//        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)

        addSubview(collectionView)
        collectionView.backgroundColor =  .clear
        
        collectionView.addConstraintsToFillView(self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: UICollectionViewDataSource
extension ColorContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ColorContentViewCell
        guard var viewModel = viewModel else {
            return cell
        }
        // 보여질 color 설정
        viewModel.index = indexPath.row
        cell.viewModel = viewModel
        return cell
    }
}


// MARK: UICollectionViewDelegate
extension ColorContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard var viewModel = viewModel else {
            return
        }
        
        let selectedItem:[String:Any] = ["type": viewModel.type, "index": indexPath.row]
        viewModel.selectedItem = selectedItem
        
        delegate?.didSelectColor(viewModel: viewModel)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ColorContentView: UICollectionViewDelegateFlowLayout {
    
    // 위 아래 간격 -> Horizontal일 땐 옆간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // 옆간격 -> Horizontal일 땐 위 아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // cell 사이즈( 옆 라인을 고려하여 설정 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 5 - 8 ///  3등분하여 배치, 옆 간격이 8이므로 8을 빼줌

        let size = CGSize(width: width, height: width)
        return size
    }
}
