//
//  TabBarController.swift
//  Pleyeces
//
//  Created by Kristiana on 19/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class TabBarController: SwipeableTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedViewController = viewControllers?[0]
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        setSwipeAnimation(type: SwipeAnimationType.sideBySide)
    }
}
