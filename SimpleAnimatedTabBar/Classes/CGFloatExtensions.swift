//
//  CGFloatExtensions.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 19/04/2021.
//

import Foundation

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(CGFloat.pi) / 180.0
    }
}
