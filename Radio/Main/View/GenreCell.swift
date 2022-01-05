//
//  GenreCell.swift
//  Radio
//
//  Created by Andrii on 05.01.2022.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 14)
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        if highlighted {
//            backgroundColor = UIColor.gray.withAlphaComponent(0.2)
//        } else {
//            backgroundColor = .white
//        }
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        if selected {
//            backgroundColor = UIColor.gray.withAlphaComponent(0.2)
//        } else {
//            backgroundColor = .white
//        }
//    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.topToSuperview()
        titleLabel.bottomToSuperview()
        titleLabel.leftToSuperview(offset: 16)
        titleLabel.rightToSuperview(offset: -16)
    }
}
