//
//  NoticeViewCell.swift
//  TimeTodoPlanner
//
//  Created by Taehoon Kim on 2022/01/25.
//

import UIKit

class NoticeViewCell: UITableViewCell {

    // MARK: - Properties
    var viewModel: NoticeViewModel? {
        didSet {
            configureUI()
        }
    }
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "ios 2.7.1 수정내용"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let contentLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = "- 일본어를 지원합니다. \n- 성능개선 "
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.text = "2021.10.12"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(dateLabel)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        contentLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        dateLabel.anchor(top: contentLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 20, paddingRight: 16)
        
        
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

        titleLabel.text = viewModel.title
        contentLabel.text = viewModel.content
        dateLabel.text = viewModel.date
    }
}
