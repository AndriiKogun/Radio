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
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private var heartButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "heart_circle_fill_selected"), for: .selected)
        view.setImage(UIImage(named: "heart_circle_fill_unselected"), for: .normal)
        view.addTarget(self, action: #selector(heartAction(_:)), for: .touchUpInside)
        return view
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        view.font = .systemFont(ofSize: 12)
        view.textColor = .white
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stationImageView.image = nil
    }
    
    private func setupLayout() {
        contentView.addSubview(stationImageView)
        stationImageView.height(60)
        stationImageView.topToSuperview()
        stationImageView.leftToSuperview()
        stationImageView.rightToSuperview()
        
        contentView.addSubview(heartButton)
        heartButton.height(28)
        heartButton.width(28)
        heartButton.topToSuperview()
        heartButton.rightToSuperview()

        contentView.addSubview(titleLabel)
        titleLabel.topToBottom(of: stationImageView, offset: 4)
        titleLabel.bottomToSuperview(offset: -8)
        titleLabel.leftToSuperview(offset: 4)
        titleLabel.rightToSuperview(offset: -4)
    }
    
    //MARK: - Actions
    @objc func heartAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
    }
}
