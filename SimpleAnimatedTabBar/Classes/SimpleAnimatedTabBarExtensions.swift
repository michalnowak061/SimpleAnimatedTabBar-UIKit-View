//
//  SimpleAnimatedTabBarExtensions.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 12/04/2021.
//

import Foundation

extension SimpleAnimatedTabBar: TabBarItemDelegate {
    public func tabBarItem(_ tabBarItem: TabBarItem, didSelectTag tag: Int) {
        self.selectTabBarItem(at: tag)
    }
    
    public func translateUp(_ tabBarItem: TabBarItem, didEnded: Bool, selectedItemTag tag: Int) {
        print("translateUp didEnded ", tag)
    }
}
