//
//  SimpleAnimatedTabBarDelegate.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 18/04/2021.
//

import Foundation

public protocol SimpleAnimatedTabBarDelegate: AnyObject {
    func imageAndlabelForItem(_ simpleAnimatedTabBar: SimpleAnimatedTabBar, item: TabBarItem, atIndex index: Int)
    
    func simpleAnimatedTabBar(_ simpleAnimatedTabBar: SimpleAnimatedTabBar, didSelectItemAt index: Int)
}
