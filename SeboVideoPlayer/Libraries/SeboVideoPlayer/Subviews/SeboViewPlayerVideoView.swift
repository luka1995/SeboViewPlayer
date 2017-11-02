//
//  SeboViewPlayerVideoView.swift
//  SeboVideoPlayer
//
//  Created by Luka Penger on 02/11/2017.
//  Copyright © 2017 Luka Penger. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


// MARK: Public enumerations

public enum PlayerFillMode {
    case resize
    case resizeAspectFill
    case resizeAspectFit // default
    
    public var avFoundationType: String {
        get {
            switch self {
            case .resize:
                return AVLayerVideoGravity.resize.rawValue
            case .resizeAspectFill:
                return AVLayerVideoGravity.resizeAspectFill.rawValue
            case .resizeAspectFit:
                return AVLayerVideoGravity.resizeAspect.rawValue
            }
        }
    }
}


// MARK: PlayerPlaybackDelegate

public protocol PlayerPlaybackDelegate: NSObjectProtocol {
    
    func playerCurrentTimeDidChange(currentTime: TimeInterval, maximumDuration: TimeInterval)
    
    func playerPlaybackWillStartFromBeginning()
    
    func playerPlaybackWillStart()
    
    func playerPlaybackWillEnd()
    
}


// MARK: SeboViewPlayerVideoView

class SeboViewPlayerVideoView: UIView {
    
    // MARK: Constants
    
    private let PlayerRateKey = "rate"
    
    // MARK: Variables
    
    var url: URL? {
        didSet {
            setupUrl(url: url)
        }
    }
    
    var playerView = PlayerView()
    private var videoAsset: AVURLAsset?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?
    
    weak var delegate: PlayerPlaybackDelegate?
    
    var maximumDuration: TimeInterval {
        get {
            if let playerItem = self.playerItem {
                return CMTimeGetSeconds(playerItem.duration)
            } else {
                return CMTimeGetSeconds(kCMTimeIndefinite)
            }
        }
    }
    
    var currentTime: TimeInterval {
        get {
            if let playerItem = self.playerItem {
                return CMTimeGetSeconds(playerItem.currentTime())
            } else {
                return CMTimeGetSeconds(kCMTimeIndefinite)
            }
        }
    }
    
    var muted: Bool? {
        get {
            return self.playerView.player?.isMuted
        }
        set {
            self.playerView.player?.isMuted = newValue!
        }
    }
    
    var volume: Float? {
        get {
            return self.playerView.player?.volume
        }
        set {
            self.playerView.player?.volume = newValue!
        }
    }
    
    // MARK: Init
    
    func loadFromNib() -> SeboViewPlayerVideoView {
        return UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SeboViewPlayerVideoView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addPlayerView()
    }
    
    deinit {
        self.removePlayerObservers()
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: View configuration
    
    private func addPlayerView() {
        self.playerView.frame = self.bounds
        self.playerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.playerView)
    }
    
    // MARK: Methods
    
    func play() {
        self.delegate?.playerPlaybackWillStart()
        
        self.playerView.player?.play()
    }
    
    func playFromBeginning() {
        self.delegate?.playerPlaybackWillStartFromBeginning()
        
        self.playerView.player?.seek(to: kCMTimeZero)
        self.playerView.player?.play()
    }
    
    func pause() {
        self.delegate?.playerPlaybackWillEnd()
        
        self.playerView.player?.pause()
    }
    
    private func setupUrl(url: URL?) {
        if url != nil {
            self.videoAsset = AVURLAsset(url: url!)
            self.playerItem = AVPlayerItem(asset: self.videoAsset!)
            let player = AVPlayer(playerItem: playerItem)
            
            self.playerView.player = player
            
            self.addPlayerObservers()
        }
    }
    
    // MARK: Player observers
    
    private func addPlayerObservers() {
        self.timeObserver = self.playerView.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 100), queue: DispatchQueue.main, using: { [weak self] timeInterval in
            self?.delegate?.playerCurrentTimeDidChange(currentTime: (self?.currentTime)!, maximumDuration: (self?.maximumDuration)!)
        })
    }
    
    private func removePlayerObservers() {
        if let observer = self.timeObserver {
            self.playerView.player?.removeTimeObserver(observer)
        }
    }

}


// MARK: PlayerView

class PlayerView: UIView {
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var fillMode: String {
        get {
            return self.playerLayer.videoGravity.rawValue
        }
        set {
            self.playerLayer.videoGravity = AVLayerVideoGravity(rawValue: newValue)
        }
    }
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.playerLayer.backgroundColor = UIColor.black.cgColor
        self.playerLayer.fillMode =  PlayerFillMode.resizeAspectFit.avFoundationType
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.player?.pause()
        self.player = nil
    }
    
}
