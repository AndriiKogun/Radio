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

class ViewController: UIViewController {

    let player = AVPlayer()
    var playerLayer: AVPlayerLayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let asset = AVAsset(url: URL(string: "https://online.hitfm.ua/HitFM")!)
        
        let playerItem = AVPlayerItem(asset: asset)
        
        player.replaceCurrentItem(with: playerItem)
        
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        playerLayer.videoGravity = .resizeAspect
        
        view.layer.addSublayer(playerLayer)
        player.play()
    }
    
//

}

