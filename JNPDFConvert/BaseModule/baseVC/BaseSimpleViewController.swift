//
//  BaseSimpleViewController.swift
//  LXBase
//
//  Created by YAMYEE on 2019/9/3.
//

import Foundation
import UIKit

/// 不带ViewModel的基类控制器
open class BaseSimpleViewController: UIViewController {
    ///是否隐藏导航栏
    open var isHideCustomNav : Bool{
        return false
    }
    open override var title: String?{
        didSet{
            isHideCustomNav ? nil : (customNav.title = title)
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    ///设置返回手势
    public var isPopGestureEnabled:Bool = true
    
    
    open lazy var customNav = WRCustomNavigationBar()
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if navigationController?.interactivePopGestureRecognizer?.isEnabled != isPopGestureEnabled{
            navigationController?.interactivePopGestureRecognizer?.isEnabled = isPopGestureEnabled
        }
        ///接听电话或自定义拍照收起后导状态栏下移，高度增加20
        if (self.navigationController?.view.height ?? kScreenHeight) - kScreenHeight == statusBarHeight {
            self.navigationController?.viewControllers.forEach({$0.view.frame.size.height = kScreenHeight})
            self.navigationController?.view.frame.size.height = kScreenHeight
            
            let navVC = AppUtil.getWindow()?.rootViewController as? UINavigationController
            let barVC = navVC?.viewControllers.first as? UITabBarController
            barVC?.view.frame.size.height = kScreenHeight
        }
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .hexString("#1E152F")
        setupNavBar()
        setupUI()
        bindData()
    }
    
    private func setupUI(){
       
           
        
    }
    
    private func bindData(){
        ///调起子类UI初始化
//        if let vc = self as? LoadDataProvider{
//            vc.initData()
//            vc.loadData()
//        }
    }
    
    open func setupNavBar(){
        guard isHideCustomNav == false else { return }
        
        view.addSubview(customNav)
        
        customNav.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kNavBarHeight)
        }
        
        customNav.onClickLeftButton = {[weak self] in

            self?.onBackClick()
        }
        
        if navigationController?.viewControllers.count ?? 1 > 1 {
//            let bundle = Bundle(path: (Bundle(for: BaseViewController.self).resourcePath ?? "") + "/LXBase.bundle")
            customNav.wr_setLeftButton(image: UIImage(named:"back") ?? UIImage())
//            customNav.wr_setLeftButton(image: UIImage(named:"navbar_back_black",in: bundle, compatibleWith: nil) ?? UIImage())
        }
    }
    
    open func setupNavBarLeftButton() {
        if customNav.leftButton.isHidden, navigationController?.viewControllers.count ?? 1 > 1 {
//            let bundle = Bundle(path: (Bundle(for: BaseViewController.self).resourcePath ?? "") + "/LXBase.bundle")
//            customNav.wr_setLeftButton(image: UIImage(named:"navbar_back_black",in: bundle, compatibleWith: nil) ?? UIImage())
            customNav.wr_setLeftButton(image: UIImage(named:"back") ?? UIImage())

        }
    }
    
    deinit {
        debugPrint("deinit----------------",self)
    }
    open func onBackClick(){
        popViewCon()
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
//    open override func navigationShouldPop() -> Bool {
//        return true
//    }
}

