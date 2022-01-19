//
//  MiniPlayerView.swift
//  Radio
//
//  Created by Andrii on 08.01.2022.
//

import UIKit

protocol MiniPlayerViewDelegate: AnyObject {
    func play()
    func pause()
    func share()
    func showPlayer(station: Station)
}

class MiniPlayerView: UIView {
    
    weak var delegate: MiniPlayerViewDelegate?
    
    func setup(state: AudioPlayerState) {
        if state == .playing {
            playButton.isSelected = true
        } else {
            playButton.isSelected = false
        }
    }
    
    
    func setup(station: Station) {
        self.station = station
        
        if let url = URL(string: station.imageUrl) {
            stationImageView.af.setImage(withURL: url)
        }
        
        titleLabel.text = station.title
        artistLabel.text = station.subtitle
    }
    
    private var station: Station!
    
    private var containerView = UIView()
    
    private lazy var stationImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .black
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.font = .systemFont(ofSize: 12, weight: .bold)
        view.textColor = .white
        return view
    }()
    
    private lazy var artistLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.font = .systemFont(ofSize: 10)
        view.textColor = .white
        return view
    }()
    
    private var shareButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "share"), for: .normal)
        return view
    }()
    
    private var playButton: UIButton = {
        let view = UIButton()
        view.imageView?.tintColor = .white
        view.setImage(UIImage(systemName: "pause.fill"), for: .selected)
        view.setImage(UIImage(systemName: "play.fill"), for: .normal)
        view.addTarget(self, action: #selector(playAction(_:)), for: .touchUpInside)
        return view
    }()
    
    private var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout() {
        addSubview(visualEffectView)
        visualEffectView.edgesToSuperview()
        
        addSubview(containerView)
        containerView.height(80)
        containerView.topToSuperview()
        containerView.leftToSuperview()
        containerView.rightToSuperview()
        
        containerView.addSubview(playButton)
        playButton.height(40)
        playButton.width(40)
        playButton.topToSuperview(offset: 10)
        playButton.leftToSuperview(offset: 10)
        
        containerView.addSubview(stationImageView)
        stationImageView.height(40)
        stationImageView.width(to: containerView, multiplier: 0.2)
        stationImageView.centerY(to: playButton)
        stationImageView.leftToRight(of: playButton, offset: 10)
        
        containerView.addSubview(titleLabel)
        titleLabel.top(to: stationImageView)
        titleLabel.leftToRight(of: stationImageView, offset: 10)
        titleLabel.rightToSuperview(offset: -60)
        
        containerView.addSubview(artistLabel)
        artistLabel.topToBottom(of:         titleLabel, offset: 4)
        artistLabel.bottomToSuperview(offset: -8, relation: .equalOrLess)
        artistLabel.left(to: titleLabel)
        artistLabel.right(to: titleLabel)
        
        containerView.addSubview(shareButton)
        shareButton.centerY(to: playButton)
        shareButton.rightToSuperview(offset: -20)
    }
    
    //MARK: - Actions
    @objc func tapAction() {
        delegate?.showPlayer(station: station)
    }
    
    @objc func playAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.play()
        } else {
            delegate?.pause()
        }
    }
}
