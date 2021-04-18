//
//  SimpleAnimatedTabBarExtensions.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 12/04/2021.
//

import Foundation

extension SimpleAnimatedTabBar: TabBarItemDelegate {
    func clicked(tag: Int) {
        self.releaseTabBarItems(withoutTag: tag)
        self.selectionIndicatorUpdate(tag: tag)
        
        self.delegate?.simpleAnimatedTabBar(self, didSelectItemAt: tag)
    }
}
