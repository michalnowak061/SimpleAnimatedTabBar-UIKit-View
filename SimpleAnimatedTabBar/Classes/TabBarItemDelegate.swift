//
//  TabBarItemDelegate.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 12/04/2021.
//

import Foundation

public protocol TabBarItemDelegate: class {
    func tabBarItem(_ tabBarItem: TabBarItem, didSelectTag tag: Int)
    
    func translateUp(_ tabBarItem: TabBarItem, didEnded: Bool, selectedItemTag tag: Int)
}
