//
//  SimpleAnimatedTabBar.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 09/04/2021.
//

import UIKit

private let stackViewSizeScaleFactor: CGFloat = 0.9

@IBDesignable public class SimpleAnimatedTabBar: UIView, InstanceCountable {
    // MARK: -- Public variable's
    public static var instanceCounter: Int = 0
    
    public weak var delegate: SimpleAnimatedTabBarDelegate?
    
    public var selectedIndex: Int {
        get {
            return self.selectionIndicator.actualIndex
        }
        set(newValue) {
            DispatchQueue.main.async {
                self.select(at: newValue)
            }
        }
    }
    
    override public func layoutMarginsDidChange() {
        if !self.firstSelection {
            DispatchQueue.main.async {
                let selectedIdx = self.selectedIndex
                self.selectionIndicator.animate(selectedIndex: 0, spacing: self.stackViewSpacing, itemsCount: self.numberOfItems)
                self.selectionIndicator.animate(selectedIndex: selectedIdx, spacing: self.stackViewSpacing, itemsCount: self.numberOfItems)
                self.releaseAllTabBarItems()
                self.tabBarItems[selectedIdx].isTranslatedUp = true
            }
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.subviewForTranslateUp.cornerRadius = self.tabBarItemSize.height / 2.0
    }

    // MARK: -- Private variable's
    private var isPrepareForInterfaceBuilder: Bool = false
    
    private var firstSelection: Bool = true
    
    private var tabBarView: UIView = UIView()
    
    private var stackView: UIStackView = UIStackView()
    
    private var tabBarItems: [TabBarItem] = []
    
    private var tabBarItemSize: CGSize {
        get {
            let width = ((self.frame.width - (2 * self.frame.width * 0.1)) - (CGFloat(self.numberOfItems - 1) * self.stackViewSpacing)) / CGFloat(self.numberOfItems)
            let height = self.frame.height
            return CGSize(width: width, height: height)
        }
    }
    
    private var selectionIndicator: SelectionIndicator = SelectionIndicator()
    
    private var subviewForTranslateUp: UIView = UIView()
    
    private var subviewForTranslateUpIsHidden = true
    
    private var stackViewSpacing: CGFloat {
        get {
            let spacing = self.stackView.spacing > 0 ? self.stackViewSpacing : 1
            return spacing
        }
        set(newValue) {
            if newValue < 1 {
                self.stackViewSpacing = 1
            }
        }
    }
    
    // MARK: -- Private IBInspectable's
    @IBInspectable var numberOfItems: Int = 4 {
        didSet {
            self.tabBarItems.removeAll()
            
            for index in 0 ..< numberOfItems {
                let tabBarItem = TabBarItem()
                tabBarItem.delegate = self
                tabBarItem.tag = index
                
                self.tabBarItems.append(tabBarItem)
                self.stackView.addArrangedSubview(tabBarItem)
            }
        }
    }
        
    @IBInspectable private var tabBarBackgroundColor: UIColor? {
        didSet {
            self.tabBarView.backgroundColor = tabBarBackgroundColor
        }
    }
    
    @IBInspectable private var stackViewBackgroundColor: UIColor = .clear {
        didSet {
            self.stackView.backgroundColor = stackViewBackgroundColor
        }
    }
    
    @IBInspectable private var tabBarItemBackgroundColor: UIColor = .clear {
        didSet {
            _ = self.tabBarItems.map {
                $0.backgroundColor = tabBarItemBackgroundColor
            }
        }
    }
    
    @IBInspectable private var tabBarItemCornerRadius: CGFloat = 0.0 {
        didSet {
            _ = self.tabBarItems.map {
                $0.cornerRadius = tabBarItemCornerRadius
            }
        }
    }
    
    @IBInspectable private var tabBarItemClickAnimationType: Int =  TabBarItemClickAnimationType.none.rawValue {
        didSet {
            _ = self.tabBarItems.map {
                $0.clickAnimationType = TabBarItemClickAnimationType(rawValue: self.tabBarItemClickAnimationType) ?? TabBarItemClickAnimationType.rotation
            }
        }
    }
    
    @IBInspectable private var tabBarItemAnimationDuration: Float = 0.3 {
        didSet {
            _ = self.tabBarItems.map {
                $0.animationDuration = TimeInterval(tabBarItemAnimationDuration)
            }
        }
    }
    
    @IBInspectable private var selectionIndicatorType: Int = SelectionIndicatorType.downLine.rawValue {
        didSet {
            self.selectionIndicator.type = SelectionIndicatorType(rawValue: self.selectionIndicatorType) ?? SelectionIndicatorType.none
        }
    }
    
    @IBInspectable private var selectionIndicatorAnimationType: Int = SelectionIndicatorAnimationType.translation.rawValue {
        didSet {
            self.selectionIndicator.animationType = SelectionIndicatorAnimationType(rawValue: self.selectionIndicatorAnimationType) ?? SelectionIndicatorAnimationType.none
        }
    }
    
    @IBInspectable private var selectionIndicatorBackgroundColor: UIColor = .clear {
        didSet {
            self.selectionIndicator.indicatorBackgroundColor = self.selectionIndicatorBackgroundColor
        }
    }
    
    @IBInspectable private var selectionIndicatorAlpha: CGFloat = 1.0 {
        didSet {
            self.selectionIndicator.alpha = self.selectionIndicatorAlpha
        }
    }
    
    @IBInspectable private var selectionIndicatorAnimationDuration: Float = 0.3 {
        didSet {
            self.selectionIndicator.animationDuration = TimeInterval(self.selectionIndicatorAnimationDuration)
        }
    }
    
    @IBInspectable private var selectionIndicatorCornerRadius: CGFloat = 0.0 {
        didSet {
            self.selectionIndicator.cornerRadius = self.selectionIndicatorCornerRadius
        }
    }
    
    // MARK: -- Private function's
    private func setupTabBarView() {        
        self.addSubview(self.tabBarView)
        self.tabBarView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            self.tabBarView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.tabBarView.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.tabBarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.tabBarView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupHorizontalStackView() {
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
        self.stackView.alignment = .fill
        
        self.stackView.removeFromSuperview()
        self.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            self.stackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: stackViewSizeScaleFactor),
            self.stackView.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupTabBarItems() {
        guard self.numberOfItems == self.tabBarItems.count else {
            return
        }
        
        for index in 0 ..< self.numberOfItems {
            let tabBarItem = self.tabBarItems[index]
            let tabBarItemSize = self.tabBarItemSize
            
            tabBarItem.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: tabBarItemSize)
            tabBarItem.image = UIImage(systemName: "square.fill") ?? UIImage()
            tabBarItem.name = "item"
            
            self.delegate?.imageAndlabelForItem(self, item: tabBarItem, atIndex: index)
        }
    }
    
    private func setupSelectionIndicator() {
        self.selectionIndicator.removeFromSuperview()
        self.insertSubview(self.selectionIndicator, at: 1)
        self.selectionIndicator.size = CGSize(width: self.tabBarItemSize.width, height: self.frame.height)
        self.selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            self.selectionIndicator.widthAnchor.constraint(equalTo: self.tabBarItems[0].widthAnchor),
            self.selectionIndicator.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.selectionIndicator.centerXAnchor.constraint(equalTo: self.tabBarItems[0].centerXAnchor),
            self.selectionIndicator.centerYAnchor.constraint(equalTo: self.tabBarItems[0].centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupSubviewForTranslateUp(atIndex index: Int) {
        self.subviewForTranslateUp.removeFromSuperview()
        self.insertSubview(self.subviewForTranslateUp, at: 0)
        self.subviewForTranslateUp.backgroundColor = self.tabBarView.backgroundColor
        self.subviewForTranslateUp.translatesAutoresizingMaskIntoConstraints = false
    
        let constraints = [
            self.subviewForTranslateUp.widthAnchor.constraint(equalTo: self.stackView.arrangedSubviews[index].heightAnchor),
            self.subviewForTranslateUp.heightAnchor.constraint(equalTo: self.stackView.arrangedSubviews[index].heightAnchor),
            self.subviewForTranslateUp.centerXAnchor.constraint(equalTo: self.stackView.arrangedSubviews[index].centerXAnchor),
            self.subviewForTranslateUp.centerYAnchor.constraint(equalTo: self.stackView.arrangedSubviews[index].centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupViews() {
        self.setupTabBarView()
        self.setupHorizontalStackView()
        self.setupTabBarItems()
        self.setupSelectionIndicator()
    }
    
    private func releaseAllTabBarItems() {
        _ = self.tabBarItems.map {
            $0.isTranslatedUp = false
        }
    }
    
    private func releaseTabBarItems(withoutTag: Int) {
        _ = self.tabBarItems.map {
            if $0.tag != withoutTag {
                $0.isTranslatedUp = false
            }
        }
    }
    
    private func select(at index: Int) {
        guard index < self.tabBarItems.count else {
            return
        }
        self.tabBarItems[index].select(atIndex: index)
    }
    
    // MARK: -- Public function's
    required init?(coder aDecoder: NSCoder) {
        SimpleAnimatedTabBar.instanceCounter += 1
        
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override public func prepareForInterfaceBuilder() {
        self.isPrepareForInterfaceBuilder = true
    }
    
    deinit {
        SimpleAnimatedTabBar.instanceCounter -= 1
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.numberOfItems == 0 { self.numberOfItems = 4 }
        if self.tabBarBackgroundColor == nil { self.tabBarBackgroundColor = #colorLiteral(red: 0.5349039663, green: 0.8391603913, blue: 1, alpha: 1) }
        
        self.setupViews()
    }
    
    public func selectTabBarItem(at index: Int) {
        if firstSelection {
            self.selectionIndicator.animationDuration = 0
            self.firstSelection = false
        } else {
            self.selectionIndicator.animationDuration = TimeInterval(self.selectionIndicatorAnimationDuration)
        }
        
        self.releaseTabBarItems(withoutTag: index)
        self.selectionIndicator.animate(selectedIndex: index, spacing: self.stackViewSpacing, itemsCount: self.numberOfItems)
    }
    
    public func updateSubviewForTranslateUp(selectedItemAt index: Int) {
        let translateValue = self.frame.height * 0.5
        let duration = TimeInterval(self.tabBarItemAnimationDuration / 2)
        
        switch self.subviewForTranslateUpIsHidden {
        case true:
            UIView.animate(withDuration: duration) {
                self.subviewForTranslateUp.transform = self.subviewForTranslateUp.transform.translatedBy(x: 0, y: -translateValue)
            }
            UIView.animate(withDuration: duration, delay: duration + (duration / 2), animations: {
                self.subviewForTranslateUp.transform = self.subviewForTranslateUp.transform.scaledBy(x: 1.2, y: 1.0)
            }, completion: { _ in
                self.setupSubviewForTranslateUp(atIndex: index)
                self.subviewForTranslateUpIsHidden = false
            })
        case false:
            UIView.animate(withDuration: duration, animations: {
                self.subviewForTranslateUp.transform = .identity
            }, completion: { _ in
                self.setupSubviewForTranslateUp(atIndex: index)
            })
            UIView.animate(withDuration: duration, delay: duration) {
                self.subviewForTranslateUp.transform = self.subviewForTranslateUp.transform.translatedBy(x: 0, y: -translateValue)
            }
            UIView.animate(withDuration: duration, delay: duration + (duration / 2)) {
                self.subviewForTranslateUp.transform = self.subviewForTranslateUp.transform.scaledBy(x: 1.2, y: 1.0)
            }
        }
    }
}
