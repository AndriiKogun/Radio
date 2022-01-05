//
//  StationCell.swift
//  Radio
//
//  Created by Andrii on 05.01.2022.
//

import UIKit

class StationCell: UICollectionViewCell {
    
    var stationImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        view.font = .systemFont(ofSize: 14)
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
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
        contentView.addSubview(stationImageView)
        stationImageView.height(40)
        stationImageView.topToSuperview()
        stationImageView.leftToSuperview()
        stationImageView.rightToSuperview()

        contentView.addSubview(titleLabel)
        titleLabel.topToBottom(of: stationImageView, offset: 4)
        titleLabel.bottomToSuperview(offset: -4)
        titleLabel.leftToSuperview(offset: 4)
        titleLabel.rightToSuperview(offset: -4)
    }
}
