//
//  LLTabBarController.swift
//  Lib
//
//  Created by 迦南 on 2018/7/4.
//  Copyright © 2018年 ray. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    static let shareInstances = TabBarController()
    //    var popView: CreatPartyPopView?
    var tabBarHeight: CGFloat? /// 自定义tabbar控件的高度
    var imageInsets: UIEdgeInsets? /// 自定义tabbarItem的图片的偏移量
    var titlePositionAdjustment: UIOffset? /// 自定义UIBarItem label text的属性偏移
    let myTabBar: TabBar = TabBar()
    //    var midButton: UIButton = UIFactoryUtil.createButton(normalImage: UIImage(named: "add"),UIImage(named: "add_selected"))
    
    
    deinit {
        debugPrint("TabBarController--------销毁了")
        //        tabBar.removeObserver(self, forKeyPath: "tabImageViewDefaultOffset")
    }
    
}

extension TabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        delayGCD(timeInval: 0.1) {
            self.setUpTabbar()
        }
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = AppUtil.getTopVC() {
            return vc.preferredStatusBarStyle
        }
        return .default
    }
    
    
}


// MARK:- 设置Tabbar
extension TabBarController {
    fileprivate func setUpTabbar() {
        //        let tabBar = TabBar(frame: .zero)
        myTabBar.delegate = self
        setValue(myTabBar, forKeyPath: "tabBar")
        //        tabBar.addObserver(self, forKeyPath: "tabImageViewDefaultOffset", options: .new, context: nil)
        selectedIndex = 2
        selectedIndex = 0

        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard let change = change else { return }
//        guard let value = change[NSKeyValueChangeKey.newKey] else { return }
//        
//        let imageViewDefaultOffset = value as! CGFloat
//        var imageInset = UIEdgeInsets(top: imageViewDefaultOffset, left: 0, bottom: -imageViewDefaultOffset, right: 0)
//        
//        if shouldCustomizeImageInsets() {
//            imageInset = self.imageInsets!
//        }
//        
//        guard let items = tabBar.items else { return }
//        for item in items {
//            item.imageInsets = imageInset
//            
//            if shouldCustomizeTitlePositionAdjustment() {
//                item.titlePositionAdjustment = titlePositionAdjustment!
//            }
//        }
    }
    
    /// 判断是否需要自定义图片偏移量
    private func shouldCustomizeImageInsets() -> Bool {
        guard let imageInsets = imageInsets else { return false }
        let shouldCustomizeImageInsets = imageInsets.top != 0 || imageInsets.left != 0 || imageInsets.bottom != 0 || imageInsets.right != 0
        return shouldCustomizeImageInsets
    }
    
    /// 判断是否需要自定义文本偏移量
    private func shouldCustomizeTitlePositionAdjustment() -> Bool {
        guard let titlePositionAdjustment = titlePositionAdjustment else { return false }
        let shouldCustomizeTitlePositionAdjustment = titlePositionAdjustment.horizontal != 0 || titlePositionAdjustment.vertical != 0
        return shouldCustomizeTitlePositionAdjustment
    }
    
    func currentTabBar() {
        
    }
}

// MARK:- 对外方法
extension TabBarController {
    // MARK: 添加子控制器(默认内部使用LLNavigationController)
    func addChildVc(_ childVc: UIViewController, _ title : String?, _ norImg: String?, _ selImg: String?, _ isRequiredNavVc: Bool, tag: Int) {
        
        //        childVc.title = title
        
        if isRequiredNavVc { // 有导航控制器
            let navVc = BaseNavigationController(rootViewController: childVc)
            setupNavBarItem(navVc, title, norImg, selImg , tag: tag)
            addChild(navVc)
        } else { // 没有导航控制器
            setupNavBarItem(childVc, title, norImg, selImg, tag: tag)
            addChild(childVc)
        }
    }
    
    private func setupNavBarItem(_ childVc: UIViewController, _ title : String?, _ norImg: String?, _ selImg: String? , tag: Int) {
        childVc.tabBarItem.title = title
        childVc.tabBarItem.tag = tag
        if let norImg = norImg {
            childVc.tabBarItem.image = UIImage(named: norImg)?.withRenderingMode(.alwaysOriginal)
        }
        
        if let selImg = selImg {
            childVc.tabBarItem.selectedImage = UIImage(named: selImg)?.withRenderingMode(.alwaysOriginal)
        }
        
        
//        tabBar.tintColor = .white//UIConfig.hexString("#1D152E")//UIConfig.hexString("#194CD5")
//        
//        //        childVc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIConfig.hexString("#1246D9").withAlphaComponent(0.8)], for: .selected)
//        TabBar.setupTabBarAttribute(.white, UIConfig.hexString("#14D2B8"), nil)
//        self.tabBar.unselectedItemTintColor = .white
//        childVc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    public func changeToIndex(index: Int) {
        if let selectedViewController = self.selectedViewController {
            if selectedViewController.isKind(of: UINavigationController.self) {
                let nav = selectedViewController as? UINavigationController
                nav?.popToRootViewController(animated: false)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { // 延时处理 防止pop动画未处理完导致崩溃
            self.selectedIndex = index
            //            self.tabBar.selectedItem = index
            // self.  待补充 tabar状态
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if tabBarController.tabBar.selectedItem?.tag == 2 {
//            tabBarController.selectedIndex = selectedIndex
//            return false
//        }
//        return true
//    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        guard let index = tabBar.items?.firstIndex(where: {$0 == item}) else {return}
//        if index != 2 {
//            selectedIndex = index
//        }
//    }
}
