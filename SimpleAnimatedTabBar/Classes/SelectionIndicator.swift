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
    private var view: UIView = UIView()
    
    // MARK: -- Public variable's
    public var indicatorBackgroundColor: UIColor = .blue
    
    public var animationDuration: TimeInterval = 0.3
    
    public var type: SelectionIndicatorType = .square
    
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
        view.backgroundColor = self.indicatorBackgroundColor
        self.view.removeFromSuperview()
        self.addSubview(view)
        
        switch self.type {
        case .none:
            self.isHidden = true
        case .rectangle:
            view.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
            view.cornerRadius = self.cornerRadius
        case .square:
            view.snp.makeConstraints { make in
                make.width.height.equalTo(self.snp.height)
                make.center.equalTo(self.snp.center)
            }
            view.cornerRadius = self.cornerRadius
        case .circle:
            view.snp.makeConstraints { make in
                make.width.height.equalTo(self.snp.height)
                make.center.equalTo(self.snp.center)
            }
        case .downLine:
            view.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.width.equalTo(self.snp.width)
                make.height.equalTo(self.snp.height).multipliedBy(0.1)
            }
        case .upLine:
            view.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(self.snp.width)
                make.height.equalTo(self.snp.height).multipliedBy(0.1)
            }
        case .downDot:
            view.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-(self.size?.height ?? 0) * 0.04)
                make.width.height.equalTo(self.snp.height).multipliedBy(0.1)
                make.centerX.equalTo(self.snp.centerX)
            }
        case .upDot:
            view.snp.makeConstraints { make in
                make.top.equalToSuperview().offset((self.size?.height ?? 0) * 0.04)
                make.width.height.equalTo(self.snp.height).multipliedBy(0.1)
                make.centerX.equalTo(self.snp.centerX)
            }
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
