//
//  ACInterfaceBuilderHelper.swift
//  Avant2Go
//
//  Created by Luka Penger on 29/09/2016.
//  Copyright © 2016 Avant Car. All rights reserved.
//

import UIKit


// MARK: UIView Extension

@IBDesignable extension UIView {
    
    @IBInspectable var masksToBounds: Bool {
        set {
            self.layer.masksToBounds = newValue
        }
        get {
            return self.layer.masksToBounds
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            if let color = newValue {
                self.layer.borderColor = color.cgColor
            }
        }
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor:color)
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            if let color = newValue {
                self.layer.shadowColor = color.cgColor
            }
        }
        get {
            if let color = self.layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set {
            self.layer.shadowOffset = newValue
        }
        get {
            return self.layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set {
            self.layer.shadowOpacity = newValue
        }
        get {
            return self.layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            self.layer.shadowRadius = newValue
        }
        get {
            return self.layer.shadowRadius
        }
    }
    
}


// MARK: UIImageView Extension

@IBDesignable extension UIImageView {
    
    @IBInspectable var imageColor: UIColor? {
        set {
            if let color = newValue {
                self.image = self.image?.tintedWithColor(color)
            }
        }
        get {
            if self.image != nil {
                if let color = self.image?.getPixelColor(pos: CGPoint(x: 0, y: 0)) {
                    return color
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
    }
    
}


// MARK: UIImage Extension

extension UIImage {
    
    func getPixelColor(pos: CGPoint) -> UIColor {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}


// MARK: Float Extension

extension Float {
    
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
}


// MARK: Double Extension

extension Double {
    
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
}
