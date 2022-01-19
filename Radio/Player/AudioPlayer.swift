//
//  AudioPlayer.swift
//  Radio
//
//  Created by Andrii on 08.01.2022.
//

import AVKit
import MediaPlayer

enum AudioPlayerState: Int {
    case playing
    case paused
}

protocol AudioPlayerDelegate: AnyObject {
    func audioStream(isLoading: Bool)
    func playerDidChange(state: AudioPlayerState)
}

class AudioPlayer: NSObject {
    
    weak var delegate: AudioPlayerDelegate?
    
    let view: UIView
    let player = AVPlayer()
    var playerLayer: AVPlayerLayer!
    var asset: AVURLAsset?
    
    var station: Station?
    
    func play(station: Station?) {
        self.station = station
        
        guard let stream = station?.stream, let url = URL(string: stream) else { return }
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        addObserver(playerItem: playerItem)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        setupNowPlaying()
    }
    
    required init(view: UIView) {
        self.view = view
        super.init()
        
        setupPlayer()
        setupRemoteTransportControls()
    }
    
    private func addObserver(playerItem: AVPlayerItem) {
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty),
                               options: .new,
                               context: nil)
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp),
                               options: .new,
                               context: nil)
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferFull),
                               options: .new,
                               context: nil)
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.new, .initial],
                               context: nil)
    }
    
    private func setupPlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = .zero
        playerLayer.videoGravity = .resizeAspect
        
        view.layer.addSublayer(playerLayer)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is AVPlayerItem {
            switch keyPath {
                
            case #keyPath(AVPlayerItem.isPlaybackBufferEmpty):
                // Show loader
                self.delegate?.audioStream(isLoading: true)
                print("+++ The asset loading.")
                
            case #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp):
                // Hide loader
                print("+++ playbackLikelyToKeepUp")
                
                self.delegate?.audioStream(isLoading: false)
                
            case #keyPath(AVPlayerItem.isPlaybackBufferFull):
                // Hide loader
                print("+++ playbackBufferFull")
                
                self.delegate?.audioStream(isLoading: false)
                
            case #keyPath(AVPlayerItem.status):
                switch self.player.currentItem?.status {
                case .readyToPlay:
                    print("+++ play")
                    
                default:
                    break
                }
                
                
                //
                //                    let newStatus: AVPlayerItem.Status
                //                    if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                //                        newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue)!
                //                    } else {
                //                        newStatus = .unknown
                //                    }
                //                    if newStatus == .failed {
                //                        NSLog("SA Detected Error: \(String(describing: self.player.currentItem?.error?.localizedDescription)), error: \(String(describing: self.player.currentItem?.error))")
                //                    }
                //                case #keyPath(AVPlayer.status):
                //                    switch player.status {
                //                    case .readyToPlay:
                //                        player.play()
                //                        print("+++ play")
                //
                //                    default:
                //                        break
                //                    }
                //                    print()
                
            case .none:
                self.delegate?.audioStream(isLoading: false)
            case .some(_):
                self.delegate?.audioStream(isLoading: false)
            }
        }
    }
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.player.play()
                self.delegate?.playerDidChange(state: .playing)
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.player.pause()
                self.delegate?.playerDidChange(state: .paused)
                return .success
            }
            return .commandFailed
        }
    }
    
    func setupNowPlaying() {
        guard let station = station else { return }

        let imageView = UIImageView()
        var image: UIImage!
        if let url = URL(string: station.imageUrl) {
            imageView.af.setImage(withURL: url)
            image = imageView.image
        }

        let artwork = MPMediaItemArtwork(boundsSize: image.size) { size in
            return image
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                   MPNowPlayingInfoPropertyIsLiveStream: true,
                   MPMediaItemPropertyArtist: station.subtitle,
                   MPMediaItemPropertyTitle: station.title,
                   MPMediaItemPropertyArtwork: artwork
               ]
    }
}
