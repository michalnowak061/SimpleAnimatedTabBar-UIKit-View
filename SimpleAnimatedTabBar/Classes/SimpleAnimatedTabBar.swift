//
//  SimpleAnimatedTabBar.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 09/04/2021.
//

import UIKit

@IBDesignable class SimpleAnimatedTabBar: UIView, InstanceCountable {
    // MARK: -- Public variable's
    public static var instanceCounter: Int = 0
    
    // MARK: -- Private variable's
    private var tabBarView: UIView = UIView()
    
    private var stackView: UIStackView = UIStackView()
    
    private var tabBarItems: [TabBarItem] = []
    
    private var tabBarItemSize: CGSize {
        get {
            let width = (self.stackView.frame.width - (CGFloat(self.numberOfItems - 1) * self.stackViewSpacing)) / CGFloat(self.numberOfItems)
            let height = self.stackView.frame.height
            return CGSize(width: width, height: height)
        }
    }
    
    private var selectionIndicator: SelectionIndicator = SelectionIndicator()
    
    // MARK: -- Private IBInspectable's
    @IBInspectable private var numberOfItems: Int = 2 {
        didSet {
            self.tabBarItems.removeAll()
            
            for index in 0 ..< self.numberOfItems {
                let tabBarItem = TabBarItem()
                tabBarItem.delegate = self
                tabBarItem.tag = index
                
                self.tabBarItems.append(tabBarItem)
                self.stackView.addArrangedSubview(tabBarItem)
            }
        }
    }
    
    @IBInspectable private var tabBarBackgroundColor: UIColor = .systemBlue {
        didSet {
            self.tabBarView.backgroundColor = tabBarBackgroundColor
        }
    }
        
    @IBInspectable private var tabBarCornerRadius: CGFloat = 0 {
        didSet {
            self.tabBarView.cornerRadius = tabBarCornerRadius
        }
    }
    
    @IBInspectable private var stackViewBackgroundColor: UIColor = .systemPink {
        didSet {
            self.stackView.backgroundColor = stackViewBackgroundColor
        }
    }
    
    @IBInspectable private var stackViewSpacing: CGFloat = 10 {
        didSet {
            self.stackView.spacing = stackViewSpacing
        }
    }
    
    @IBInspectable private var tabBarItemBackgroundColor: UIColor = .systemTeal {
        didSet {
            _ = self.tabBarItems.map {
                $0.backgroundColor = tabBarItemBackgroundColor
            }
        }
    }
    
    @IBInspectable private var tabBarItemCornerRadius: CGFloat = 0 {
        didSet {
            _ = self.tabBarItems.map {
                $0.cornerRadius = tabBarItemCornerRadius
            }
        }
    }
    
    @IBInspectable private var tabBarItemClickAnimationType: Int = TabBarItemClickAnimationType.rotation.rawValue {
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
    
    @IBInspectable private var selectionIndicatorType: Int = SelectionIndicatorType.rectangle.rawValue {
        didSet {
            self.selectionIndicator.type = SelectionIndicatorType(rawValue: self.selectionIndicatorType) ?? SelectionIndicatorType.none
            print("type: ", self.selectionIndicator.type)
        }
    }
    
    @IBInspectable private var selectionIndicatorBackgroundColor: UIColor = .cyan {
        didSet {
            self.selectionIndicator.indicatorBackgroundColor = self.selectionIndicatorBackgroundColor
        }
    }
    
    @IBInspectable private var selectionIndicatorAlpha: CGFloat = 0.5 {
        didSet {
            self.selectionIndicator.alpha = self.selectionIndicatorAlpha
        }
    }
    
    @IBInspectable private var selectionIndicatorAnimationDuration: Float = 0.3 {
        didSet {
            self.selectionIndicator.animationDuration = TimeInterval(self.selectionIndicatorAnimationDuration)
        }
    }
    
    @IBInspectable private var selectionIndicatorCornerRadius: CGFloat = 0 {
        didSet {
            self.selectionIndicator.cornerRadius = self.selectionIndicatorCornerRadius
        }
    }
    
    // MARK: -- Private function's
    private func setupTabBarView() {
        let tabBarViewWidth = self.frame.width * 1
        let tabBarViewHeight = self.frame.height * 1
        
        self.tabBarView.frame = CGRect(x: 0, y: 0, width: tabBarViewWidth, height: tabBarViewHeight)
        self.tabBarView.center.x = self.frame.width / 2
        self.tabBarView.center.y = self.frame.height / 2
        
        self.addSubview(self.tabBarView)
    }
    
    private func setupHorizontalStackView() {
        let horizontalStackViewWidth = self.tabBarView.frame.width * 0.9
        let horizontalStackViewHeight = self.tabBarView.frame.height * 0.6
        
        self.stackView.frame = CGRect(x: 0, y: 0, width: horizontalStackViewWidth, height: horizontalStackViewHeight)
        self.stackView.center.x = self.frame.width / 2
        self.stackView.center.y = self.frame.height / 2
        
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
        self.stackView.alignment = .fill
        
        self.addSubview(self.stackView)
    }
    
    private func setupTabBarItems() {
        for index in 0 ..< self.numberOfItems {
            let tabBarItem = self.tabBarItems[index]
            let tabBarItemSize = self.tabBarItemSize
            
            tabBarItem.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: tabBarItemSize)
        }
    }
    
    private func setupSelectionIndicator() {
        let selectionIndicatorWidth = self.tabBarItemSize.width
        let selectionIndicatorHeight = self.stackView.frame.height
        
        let selectionIndicatorFrame = CGRect(x: self.stackView.frame.minX, y: 0, width: selectionIndicatorWidth, height: selectionIndicatorHeight)
        self.selectionIndicator.frame = selectionIndicatorFrame
        self.selectionIndicator.center.y = self.tabBarView.center.y
        self.selectionIndicator.centerPoint = self.stackView.arrangedSubviews[0].center
        
        self.insertSubview(self.selectionIndicator, at: 1)
    }
    
    // MARK: -- Public function's
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        SimpleAnimatedTabBar.instanceCounter += 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    deinit {
        SimpleAnimatedTabBar.instanceCounter -= 1
    }
    
    override func draw(_ rect: CGRect) {
        self.setupTabBarView()
        self.setupHorizontalStackView()
        self.setupTabBarItems()
        self.setupSelectionIndicator()
        
        if #available(iOS 13.0, *) {
            self.tabBarItems[0].image = UIImage(systemName: "house.fill")!
            self.tabBarItems[1].image = UIImage(systemName: "house.fill")!
            self.tabBarItems[2].image = UIImage(systemName: "house.fill")!
            self.tabBarItems[3].image = UIImage(systemName: "house.fill")!
        }
    }
    
    public func releaseTabBarItems(withoutTag: Int) {
        _ = self.tabBarItems.map {
            if $0.tag != withoutTag {
                $0.isSelected = false
            }
        }
    }
    
    public func selectionIndicatorUpdate(tag: Int) {
        self.selectionIndicator.translateAnimation(selectedIndex: tag, spacing: self.stackViewSpacing, itemsCount: self.numberOfItems)
    }
}
