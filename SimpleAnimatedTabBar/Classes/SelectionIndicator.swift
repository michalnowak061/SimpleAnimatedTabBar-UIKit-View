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
    case downLine
    case upLine
}

class SelectionIndicator: UIView {
    // MARK: -- Private variable's
    
    // MARK: -- Public variable's
    public var indicatorBackgroundColor: UIColor = .blue
    
    public var animationDuration: TimeInterval = 0.3
    
    public var type: SelectionIndicatorType = .square
    
    public var centerPoint: CGPoint?
    
    public var actualIndex: Int = 0
    
    // MARK: -- Public function's
    override func didMoveToSuperview() {
        switch self.type {
        case .none:
            self.isHidden = true
        case .rectangle:
            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            let rectangle = UIView(frame: frame)
            rectangle.backgroundColor = self.indicatorBackgroundColor
            rectangle.cornerRadius = self.cornerRadius
            rectangle.center = self.centerPoint ?? CGPoint(x: 0, y: 0)
            self.addSubview(rectangle)
        case .square:
            let frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
            let square = UIView(frame: frame)
            square.backgroundColor = self.indicatorBackgroundColor
            square.cornerRadius = self.cornerRadius
            square.center = self.centerPoint ?? CGPoint(x: 0, y: 0)
            self.addSubview(square)
        case .circle:
            let frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
            let circle = UIView(frame: frame)
            circle.backgroundColor = self.indicatorBackgroundColor
            circle.layer.cornerRadius = circle.frame.width / 2
            circle.center = self.centerPoint ?? CGPoint(x: 0, y: 0)
            self.addSubview(circle)
        case .downLine:
            let frame = CGRect(x: 0, y: 0.9 * self.frame.height, width: self.frame.width, height: self.frame.height * 0.1)
            let line = UIView(frame: frame)
            line.backgroundColor = self.indicatorBackgroundColor
            line.cornerRadius = self.cornerRadius
            self.addSubview(line)
        case .upLine:
            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 0.1)
            let line = UIView(frame: frame)
            line.backgroundColor = self.indicatorBackgroundColor
            line.cornerRadius = self.cornerRadius
            self.addSubview(line)
        }
    }
    
    public func translateAnimation(selectedIndex index: Int, spacing: CGFloat, itemsCount: Int) {
        if index == self.actualIndex {
            return
        }
        
        let translateVectorX = (self.frame.width) * CGFloat(index) + (index >= 1 ? spacing * CGFloat(index) : 0)
        var translateVectorXoffset = (self.frame.width + spacing) * 0.1
        
        let toRight = (index - self.actualIndex) >= 0 ? true : false
        
        if toRight == false {
            translateVectorXoffset = -translateVectorXoffset
        }
        
        UIView.animate(withDuration: self.animationDuration, delay: 0, options: .curveEaseOut) {
            self.transform = .identity
            self.transform = self.transform.translatedBy(x: translateVectorX + translateVectorXoffset, y: 0)
        }
        
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDuration, options: .curveEaseOut) {
            self.transform = self.transform.translatedBy(x: -translateVectorXoffset, y: 0)
        }
        
        self.actualIndex = index
    }
}
