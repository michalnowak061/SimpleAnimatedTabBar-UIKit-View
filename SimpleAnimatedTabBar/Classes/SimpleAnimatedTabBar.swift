//
//  SimpleAnimatedTabBar.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 09/04/2021.
//

import UIKit

class SimpleAnimatedTabBar: UITabBar {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.tintColor = .green
    }
}
