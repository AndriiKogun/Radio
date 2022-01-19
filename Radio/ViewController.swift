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
    
    private lazy var stationImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.alpha = 0
        return view
    }()
    
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
    
    private var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    private var playButton: UIButton = {
        let view = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)
        let playImage = UIImage(systemName: "play.fill", withConfiguration: configuration)
        let pauseImage = UIImage(systemName: "play.fill", withConfiguration: configuration)

        view.imageView?.tintColor = .white
        view.setImage(pauseImage, for: .selected)
        view.setImage(playImage, for: .normal)
        view.addTarget(self, action: #selector(playAction(_:)), for: .touchUpInside)
        return view
    }()
    
    var viewTranslation = CGPoint(x: 0, y: 0)

    var containerView = UIView()
    
    let station: Station
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        view.backgroundColor = .clear
        
        trackNameLabel.text = station.currentTrack?.trackName
        artistNameLabel.text = station.currentTrack?.artistName
        
        if let url = URL(string: station.imageUrl) {
            backgroundImageView.af.setImage(withURL: url)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateLabel.text = formatter.string(from: station.currentTrack?.updatedDate ?? Date())

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss))
        containerView.addGestureRecognizer(pan)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 1.2) {
            self.backgroundImageView.alpha = 1
        }
    }

    override func transition(from fromViewController: UIViewController, to toViewController: UIViewController, duration: TimeInterval, options: UIView.AnimationOptions = [], animations: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        
        print("11")
    }

    
    private func setupLayout() {
        view.addSubview(containerView)
        containerView.edgesToSuperview()
        
        containerView.addSubview(backgroundImageView)
        backgroundImageView.edgesToSuperview()
        
        containerView.addSubview(visualEffectView)
        visualEffectView.edgesToSuperview()
        
        containerView.addSubview(stationImageView)
        stationImageView.height(300)
        stationImageView.width(300)
        stationImageView.topToSuperview(offset: 200)
        stationImageView.centerXToSuperview()

        containerView.addSubview(trackNameLabel)
        trackNameLabel.topToBottom(of: stationImageView, offset: 20)
        trackNameLabel.leftToSuperview(offset: 20)
        trackNameLabel.rightToSuperview(offset: -20)

        containerView.addSubview(artistNameLabel)
        artistNameLabel.topToBottom(of: trackNameLabel, offset: 20)
        artistNameLabel.leftToSuperview(offset: 20)
        artistNameLabel.rightToSuperview(offset: -20)
        
        containerView.addSubview(dateLabel)
        dateLabel.topToBottom(of: artistNameLabel, offset: 40)
        dateLabel.leftToSuperview(offset: 20)
        dateLabel.rightToSuperview(offset: -20)

        containerView.addSubview(playButton)
        playButton.height(80)
        playButton.width(80)
        playButton.centerXToSuperview()
        playButton.topToBottom(of: dateLabel, offset: 20)

    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                if self.viewTranslation.y > 0 {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                }
            })
        case .ended:
              if viewTranslation.y < 200 {
                  UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                      self.view.transform = .identity
                  })
              } else {
                  dismiss(animated: true, completion: nil)
              }
        default:
            break
        }
    }
    
    @objc func playAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
//        if sender.isSelected {
//            delegate?.play()
//        } else {
//            delegate?.pause()
//        }
    }

}
