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

private let lineSizeScaleFactor: CGFloat = 0.08

private let dotSizeScaleFactor: CGFloat = 0.08

class SelectionIndicator: UIView {
    // MARK: -- Private variable's
    private var view: UIView = UIView()
    
    // MARK: -- Public variable's
    public var indicatorBackgroundColor: UIColor = .systemBlue
    
    public var animationDuration: TimeInterval = 0.3
    
    public var type: SelectionIndicatorType = .downLine
    
    public var animationType: SelectionIndicatorAnimationType = .translation
    
    public var size: CGSize! {
        didSet {
            self.didMoveToSuperview()
        }
    }
    
    public var actualIndex: Int = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.type == .circle || self.type == .downDot || self.type == .upDot {
            self.view.cornerRadius = self.view.frame.height / 2.0
        }
    }
    
    // MARK: -- Public function's
    override func didMoveToSuperview() {
        self.view.removeFromSuperview()
        self.addSubview(view)
        self.view.backgroundColor = self.indicatorBackgroundColor
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        switch self.type {
        case .none:
            self.isHidden = true
        case .rectangle:
            view.cornerRadius = self.cornerRadius
            
            let constraints = [
                self.view.widthAnchor.constraint(equalTo: self.widthAnchor),
                self.view.heightAnchor.constraint(equalTo: self.heightAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        case .square:
            view.cornerRadius = self.cornerRadius
            
            let constraints = [
                self.view.widthAnchor.constraint(equalTo: self.heightAnchor),
                self.view.heightAnchor.constraint(equalTo: self.heightAnchor),
                self.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        case .circle:
            let constraints = [
                self.view.widthAnchor.constraint(equalTo: self.heightAnchor),
                self.view.heightAnchor.constraint(equalTo: self.heightAnchor),
                self.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        case .downLine:
            let constraints = [
                self.view.widthAnchor.constraint(equalTo: self.widthAnchor),
                self.view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: lineSizeScaleFactor),
                self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        case .upLine:
            let constraints = [
                self.view.widthAnchor.constraint(equalTo: self.widthAnchor),
                self.view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: lineSizeScaleFactor),
                self.view.topAnchor.constraint(equalTo: self.topAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        case .downDot:
            let constraints = [
                self.view.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: dotSizeScaleFactor),
                self.view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: dotSizeScaleFactor),
                self.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(self.size?.height ?? 0) * 0.04)
            ]
            NSLayoutConstraint.activate(constraints)
        case .upDot:
            let constraints = [
                self.view.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: dotSizeScaleFactor),
                self.view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: dotSizeScaleFactor),
                self.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.view.topAnchor.constraint(equalTo: self.topAnchor, constant: (self.size?.height ?? 0) * 0.04)
            ]
            NSLayoutConstraint.activate(constraints)
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
