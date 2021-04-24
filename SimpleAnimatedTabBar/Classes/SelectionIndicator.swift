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
    case downDot
    case upDot
}

enum SelectionIndicatorAnimationType: Int, CaseIterable {
    case none
    case translation
    case blink
}

class SelectionIndicator: UIView {
    // MARK: -- Private variable's
    
    // MARK: -- Public variable's
    public var indicatorBackgroundColor: UIColor = .blue
    
    public var animationDuration: TimeInterval = 0.3
    
    public var type: SelectionIndicatorType = .square
    
    public var animationType: SelectionIndicatorAnimationType = .translation
    
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
        case .downDot:
            let width = self.frame.height / 10
            let height = self.frame.height / 10
            let frame = CGRect(x: 0,
                               y: self.frame.maxY - height - (height * 0.4),
                               width: width,
                               height: height)
            let dot = UIView(frame: frame)
            dot.backgroundColor = self.indicatorBackgroundColor
            dot.layer.cornerRadius = dot.frame.width / 2
            dot.center.x = self.centerPoint?.x ?? 0
            self.addSubview(dot)
        case .upDot:
            let width = self.frame.height / 10
            let height = self.frame.height / 10
            let frame = CGRect(x: 0,
                               y: self.frame.minY + (height * 0.4),
                               width: width,
                               height: height)
            let dot = UIView(frame: frame)
            dot.backgroundColor = self.indicatorBackgroundColor
            dot.layer.cornerRadius = dot.frame.width / 2
            dot.center.x = self.centerPoint?.x ?? 0
            self.addSubview(dot)
        }
    }
    
    public func animate(selectedIndex index: Int, spacing: CGFloat, itemsCount: Int) {
        switch self.animationType {
        case .none:
            self.translate(withDuration: 0, selectedIndex: index, spacing: spacing, itemsCount: itemsCount)
        case .translation:
            self.translateAnimation(selectedIndex: index, spacing: spacing, itemsCount: itemsCount)
        case .blink:
            self.blinkAnimation(selectedIndex: index, spacing: spacing, itemsCount: itemsCount)
        }
        
        self.actualIndex = index
    }
    
    // MARK: -- Private function's
    private func translate(withDuration duration: TimeInterval, selectedIndex index: Int, spacing: CGFloat, itemsCount: Int) {
        if index == self.actualIndex {
            return
        }
        
        let translateVectorX = (self.frame.width) * CGFloat(index) + (index >= 1 ? spacing * CGFloat(index) : 0)
        var translateVectorXoffset = (self.frame.width + spacing) * 0.1
        
        let toRight = (index - self.actualIndex) >= 0 ? true : false
        
        if toRight == false {
            translateVectorXoffset = -translateVectorXoffset
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            self.transform = .identity
            self.transform = self.transform.translatedBy(x: translateVectorX + translateVectorXoffset, y: 0)
        }
        
        UIView.animate(withDuration: duration, delay: duration, options: .curveEaseOut) {
            self.transform = self.transform.translatedBy(x: -translateVectorXoffset, y: 0)
        }
    }
    
    private func translateAnimation(selectedIndex index: Int, spacing: CGFloat, itemsCount: Int) {
        self.translate(withDuration: self.animationDuration, selectedIndex: index, spacing: spacing, itemsCount: itemsCount)
    }
    
    private func blinkAnimation(selectedIndex index: Int, spacing: CGFloat, itemsCount: Int) {
        self.translate(withDuration: 0, selectedIndex: index, spacing: spacing, itemsCount: itemsCount)
        
        self.alpha = 0
        
        UIView.animate(withDuration: self.animationDuration / 2) {
            self.alpha = 1
        }
        
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDuration / 2) {
            self.alpha = 0
        }
    }
}
