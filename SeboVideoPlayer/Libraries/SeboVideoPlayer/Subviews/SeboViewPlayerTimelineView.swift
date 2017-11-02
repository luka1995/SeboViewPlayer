//
//  SeboViewPlayerTimelineView.swift
//  SeboVideoPlayer
//
//  Created by Luka Penger on 26/10/2017.
//  Copyright © 2017 Luka Penger. All rights reserved.
//

import UIKit
import AFNetworking


// MARK: TimelineDelegate

public protocol TimelineDelegate: NSObjectProtocol {
    
    func playButtonClicked()
    
    func pauseButtonClicked()
    
    func imageButtonClicked(index: NSInteger)
    
}


// MARK: SeboViewPlayerTimelineView

class SeboViewPlayerTimelineView: UIView, UIScrollViewDelegate {
    
    // MARK: Constants
    
    // MARK: Variables
    
    var synchronisation: NSArray!
    
    weak var delegate: TimelineDelegate?
    
    // MARK: Outlets
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    
    // MARK: Init
    
    func loadFromNib() -> SeboViewPlayerTimelineView {
        return UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SeboViewPlayerTimelineView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.setupSynchronisation()
        }
    }
    
    // MARK: Actions
    
    @IBAction func playButtonClicked(_ button: UIButton) {
        self.delegate?.playButtonClicked()
    }
    
    @IBAction func pauseButtonClicked(_ button: UIButton) {
        self.delegate?.pauseButtonClicked()
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    // MARK: Methods
    
    private func setupSynchronisation() {
        _ = self.scrollView.subviews.map { (view) in
            view.removeFromSuperview()
        }
        
        let viewWidth: CGFloat = (self.scrollView.frame.height * 1.5)
        let viewPadding: CGFloat = 10.0
        
        for i in 0..<(self.synchronisation.count) {
            let object = self.synchronisation[i] as! NSDictionary
            
            let imageView = TimelineScrollImageView()
            imageView.url = object.object(forKey: "thumb") as? String
            imageView.clickHandler = {
                self.delegate?.imageButtonClicked(index: i)
            }
            
            imageView.frame = CGRect(x: (CGFloat(i) * viewWidth) + (CGFloat(i) * viewPadding), y: 0.0, width: viewWidth, height: self.scrollView.frame.size.height)
            
            self.scrollView.addSubview(imageView)
        }
        
        self.scrollView.contentSize = CGSize(width: (CGFloat(self.synchronisation.count) * viewWidth) + (CGFloat(self.synchronisation.count - 1) * viewPadding), height: 0.0)
    }
    
    func selectIndex(value: NSInteger) {
        _ = self.scrollView.subviews.map { (view) in
            let imageView = view as! TimelineScrollImageView
            
            imageView.selectedLineView.isHidden = true
        }
        
        let imageView = self.scrollView.subviews[value] as! TimelineScrollImageView
        imageView.selectedLineView.isHidden = false
        
        let position = ((imageView.frame.origin.x + imageView.frame.size.width) - self.scrollView.contentOffset.x)
        
        if position > self.scrollView.frame.size.width || position < imageView.frame.size.width {
            self.scrollView.setContentOffset(CGPoint(x: imageView.frame.origin.x, y: 0.0), animated: true)
        }
    }
    
}


// MARK: TimelineScrollImageView

class TimelineScrollImageView: UIView {
    
    // MARK: Constants
    
    let SelectedLineHeight: CGFloat = 3.0
    
    // MARK: Variables
    
    var url: String? {
        didSet {
            self.setupImage()
        }
    }
    
    var clickHandler: (() -> Void)?
    
    // MARK: Outlets
    
    var imageView: UIImageView!
    var selectedLineView: UIView!
    private var button: UIButton!
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView()
        self.imageView.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        self.addSubview(self.imageView)
        
        self.selectedLineView = UIView()
        self.selectedLineView.backgroundColor = UIColor(red: (15.0/255.0), green: (105.0/255.0), blue: (179.0/255.0), alpha: 1.0)
        self.selectedLineView.isHidden = true
        self.addSubview(self.selectedLineView)
        
        self.button = UIButton(type: .custom)
        self.button.backgroundColor = UIColor.clear
        self.button.setBackgroundImage(self.imageWithColor(UIColor(white: 0.4, alpha: 0.4)), for: UIControlState.highlighted)
        self.button.addTarget(self, action: #selector(buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(self.button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectedLineView.frame = CGRect(x: 8.0, y: (self.frame.size.height - SelectedLineHeight), width: (self.frame.size.width - (8.0 * 2)), height: SelectedLineHeight)
        
        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: (self.frame.size.height - SelectedLineHeight - 8.0))
        
        self.button.frame = self.imageView.bounds
    }
    
    // MARK: Actions
    
    @objc private func buttonClicked(_ button: UIButton) {
        if self.clickHandler != nil {
            self.clickHandler!()
        }
    }
    
    // MARK: Methods
    
    private func setupImage() {
        if self.url != nil {
            let url = URL(string: self.url!)
            
            self.imageView.setImageWith(url!)
        }
    }
    
    func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
