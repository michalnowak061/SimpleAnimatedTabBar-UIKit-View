//
//  ViewController.swift
//  SimpleAnimatedTabBar
//
//  Created by michalnowak061 on 04/09/2021.
//  Copyright (c) 2021 michalnowak061. All rights reserved.
//

import UIKit
import SimpleAnimatedTabBar

class ViewController: UIViewController {
    // MARK: -- Private variable's
    private var viewControllers: [UIViewController] = [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FourthViewController")
    ]
    
    // MARK: -- IBOutlet's
    @IBOutlet weak var simpleAnimatedTabBar: SimpleAnimatedTabBar!
    
    @IBOutlet weak var viewForViewControllers: UIView!
    
    // MARK: -- Override's
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.simpleAnimatedTabBar.delegate = self
        //self.simpleAnimatedTabBar.selectedIndex = 0
    }
}

extension ViewController: SimpleAnimatedTabBarDelegate {
    func imageAndlabelForItem(_ simpleAnimatedTabBar: SimpleAnimatedTabBar, item: TabBarItem, atIndex index: Int) {
        switch index {
        case 0:
            item.image = UIImage(systemName: "house") ?? UIImage()
            item.name = "Home"
        case 1:
            item.image = UIImage(systemName: "camera") ?? UIImage()
            item.name = "Camera"
        case 2:
            item.image = UIImage(systemName: "music.note") ?? UIImage()
            item.name = "Music"
        case 3:
            item.image = UIImage(systemName: "trash") ?? UIImage()
            item.name = "Trash"
        default:
            break
        }
    }
    
    func simpleAnimatedTabBar(_ simpleAnimatedTabBar: SimpleAnimatedTabBar, didSelectItemAt index: Int) {
        guard index < self.viewControllers.count else {
            return
        }
        
        self.viewForViewControllers.addSubview(self.viewControllers[index].view)
    }
}
