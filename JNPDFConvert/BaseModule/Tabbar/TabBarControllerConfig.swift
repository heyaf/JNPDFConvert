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
        tabBarController.addChildVc(vc1, "All Tools".local,"btn_alltools_unselect", "btn_alltools_selected",  true, tag: 0)
        tabBarController.addChildVc(vc2, "Home".local, "btn_home_unselect","btn_home_selected",  true, tag: 1)
        tabBarController.addChildVc(vc3, "History".local, "btn_history_unselect","btn_history_selected",  true, tag: 2)

        
 

    }
    
    deinit {
        debugPrint("TabBarControllerConfig--------销毁了")
    }

}


