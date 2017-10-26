//
//  SeboViewPlayerSlidesView.swift
//  SeboVideoPlayer
//
//  Created by Luka Penger on 26/10/2017.
//  Copyright © 2017 Luka Penger. All rights reserved.
//

import UIKit


// MARK: SeboViewPlayerSlidesView

class SeboViewPlayerSlidesView: UIView {

    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var slidesCountLabel: UILabel!
    
    // MARK: Init
    
    func loadFromNib() -> SeboViewPlayerSlidesView {
        return UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SeboViewPlayerSlidesView
    }
    
    // MARK: Methods
    
    func setSlidesCount(value: NSInteger, count: NSInteger) {
        self.slidesCountLabel.text = "\(value) / \(count)"
    }
    
}
