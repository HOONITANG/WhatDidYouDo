//
//  TagTabView.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import UIKit

private let reuseIdentifier = "TagFilterViewCell"

protocol TagTabViewDelegate: class {
    func didSelectTagItem(tag: Tag)
    func tagDetailImageTapped()
}

class TagFilterView: UIView {
    
    // MARK - Properties
    weak var delegate: TagTabViewDelegate?
    
    var viewModel: MainViewModel? {
        didSet {
            collectionView.reloadData()
            configureUI()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    
    private lazy var tagDetailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 25, height: 25)
        iv.backgroundColor = .white
        iv.image = UIImage(systemName: "tag")
        iv.tintColor = .black
        //iv.image = UIImage(named: "more_vertical")
        let tap = UITapGestureRecognizer(target: self, action: #selector(tagDetailImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    // MARK - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(TagFilterViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        addSubview(tagDetailImageView)
        tagDetailImageView.anchor(left: collectionView.rightAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        tagDetailImageView.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    
    @objc func tagDetailImageTapped() {
        delegate?.tagDetailImageTapped()
    }
    
    // MARK: - Helper
    func configureUI() {
        
        guard let viewModel = viewModel, let tags = viewModel.tags else {
            // 기본 값 설정
            let selectedIndexPath = IndexPath(row: 0, section: 0)
            collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .init())
            return
        }
        
        // 선택한 Tag기준으로 collectionView의 cell을 선택함.
        if let index = tags.firstIndex(where: { $0 == viewModel.selectTag }) {
           
            let selectedIndexPath = IndexPath(row: index, section: 0)
            collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .init())
        }
    }
}
    

// MARK: UICollectionViewDataSource
extension TagFilterView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel, let tags = viewModel.tags else {
            return 0
        }

        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TagFilterViewCell
        guard let viewModel = viewModel, let tags = viewModel.tags else {
            return cell
        }
        
        let isStart = tags[indexPath.row].isStart
        let title = isStart ? tags[indexPath.row].title + " ▶︎" : tags[indexPath.row].title
        
        cell.titleLabel.text = title
        
        return cell
        
    }
}


// MARK: UICollectionViewDelegate
extension TagFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        guard let viewModel = viewModel, let tags = viewModel.tags else {
            return
        }
        
        let tag = tags[indexPath.row]
        delegate?.didSelectTagItem(tag: tag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TagFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        guard let viewModel = viewModel, let tags = viewModel.tags else {
            return CGSize(width: 0, height: 0)
        }
        
        let text = tags[indexPath.row].title
        return CGSize(width: viewModel.tagWidthSize(text).width + 40, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



