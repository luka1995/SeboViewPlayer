//
//  ACImageManager.swift
//  Avant2Go
//
//  Created by Luka Penger on 02/09/16.
//  Copyright © 2016 Avant Car. All rights reserved.
//

import UIKit


// MARK: ACImageManager

class ACImageManager {
    
    // Methods
    
    static func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func mapPinDrawNumber(number: Int, textColor: UIColor, image: UIImage, font: UIFont, paddingTop: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        image.draw(in: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
        
        let label = UILabel()
        label.textColor = textColor
        label.adjustsFontSizeToFitWidth = true
        label.font = font
        label.textAlignment = NSTextAlignment.center
        label.text = String(number)
        
        let textPadding: CGFloat = 2.0
        label.drawText(in: CGRect(x: textPadding, y: paddingTop, width: (image.size.width - (textPadding * 2)), height: 28.0))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
        
}


// MARK: UIImage

extension UIImage {
    
    // MARK: Methods
    
    func tintedWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        var rect = CGRect.zero
        rect.size = self.size
        color.set()
        UIRectFill(rect)
        self.draw(in: rect, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func changeImageSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func resizeToHeight(_ height: CGFloat) -> UIImage {
        let scale = (height / self.size.height)
        let width = (self.size.width * scale)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

