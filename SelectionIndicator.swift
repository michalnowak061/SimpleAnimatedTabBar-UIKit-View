//
//  SelectionIndicator.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 12/04/2021.
//

import UIKit

enum SelectionIndicatorType: Int, CaseIterable {
    case none
    case rectangle
    case square
    case circle
    case line
}

class SelectionIndicator: UIView {
    // MARK: -- Public variable's
    public var indicatorBackgroundColor: UIColor = .blue
    public var animationDuration: TimeInterval = 0.3
    
    public var type: SelectionIndicatorType = .square
    
    // MARK: -- Public function's
    override func draw(_ rect: CGRect) {
        switch self.type {
        case .none:
            self.isHidden = true
        case .rectangle:
            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            let rectangle = UIView(frame: frame)
            rectangle.center.y = self.center.y
            rectangle.backgroundColor = self.indicatorBackgroundColor
            rectangle.cornerRadius = self.cornerRadius
            self.addSubview(rectangle)
        case .square:
            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
            let square = UIView(frame: frame)
            square.center.y = self.center.y
            square.backgroundColor = self.indicatorBackgroundColor
            square.cornerRadius = self.cornerRadius
            self.addSubview(square)
        case .circle:
            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
            let circle = UIView(frame: frame)
            circle.center.y = self.center.y
            circle.backgroundColor = self.indicatorBackgroundColor
            circle.layer.cornerRadius = circle.frame.width / 2
            self.addSubview(circle)
        case .line:
            let frame = CGRect(x: 0, y: self.frame.maxY - (self.frame.height * 0.1), width: self.frame.width, height: self.frame.height * 0.1)
            let line = UIView(frame: frame)
            line.backgroundColor = self.indicatorBackgroundColor
            line.cornerRadius = self.cornerRadius
            self.addSubview(line)
        }
    }
    
    public func translateAnimation(selectedIndex index: Int, spacing: CGFloat, itemsCount: Int) {
        UIView.animate(withDuration: self.animationDuration) {
            let translateVectorX = (self.frame.width + spacing) * CGFloat(index)
            self.transform = .identity
            self.transform = self.transform.translatedBy(x: translateVectorX, y: 0)
        }
    }
}
