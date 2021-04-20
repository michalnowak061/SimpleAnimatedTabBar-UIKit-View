//
//  TabBarItem.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 12/04/2021.
//

import Foundation

public enum TabBarItemClickAnimationType: Int {
    case none
    case rotation
    case flipHorizontal
    case translateUp
}

public class TabBarItem: UIView {
    // MARK: -- Private variable's
    private var imageView: UIImageView = UIImageView()
    
    private var label: UILabel = UILabel()
    
    // MARK: -- Public variable's
    public weak var delegate: TabBarItemDelegate?
    
    public var clickAnimationType: TabBarItemClickAnimationType = .rotation
    
    public var animationDuration: TimeInterval = 0.3
    
    public var translateUpValue: CGFloat {
        get {
            return self.frame.height * 0.5
        }
    }
    
    public var isSelected: Bool = false {
        didSet(newValue) {
            if newValue != self.isSelected {
                switch isSelected {
                case true:
                    self.translateUpAnimation()
                    self.delegate?.translateUp(self, didEnded: true, selectedItemTag: self.tag)
                case false:
                    self.translateDownAnimation()
                }
            }
        }
    }
    
    public var image: UIImage {
        get {
            return self.imageView.image ?? UIImage()
        }
        set(newImage) {
            self.imageView.image = newImage
        }
    }
     
    public var name: String {
        get {
            return self.label.text ?? ""
        }
        set(newName) {
            self.label.text = newName
        }
    }
    
    // MARK: -- Public function's
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        DispatchQueue.main.async {
            self.setupImageView()
            self.setupLabel()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    deinit {
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    public func select(atIndex index: Int) {
        self.handleTap()
    }
    
    // MARK: -- Private function's
    private func setupImageView() {
        let height = self.frame.height * 0.5
        
        print(self.center)
        
        self.imageView.frame = CGRect(x: 0, y: self.frame.height * 0.14, width: height, height: height)
        self.imageView.center.x = self.frame.width / 2
        self.imageView.contentMode = .scaleAspectFit
        
        self.addSubview(self.imageView)
    }
    
    private func setupLabel() {
        let width = self.frame.width
        let height = self.frame.height * 0.2
        
        self.label.frame = CGRect(x: 0, y: self.imageView.frame.maxY, width: width, height: height)
        let fontSize = width / 5
        self.label.font = self.label.font.withSize(fontSize)
        self.label.textAlignment = .center
        self.label.textColor = self.tintColor
        
        self.addSubview(self.label)
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

        self.delegate?.tabBarItem(self, didSelectTag: tag)
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
            self.transform = self.transform.translatedBy(x: 0.0, y: -self.translateUpValue)
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
