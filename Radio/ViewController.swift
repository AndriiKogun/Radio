//
//  ViewController.swift
//  Radio
//
//  Created by Andrii on 12.12.2021.
//

import UIKit
import AVFoundation
import ShazamKit
import ShazamKit.SHSignatureGenerator
import TinyConstraints

class ViewController: UIViewController {
    
    private lazy var artistNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        return view
    }()
    
    private lazy var trackNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.textColor = .white
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.textColor = .white
        return view
    }()
    
    let track: Track
    
    init(track: Track) {
        self.track = track
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let player = AVPlayer()
    var playerLayer: AVPlayerLayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        view.backgroundColor = .gray
        
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateLabel.text = formatter.string(from: track.updatedDate)

        
//
//
//        let asset = AVAsset(url: URL(string: "https://online.hitfm.ua/HitFM")!)
//
//        let playerItem = AVPlayerItem(asset: asset)
//
//        player.replaceCurrentItem(with: playerItem)
//
//
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = view.frame
//        playerLayer.videoGravity = .resizeAspect
//
//        view.layer.addSublayer(playerLayer)
//        player.play()
    }

    
    private func setupLayout() {
        view.addSubview(trackNameLabel)
        trackNameLabel.topToSuperview(offset: 80)
        trackNameLabel.centerXToSuperview()
        
        view.addSubview(artistNameLabel)
        artistNameLabel.topToBottom(of: trackNameLabel, offset: 20)
        artistNameLabel.centerXToSuperview()
        
        view.addSubview(dateLabel)
        dateLabel.topToBottom(of: artistNameLabel, offset: 40)
        dateLabel.centerXToSuperview()
    }
}

