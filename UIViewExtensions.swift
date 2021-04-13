//
//  UIViewExtensions.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 12/04/2021.
//

import Foundation

extension UIView {
    // MARK: -- IBInspectable variable's
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
}
