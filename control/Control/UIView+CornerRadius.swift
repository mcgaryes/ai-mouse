//
//  UIView+CornerRadius.swift
//  Control
//
//  Created by Eric McGary on 11/23/16.
//
//

import UIKit

@IBDesignable
extension UIView
{
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let bc = layer.borderColor else { return nil }
            return UIColor(cgColor: bc)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}
