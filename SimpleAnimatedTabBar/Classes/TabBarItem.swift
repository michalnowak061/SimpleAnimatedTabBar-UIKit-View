//
//  TabBarItem.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 12/04/2021.
//

import Foundation

enum TabBarItemClickAnimationType: Int {
    case none
    case rotation
    case flipHorizontal
    case translateUp
}

class TabBarItem: UIView {
    // MARK: -- Private variable's
    private var imageView: UIImageView = UIImageView()
    
    // MARK: -- Public variable's
    public weak var delegate: TabBarItemDelegate?
    
    public var clickAnimationType: TabBarItemClickAnimationType = .rotation
    
    public var animationDuration: TimeInterval = 0.3
    
    public var isSelected: Bool = false {
        didSet(newValue) {
            if newValue != self.isSelected {
                switch isSelected {
                case true:
                    self.translateUpAnimation()
                case false:
                    self.translateDownAnimation()
                }
            }
        }
    }
        
    // MARK: -- Public function's
    public var image: UIImage {
        get {
            return self.imageView.image ?? UIImage()
        }
        set(newImage) {
            self.imageView.image = newImage
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.setupImageView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    // MARK: -- Private function's
    private func setupImageView() {
        let height = self.frame.height * 0.5
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: height, height: height)
        self.imageView.center.x = self.center.x
        self.imageView.center.y = self.center.y
        
        self.addSubview(self.imageView)
    }
    
    @objc private  func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        switch self.clickAnimationType {
        case .none:
            break
        case .flipHorizontal:
            self.flipAnimation()
        case .rotation:
            self.rotateAnimation()
        case .translateUp:
            self.isSelected = true
        }

        self.delegate?.clicked(tag: self.tag)
    }
    
    private func rotateAnimation() {
        UIView.animate(withDuration: self.animationDuration) {
            self.rotate(angle: 180)
            self.rotate(angle: 180)
        }
    }
    
    private func flipAnimation() {
        UIView.transition(from: self.imageView,
                          to: self.imageView,
                          duration: self.animationDuration,
                          options: [.transitionFlipFromRight, .showHideTransitionViews])
    }
    
    private func translateUpAnimation() {
        UIView.animate(withDuration: self.animationDuration) {
            self.transform = self.transform.translatedBy(x: 0.0, y: -self.frame.height * 0.2)
        }
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDuration / 4) {
            self.transform = self.transform.scaledBy(x: 1.2, y: 1.2)
        }
    }
    
    private func translateDownAnimation() {
        UIView.animate(withDuration: self.animationDuration) {
            self.transform = .identity
        }
    }
}
