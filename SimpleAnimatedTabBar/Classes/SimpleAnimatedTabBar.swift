//
//  SimpleAnimatedTabBar.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 09/04/2021.
//

import UIKit
import SnapKit

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
    private var isPrepareForInterfaceBuilder: Bool = true
    
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
    
    // MARK: -- Private IBInspectable's
    @IBInspectable private var numberOfItems: Int = 0 {
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
        }
    }
    
    @IBInspectable private var selectionIndicatorAnimationType: Int = SelectionIndicatorAnimationType.translation.rawValue {
        didSet {
            self.selectionIndicator.animationType = SelectionIndicatorAnimationType(rawValue: self.selectionIndicatorAnimationType) ?? SelectionIndicatorAnimationType.none
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
        self.addSubview(self.tabBarView)
        self.tabBarView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    private func setupHorizontalStackView() {
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
        self.stackView.alignment = .fill
        
        self.stackView.removeFromSuperview()
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
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
            //tabBarItem.name = "item"
            
            self.delegate?.imageAndlabelForItem(self, item: tabBarItem, atIndex: index)
        }
    }
    
    private func setupSelectionIndicator() {
        self.selectionIndicator.removeFromSuperview()
        self.insertSubview(self.selectionIndicator, at: 1)
        self.selectionIndicator.snp.removeConstraints()
        self.selectionIndicator.snp.makeConstraints { make in
            make.width.equalTo(self.tabBarItems[0].snp.width)
            make.height.equalToSuperview()
            make.center.equalTo(self.tabBarItems[0].snp.center)
        }
        
        self.selectionIndicator.size = CGSize(width: self.tabBarItemSize.width, height: self.frame.height)
    }
    
    private func setupSubviewForTranslateUp(atIndex index: Int) {
        self.subviewForTranslateUp.removeFromSuperview()
        self.insertSubview(self.subviewForTranslateUp, at: 0)
        self.subviewForTranslateUp.snp.removeConstraints()
        self.subviewForTranslateUp.snp.makeConstraints { make in
            make.width.equalTo(self.stackView.arrangedSubviews[index].snp.height)
            make.height.equalTo(self.stackView.arrangedSubviews[index].snp.height)
            make.center.equalTo(self.stackView.arrangedSubviews[index].snp.center)
        }
        
        self.subviewForTranslateUp.backgroundColor = self.tabBarView.backgroundColor
    }
    
    private func setupViews() {
        self.setupTabBarView()
        self.setupHorizontalStackView()
        self.setupTabBarItems()
        self.setupSelectionIndicator()
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
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        if isPrepareForInterfaceBuilder {
            self.setupViews()
        }
        
        isPrepareForInterfaceBuilder = false
    }
    
    public func releaseAllTabBarItems() {
        _ = self.tabBarItems.map {
            $0.isTranslatedUp = false
        }
    }
    
    public func releaseTabBarItems(withoutTag: Int) {
        _ = self.tabBarItems.map {
            if $0.tag != withoutTag {
                $0.isTranslatedUp = false
            }
        }
    }
    
    public func select(at index: Int) {
        guard index < self.tabBarItems.count else {
            return
        }
        self.tabBarItems[index].select(atIndex: index)
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
