//
//  TabBarItem.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 12/04/2021.
//

import Foundation

public enum TabBarItemClickAnimationType: Int {
    case none           = 0
    case rotation       = 1
    case flipHorizontal = 2
    case translateUp    = 3
}

public class TabBarItem: UIView {
    // MARK: -- Private variable's
    private var isPrepareForInterfaceBuilder: Bool = true
    
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
    
    public var isTranslatedUp: Bool = false {
        didSet(newValue) {
            if newValue != self.isTranslatedUp {
                switch isTranslatedUp {
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    public override func prepareForInterfaceBuilder() {
        isPrepareForInterfaceBuilder = true
    }
    
    deinit {
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if isPrepareForInterfaceBuilder {
            self.setupViews()
        }
        
        isPrepareForInterfaceBuilder = false
    }
    
    public func select(atIndex index: Int) {
        self.handleTap()
    }
    
    // MARK: -- Private function's
    private func setupViews() {
        self.setupImageView()
        self.setupLabel()
        
        self.resizeImageViewIfLabelIsEmpty()
    }
    
    private func setupImageView() {
        let height = self.frame.height * 0.4
        
        self.imageView.frame = CGRect(x: 0, y: self.frame.height * 0.2, width: height, height: height)
        self.imageView.center.x = self.frame.width / 2
        self.imageView.contentMode = .scaleAspectFit
        
        self.addSubview(self.imageView)
    }
    
    private func setupLabel() {
        let width = self.frame.width
        let height = self.frame.height * 0.2
        
        self.label.frame = CGRect(x: 0, y: self.imageView.frame.maxY, width: width, height: height)
        let fontSize = height
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
            self.isTranslatedUp = true
        }
        self.delegate?.tabBarItem(self, didSelectTag: tag)
    }
    
    private func resizeImageViewIfLabelIsEmpty() {
        if self.label.text?.isEmpty ?? true {
            self.imageView.transform = self.imageView.transform.scaledBy(x: 1.8, y: 1.8)
            self.imageView.center.y = self.center.y
        }
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
