//
//  SeboViewPlayerTimelineView.swift
//  SeboVideoPlayer
//
//  Created by Luka Penger on 26/10/2017.
//  Copyright © 2017 Luka Penger. All rights reserved.
//

import UIKit
import JMMarkSliderSwift


// MARK: SeboViewPlayerTimelineView

class SeboViewPlayerTimelineView: UIView, UIScrollViewDelegate {
    
    // MARK: Constants
    
    // MARK: Variables
    
    public var sliderValueChanged: ((Float) -> Void)?
    
    @IBOutlet var slider: JMMarkSlider!
    
    // MARK: Outlets
    
    @IBOutlet private var scrollView: UIScrollView!
    
    // MARK: Init
    
    func loadFromNib() -> SeboViewPlayerTimelineView {
        return UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SeboViewPlayerTimelineView
    }

    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.slider.setNeedsDisplay()
    }
    
    // MARK: Actions
    
    @IBAction func sliderDidEnd(_ slider: UISlider) {
        if self.sliderValueChanged != nil {
            self.sliderValueChanged!(slider.value)
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    // MARK: Methods
    
    func loadImagesFromURLs(urls: [String]) {
        
    }
    
    private func updateScrollImages() {
        /*_ = self.scrollView.subviews.map { (view) in
            view.removeFromSuperview()
        }*/
        
        
    }
    
}


// MARK: TimelineScrollImageView

class TimelineScrollImageView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Init
    
    func loadFromNib() -> TimelineScrollImageView {
        return UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TimelineScrollImageView
    }

}
