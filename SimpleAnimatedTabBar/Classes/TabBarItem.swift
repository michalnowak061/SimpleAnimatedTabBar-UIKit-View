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

private let viewSizeScaleFactor: CGFloat = 0.6

private let imageSizeScaleFactor: CGFloat = 0.7

private let labelSizeScaleFactor: CGFloat = 0.3

private let labelFontSizeScaleFactor: CGFloat = 0.15

public class TabBarItem: UIView {
    // MARK: -- Private variable's
    private var isPrepareForInterfaceBuilder: Bool = true
    
    private var view: UIView = UIView()
    
    private var imageView: UIImageView = UIImageView()
    
    private var label: UILabel = UILabel()
    
    private var delegateMute: Bool = false
    
    // MARK: -- Public variable's
    public weak var delegate: TabBarItemDelegate?
    
    public var clickAnimationType: TabBarItemClickAnimationType = .none
    
    public var animationDuration: TimeInterval = 0.3
    
    public var translateUpValue: CGFloat {
        get {
            return self.frame.height * 0.5
        }
    }
    
    public var isTranslatedUp: Bool = false {
        didSet(newValue) {
            if newValue != self.isTranslatedUp && self.clickAnimationType == .translateUp {
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
    
    override public var bounds: CGRect {
        didSet {
            let fontSize = self.frame.height * labelFontSizeScaleFactor
            self.label.font = self.label.font.withSize(fontSize)
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
    
    deinit {
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.setupViews()
    }
    
    public func select(atIndex index: Int, delegateMute: Bool = false) {
        self.handleTap()
        self.delegateMute = delegateMute
    }
    
    // MARK: -- Private function's
    private func setupViews() {
        self.setupView()
    }
    
    private func setupView() {
        self.addSubview(self.view)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            self.view.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: viewSizeScaleFactor),
            self.view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.setupImageView()
        self.setupLabel()
    }
    
    private func setupImageView() {
        self.imageView.contentMode = .scaleAspectFit
        self.view.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let sizeScaleFactor: CGFloat = self.label.text?.isEmpty == true ? 1.0 : imageSizeScaleFactor
        
        let constraints = [
            self.imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: sizeScaleFactor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupLabel() {
        let fontSize = self.view.frame.height * labelFontSizeScaleFactor
        self.label.font = self.label.font.withSize(fontSize)
        self.label.textAlignment = .center
        self.label.textColor = self.tintColor
        
        self.view.addSubview(self.label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            self.label.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.label.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: labelSizeScaleFactor),
            self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.label.topAnchor.constraint(equalTo: self.imageView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
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
        if self.delegateMute == false {
            self.delegate?.tabBarItem(self, didSelectTag: tag)
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
