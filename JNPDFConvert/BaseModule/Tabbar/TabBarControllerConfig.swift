//
//  TabBarControllerConfig.swift
//  LXIM_Example
//
//  Created by md6 on 2019/9/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class TabBarControllerConfig {

    lazy var tabBarController: TabBarController = {
        let tabBarController = TabBarController()
        return tabBarController
    }()

    init() {
//        if let user = LoginUser.currentUser() {
//            if user.account != nil && user.isPerfect == true {
//            }
//        }
        setupChildVcs()

    }
    
    func setupChildVcs() {
        
        let vc1 = AllToolsVC()
        let vc2 = HomeVC()
        let vc3 = JNHistoryVC()
//
        tabBarController.addChildVc(vc1, "Auto Click".local, "tab_autoclick", "tab_autoclick_hl", true, tag: 0)
        tabBarController.addChildVc(vc2, "Auto Scroll".local, "tab_autoscroll", "tab_autoscroll_hl", true, tag: 1)
        tabBarController.addChildVc(vc3, "Auto Save".local, "tab_autosave", "tab_autosave_hl", true, tag: 2)

        
 

    }
    
    deinit {
        debugPrint("TabBarControllerConfig--------销毁了")
    }

}


