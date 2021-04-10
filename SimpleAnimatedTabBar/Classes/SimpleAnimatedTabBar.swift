//
//  SimpleAnimatedTabBar.swift
//  SimpleAnimatedTabBar
//
//  Created by Michał Nowak on 09/04/2021.
//

import UIKit

enum SelectionIndicatorType: Int, CaseIterable {
    case rectangle
    case square
    case ellipse
    case circle
}

@IBDesignable class SimpleAnimatedTabBar: UITabBar, InstanceCountable {
    // MARK: -- Public variable's
    public static var instanceCounter: Int = 0
    
    // MARK: -- Private variable's
    private var isInterfaceBuilder: Bool = false
        
    private var tabBarItemCount: Int {
        get {
            if let count = self.items?.count {
                return count
            } else {
                return 0
            }
        }
    }
    
    private var tabBarItemSize: CGSize {
        get {
            return CGSize(width: self.frame.width / CGFloat(self.tabBarItemCount), height: self.frame.height)
        }
    }
    
    private var selectedTabBarItemFrame: UIView? {
        get {
            if let tabBarItemFrame = self.items?[self.selectedItemIndex].value(forKey: "view") as? UIView {
                return tabBarItemFrame
            } else {
                return nil
            }
        }
    }
    
    private var selectionIndicator: UIImageView? = nil
    
    private var selectionIndicatorTypeEnum: SelectionIndicatorType {
        get {
            return SelectionIndicatorType(rawValue: self.selectionIndicatorType) ?? .ellipse
        }
    }
    
    // MARK -- IBInspectable's
    @IBInspectable var selectedItemIndex: Int = 0 {
        didSet(newSelectedItemIndex) {
            guard newSelectedItemIndex <= self.tabBarItemCount && newSelectedItemIndex >= 0 else {
                self.selectedItemIndex = 0
                return
            }
            self.update()
        }
    }
    
    @IBInspectable var selectionIndicatorIsOn: Bool = false {
        didSet {
            selectionIndicatorSetup()
        }
    }
    
    @IBInspectable var selectionIndicatorColor: UIColor = #colorLiteral(red: 0.9739994407, green: 0.7346709371, blue: 0.8141820431, alpha: 1) {
        didSet {
            selectionIndicatorSetup()
        }
    }
    
    @IBInspectable private var selectionIndicatorType: Int = 0 {
        didSet(newValue) {
            guard newValue <= SelectionIndicatorType.allCases.count else {
                return
            }
            selectionIndicatorSetup()
        }
    }
    
    @IBInspectable private var selectionIdicatorDuration: Float = 0.2 {
        willSet(newValue) {
            if newValue >= 0 {
                self.selectionIdicatorDuration = newValue
            } else {
                self.selectionIdicatorDuration = 0
            }
        }
    }
    
    @IBInspectable private var selectionIndicatorAlpha: CGFloat = 1.0 {
        didSet(newValue) {
            guard newValue <= 1.0 && newValue >= 0 else {
                return
            }
            selectionIndicatorSetup()
        }
    }

    // MARK: -- Override's and init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        SimpleAnimatedTabBar.instanceCounter += 1
        
        self.delegate = self
    }
    
    deinit {
        SimpleAnimatedTabBar.instanceCounter -= 1
    }
    
    override func prepareForInterfaceBuilder() {
        self.isInterfaceBuilder = true
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        if !self.isInterfaceBuilder {
            // code for runtime
        }
    }
    
    // MARK: -- Public function's
    
    // MARK: -- Private function's
    private func update() {
        self.selectTabBarItem(atIndex: self.selectedItemIndex)
    }
    
    private func selectTabBarItem(atIndex index: Int) {
        if let selectedItem = self.items?[index] {
            self.selectedItem = selectedItem as UITabBarItem
            self.selectAnimation(tabBarItemIndex: index, withDuration: TimeInterval(self.selectionIdicatorDuration))
        }
    }
    
    private func tabBarItemCenter(forIndex index: Int) -> CGPoint? {
        if let tabBarItemFrame = self.selectedTabBarItemFrame {
            return CGPoint(x: tabBarItemFrame.center.x,
                           y: tabBarItemFrame.center.y)
        } else {
            return nil
        }
    }
    
    private func getSelectionIndicatorImageView(type: SelectionIndicatorType, size: CGSize, point: CGPoint, color: UIColor) -> UIImageView {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size.width, height: size.height))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            
            switch type {
            case .rectangle:
                let rectangle = CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
                ctx.cgContext.addRect(rectangle)
            case .square:
                let diff = (size.width - size.height) / 2
                let rectangle = CGRect(x: point.x + diff, y: point.y, width: size.height, height: size.height)
                ctx.cgContext.addRect(rectangle)
            case .ellipse:
                let rectangle = CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
                ctx.cgContext.addEllipse(in: rectangle)
            case .circle:
                let diff = (size.width - size.height) / 2
                let offset = diff
                let rectangle = CGRect(x: point.x + diff - (offset/2), y: point.y - (offset/2),
                                       width: size.height + offset, height: size.height + offset)
                ctx.cgContext.addEllipse(in: rectangle)
            }
            
            ctx.cgContext.drawPath(using: .fill)
        }
        return UIImageView(image: img)
    }
    
    private func addSelectionIndicator(type: SelectionIndicatorType, color: UIColor, alpha: CGFloat) {
        let indicatorSize = CGSize(width: tabBarItemSize.width, height: tabBarItemSize.height)
        let indicatorPoint = CGPoint(x: self.selectedTabBarItemFrame?.frame.minX ?? CGFloat(0),
                                     y: self.selectedTabBarItemFrame?.frame.minY ?? CGFloat(0))
        
        self.selectionIndicator = getSelectionIndicatorImageView(type: type, size: indicatorSize, point: indicatorPoint, color: color)
        self.selectionIndicator!.alpha = alpha
        self.insertSubview(self.selectionIndicator!, at: 0)
    }
    
    private func removeSelectionIndicator() {
        self.selectionIndicator?.removeFromSuperview()
    }
    
    private func selectionIndicatorSetup() {
        guard self.selectionIndicatorIsOn else {
            return
        }
        
        let type = self.selectionIndicatorTypeEnum
        let color = self.selectionIndicatorColor
        let alpha = self.selectionIndicatorAlpha
        
        self.removeSelectionIndicator()
        self.addSelectionIndicator(type: type, color: color, alpha: alpha)
    }
    
    private func selectAnimation(tabBarItemIndex index: Int, withDuration duration: TimeInterval = 0.3) {
        if let tabBarItemCenter = self.tabBarItemCenter(forIndex: index) {
            if duration > 0 {
                UIView.animate(withDuration: duration) {
                    self.selectionIndicator?.center.x = tabBarItemCenter.x
                }
            } else {
                self.selectionIndicator?.center.x = tabBarItemCenter.x
            }
        }
    }
}

// MARK: -- Extension's
extension SimpleAnimatedTabBar: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = self.items?.firstIndex(of: item) {
            self.selectedItemIndex = index
        }
    }
}
