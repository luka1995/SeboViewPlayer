//
//  SeboVideoPlayerViewController.swift
//  SeboVideoPlayerViewController
//
//  Created by Luka Penger on 25/10/2017.
//  Copyright © 2017 Luka Penger. All rights reserved.
//

import UIKit
import Player
import AFNetworking
import AVFoundation


// MARK: SeboVideoPlayerViewController

class SeboVideoPlayerViewController: UIViewController, PlayerDelegate, PlayerPlaybackDelegate {
    
    // MARK: Constants
    
    private let containersPadding: CGFloat = 20.0
    
    // MARK: Variables
    
    private var videoUrl: String?
    private var synchronisation: NSArray?
    
    private var mainContainerView: UIView!
    private var videoContainerView: UIView!
    private var player: Player!
    private var slidesView: SeboViewPlayerSlidesView!
    private var timelineView: SeboViewPlayerTimelineView!
    
    private var oldCurrentTime: NSInteger = -1
    
    // MARK: Init
    
    convenience init(videoUrl: String, synchronisation: NSArray) {
        self.init()
        
        self.videoUrl = videoUrl
        self.synchronisation = synchronisation
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Main contrainer
        
        self.mainContainerView = UIView()
        self.mainContainerView.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        self.view.addSubview(self.mainContainerView)
        
        // Slides container
        
        self.slidesView = SeboViewPlayerSlidesView().loadFromNib()
        self.mainContainerView.addSubview(self.slidesView)
        
        // Video container

        self.videoContainerView = UIView()
        self.videoContainerView.backgroundColor = UIColor.black
        self.mainContainerView.addSubview(self.videoContainerView)

        self.player = Player()
        self.player.autoplay = false
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        
        self.addChildViewController(self.player)
        self.videoContainerView.addSubview(self.player.view)
        self.player.didMove(toParentViewController: self)
        
        // Time container
        
        self.timelineView = SeboViewPlayerTimelineView().loadFromNib()
        self.mainContainerView.addSubview(self.timelineView)
        
        self.timelineView.sliderValueChanged = { (value) in
            DispatchQueue.main.async {
                self.player.seek(to: CMTime(value: CMTimeValue(value), timescale: CMTimeScale(1.0)))
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.play()
    }
    
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.updateOrientationViews()
    }
    
    // MARK: Methods
    
    private func updateOrientationViews() {
        self.mainContainerView.frame = CGRect(x: (self.view.safeAreaInsets.left + self.view.bounds.origin.x), y: (self.view.safeAreaInsets.top + self.view.bounds.origin.y), width: (self.view.bounds.size.width - (self.view.safeAreaInsets.left + self.view.safeAreaInsets.right)), height: (self.view.bounds.size.height - (self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom)))
        
        let timelineHeight = (self.mainContainerView.frame.size.height * 0.3)
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            print("Landscape")
            
            self.timelineView.frame = CGRect(x: 0.0, y: (self.mainContainerView.frame.size.height - timelineHeight), width: self.mainContainerView.frame.size.width, height: timelineHeight)
            
            self.videoContainerView.frame = CGRect(x: self.containersPadding, y: self.containersPadding, width: (((self.mainContainerView.frame.size.width - (self.containersPadding * 2)) - self.containersPadding) / 2), height: (self.mainContainerView.frame.size.height - timelineHeight - (self.containersPadding * 2)))
            
            self.slidesView.frame = CGRect(x: ((self.mainContainerView.frame.size.width / 2) + (self.containersPadding / 2)), y: self.containersPadding, width: (((self.mainContainerView.frame.size.width - (self.containersPadding * 2)) - self.containersPadding) / 2), height: (self.mainContainerView.frame.size.height - timelineHeight - (self.containersPadding * 2)))
        } else {
            print("Portrait")
            
            self.timelineView.frame = CGRect(x: 0.0, y: (self.mainContainerView.frame.size.height - timelineHeight), width: self.mainContainerView.frame.size.width, height: timelineHeight)
            
            self.videoContainerView.frame = CGRect(x: self.containersPadding, y: self.containersPadding, width: (self.mainContainerView.frame.size.width - (self.containersPadding * 2)), height: ((self.mainContainerView.frame.size.height - timelineHeight - (self.containersPadding * 3)) / 2))
            
            self.slidesView.frame = CGRect(x: self.containersPadding, y: (self.videoContainerView.frame.origin.y + self.videoContainerView.frame.size.height + self.containersPadding), width: (self.mainContainerView.frame.size.width - (self.containersPadding * 2)), height: ((self.mainContainerView.frame.size.height - timelineHeight - (self.containersPadding * 3)) / 2))
        }
        
        self.player.view.frame = self.videoContainerView.bounds
    }
    
    public func loadVideoWithSynchronisation(videoUrl: String, synchronisation: NSArray, loadingFinished: () -> Void) {
        self.videoUrl = videoUrl
        self.synchronisation = synchronisation
        self.oldCurrentTime = -1
        
        if self.player != nil {
            self.player.url = URL(string: self.videoUrl!)
            self.stop()
        }
        
        loadingFinished()
    }
    
    func play() {
        self.player.url = URL(string: self.videoUrl!)
        self.slidesView.setSlidesCount(value: 0, count: (self.synchronisation?.count)!)
        
        self.player.playFromCurrentTime()
    }
    
    func stop() {
        self.player.stop()
    }
    
    // MARK: PlayerDelegate
    
    func playerCurrentTimeDidChange(_ player: Player) {
        if self.oldCurrentTime != NSInteger(player.currentTime) {
            self.oldCurrentTime = NSInteger(player.currentTime)
            
            for i in 0..<(self.synchronisation?.count)! {
                let object = self.synchronisation![i] as! NSDictionary
                let time = object.object(forKey: "time") as! NSInteger
                
                if time == self.oldCurrentTime {
                    let stringUrl = object.object(forKey: "uri") as? String
                    
                    self.slidesView.imageView.setImageWith(URL(string: stringUrl!)!)
                    self.slidesView.setSlidesCount(value: (i + 1), count: (self.synchronisation?.count)!)
                }
            }
            
            if self.timelineView.slider.state == UIControlState.normal {
                self.timelineView.slider.value = Float(player.currentTime)
            }
        }
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerReady(_ player: Player) {
        self.timelineView.slider.minimumValue = 0
        self.timelineView.slider.maximumValue = Float(self.player.maximumDuration)
        
        let markPositions = self.synchronisation!.map({ (object) -> (Float) in
            let time = (object as! NSDictionary).object(forKey: "time") as! Float
            
            return (100 / (self.timelineView.slider.maximumValue / time))
        })
        self.timelineView.slider.markPositions = markPositions
        self.timelineView.slider.setNeedsDisplay()
        
        self.slidesView.setSlidesCount(value: 0, count: (self.synchronisation?.count)!)
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
}
