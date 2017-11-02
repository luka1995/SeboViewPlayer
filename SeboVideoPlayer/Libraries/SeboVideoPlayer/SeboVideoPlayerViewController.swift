//
//  SeboVideoPlayerViewController.swift
//  SeboVideoPlayerViewController
//
//  Created by Luka Penger on 25/10/2017.
//  Copyright © 2017 Luka Penger. All rights reserved.
//

import UIKit
import AFNetworking
import AVFoundation


// MARK: SeboVideoPlayerViewController

class SeboVideoPlayerViewController: UIViewController, PlayerPlaybackDelegate, TimelineDelegate {
    
    // MARK: Constants
    
    private let containersPadding: CGFloat = 20.0
    
    // MARK: Variables
    
    private var videoUrl: String!
    private var synchronisation: NSArray!
    
    private var mainContainerView: UIView!
    private var videoView: SeboViewPlayerVideoView!
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
        
        self.view.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        
        // Main contrainer
        
        self.mainContainerView = UIView()
        self.mainContainerView.backgroundColor = UIColor.clear
        self.view.addSubview(self.mainContainerView)
        
        // Slides container
        
        self.slidesView = SeboViewPlayerSlidesView().loadFromNib()
        self.mainContainerView.addSubview(self.slidesView)
        
        self.slidesView.setSlidesCount(value: 0, count: self.synchronisation.count)
        
        // Video container

        self.videoView = SeboViewPlayerVideoView().loadFromNib()
        self.videoView.delegate = self
        self.mainContainerView.addSubview(self.videoView)
        
        self.videoView.url = URL(string: self.videoUrl!)
        
        // Time container
        
        self.timelineView = SeboViewPlayerTimelineView().loadFromNib()
        self.timelineView.delegate = self
        self.mainContainerView.addSubview(self.timelineView)
        
        self.timelineView.synchronisation = self.synchronisation
        
        // Observers
        
        self.addApplicationObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.play()
    }
    
    deinit {
        self.removeApplicationObservers()
    }
    
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.updateOrientationViews()
    }
    
    // MARK: Methods
    
    private func updateOrientationViews() {
        self.mainContainerView.frame = CGRect(x: (self.view.safeAreaInsets.left + self.view.bounds.origin.x), y: (self.view.safeAreaInsets.top + self.view.bounds.origin.y), width: (self.view.bounds.size.width - (self.view.safeAreaInsets.left + self.view.safeAreaInsets.right)), height: (self.view.bounds.size.height - (self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom)))
        
        let timelineHeight = (self.mainContainerView.frame.size.height * 0.16)
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            self.timelineView.frame = CGRect(x: self.containersPadding, y: (self.mainContainerView.frame.size.height - timelineHeight - self.containersPadding), width: (self.mainContainerView.frame.size.width - (self.containersPadding * 2)), height: timelineHeight)
            
            self.videoView.frame = CGRect(x: self.containersPadding, y: self.containersPadding, width: (((self.mainContainerView.frame.size.width - (self.containersPadding * 2)) - self.containersPadding) / 2), height: (self.mainContainerView.frame.size.height - timelineHeight - (self.containersPadding * 3)))
            
            self.slidesView.frame = CGRect(x: ((self.mainContainerView.frame.size.width / 2) + (self.containersPadding / 2)), y: self.containersPadding, width: (((self.mainContainerView.frame.size.width - (self.containersPadding * 2)) - self.containersPadding) / 2), height: (self.mainContainerView.frame.size.height - timelineHeight - (self.containersPadding * 3)))
        } else {
            self.timelineView.frame = CGRect(x: self.containersPadding, y: (self.mainContainerView.frame.size.height - timelineHeight - self.containersPadding), width: (self.mainContainerView.frame.size.width - (self.containersPadding * 2)), height: timelineHeight)
            
            self.videoView.frame = CGRect(x: self.containersPadding, y: self.containersPadding, width: (self.mainContainerView.frame.size.width - (self.containersPadding * 2)), height: ((self.mainContainerView.frame.size.height - timelineHeight - (self.containersPadding * 4)) / 2))
            
            self.slidesView.frame = CGRect(x: self.containersPadding, y: (self.videoView.frame.origin.y + self.videoView.frame.size.height + self.containersPadding), width: (self.mainContainerView.frame.size.width - (self.containersPadding * 2)), height: ((self.mainContainerView.frame.size.height - timelineHeight - (self.containersPadding * 4)) / 2))
        }
    }
    
    func play() {
        //let playerResource = BMPlayerResource(url: URL(string: self.videoUrl!)!)
        
       // self.videoView.player.setVideo(resource: playerResource)
       // self.videoView.player.play()
        self.timelineView.playButton.isHidden = true
        self.timelineView.pauseButton.isHidden = false
        
        
        self.videoView.play()
    }
    
    func pause() {
        self.timelineView.playButton.isHidden = false
        self.timelineView.pauseButton.isHidden = true
        
        
        self.videoView.pause()
    }
    
    func moveToImageIndex(index: NSInteger) {
        let object = self.synchronisation![index] as! NSDictionary
        let time = object.object(forKey: "time") as! NSInteger
    
        self.videoView.playerView.player?.seek(to: CMTime(value: CMTimeValue(time), timescale: CMTimeScale(1.0)))
    
        let stringUrl = object.object(forKey: "uri") as? String
            
        self.slidesView.imageView.setImageWith(URL(string: stringUrl!)!)
        self.slidesView.setSlidesCount(value: (index + 1), count: (self.synchronisation?.count)!)
            
        self.timelineView.selectIndex(value: index)
    }
    
    // MARK: PlayerPlaybackDelegate
    
    func playerCurrentTimeDidChange(currentTime: TimeInterval, maximumDuration: TimeInterval) {
        if self.oldCurrentTime != NSInteger(currentTime) {
            self.oldCurrentTime = NSInteger(currentTime)
            
            for i in 0..<(self.synchronisation?.count)! {
                let object = self.synchronisation![i] as! NSDictionary
                let time = object.object(forKey: "time") as! NSInteger
                
                if time == self.oldCurrentTime {
                    let stringUrl = object.object(forKey: "uri") as? String
                    
                    self.slidesView.imageView.setImageWith(URL(string: stringUrl!)!)
                    self.slidesView.setSlidesCount(value: (i + 1), count: (self.synchronisation?.count)!)
                    
                    self.timelineView.selectIndex(value: i)
                }
            }
        }
        
        //print("playerCurrentTimeDidChange")
    }
    
    func playerPlaybackWillStartFromBeginning() {
        print("playerPlaybackWillStartFromBeginning")
    }
    
    func playerPlaybackWillStart() {
        print("playerPlaybackWillStart")
    }
    
    func playerPlaybackWillEnd() {
        print("playerPlaybackWillEnd")
    }
    
    // MARK: TimelineDelegate
    
    func playButtonClicked() {
        self.play()
    }
    
    func pauseButtonClicked() {
        self.pause()
    }
    
    func imageButtonClicked(index: NSInteger) {
        self.moveToImageIndex(index: index)
    }
    
    // MARK: Application observers
    
    private func addApplicationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillResignActive(_:)), name: .UIApplicationWillResignActive, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidEnterBackground(_:)), name: .UIApplicationDidEnterBackground, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillEnterForeground(_:)), name: .UIApplicationWillEnterForeground, object: UIApplication.shared)
    }
    
    private func removeApplicationObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc internal func handleApplicationWillResignActive(_ aNotification: Notification) {
        
    }
    
    @objc internal func handleApplicationDidBecomeActive(_ aNotification: Notification) {
        
    }
    
    @objc internal func handleApplicationDidEnterBackground(_ aNotification: Notification) {
        
    }
    
    @objc internal func handleApplicationWillEnterForeground(_ aNoticiation: Notification) {
        
    }
    
}
