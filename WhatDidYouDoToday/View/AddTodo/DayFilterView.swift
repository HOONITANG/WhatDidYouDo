//
//  DayFilterView.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/12.
//

import UIKit

private let reuseIdentifier = "DayFilterViewCell"
protocol DayFilterViewDelegate: class {
    func didSelectDayFilterView(repeatTypes: String)
    func didDeselectDayFilterview(repeatTypes: String)
}
class DayFilterView: UIView {

    // MARK - Properties
    weak var delegate: DayFilterViewDelegate?
    var selectedDay = [String]()
    var repeatTypes: String? {
        didSet {
            configureUI()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(DayFilterViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
     
        addSubview(collectionView)
        
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func configureUI() {
        let selectedArr = convertStringtoArray(str: repeatTypes!)
        // 선택 값 설정
        selectedArr.forEach { (index) in
            // index == nil, 아무런 날짜도 선택하지 않음
            guard let index = Int(index) else { return }
            
            let selectedIndexPath = IndexPath(row: index, section: 0)
            collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        }
    }
    
    
    func convertStringtoArray(str: String) -> [String] {
        let array = str.components(separatedBy: ",")
        return array
    }
    
    
}



// MARK: UICollectionViewDataSource
extension DayFilterView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DayFilterContents.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DayFilterViewCell
        guard let content = DayFilterContents(rawValue: indexPath.row) else {
            return cell
        }
        cell.viewModel = DayFilterViewModel(content: content)
        
        return cell
    }
}


// MARK: UICollectionViewDelegate
extension DayFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        guard let items = collectionView.indexPathsForSelectedItems else {
            return
        }
        // section 값을 제외하고, row값만을 배열로 저장함
        selectedDay = items.map { String($0[1]) }.sorted()
        let stringRepresentation = selectedDay.joined(separator: ",") // "1,2,3"
        delegate?.didSelectDayFilterView(repeatTypes: stringRepresentation)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       
        guard let items = collectionView.indexPathsForSelectedItems else {
            return
        }
        // 제외된 후의 값들로 변경해줌
        selectedDay = items.map { String($0[1]) }.sorted()
        //        selectedDay = items.map { (indexPath) -> Int in
        //            return indexPath[1]
        //        }
        
        let stringRepresentation = selectedDay.joined(separator: ",") // "1,2,3"
        delegate?.didSelectDayFilterView(repeatTypes: stringRepresentation)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension DayFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count = CGFloat(DayFilterContents.allCases.count)
        var size = CGFloat(frame.width / count)
    
        // 소숫점 제거
        let digit: Double = pow(10, 1)
        size = CGFloat(round(Double(size) * digit) / digit)
        
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
