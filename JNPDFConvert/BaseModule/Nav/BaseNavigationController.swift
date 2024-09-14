//
//  BaseNavigationController.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
open class BaseNavigationController: UINavigationController,UINavigationControllerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
//        interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = !viewControllers.isEmpty
        super.pushViewController(viewController, animated: animated)
    }
    
    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.hidesBottomBarWhenPushed = true
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = viewControllers.last {
            return vc.preferredStatusBarStyle
        }
        return .default
    }
    
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
//        if let vc = topViewController, !vc.navigationShouldPop() {
//            return nil
//        }
        if #available(iOS 14.0, *), animated, let fvc = viewControllers.first{
            for vc in viewControllers {
                vc.hidesBottomBarWhenPushed = fvc.hidesBottomBarWhenPushed
            }
        }
        return super.popToRootViewController(animated: animated)
    }
//
//    open override func popViewController(animated: Bool) -> UIViewController? {
//        if let vc = topViewController, !vc.navigationShouldPop() {
//            return nil
//        }
//        return super.popViewController(animated: animated)
//    }
//
//    @objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        //TODO: 拦截滑动返回  需要完善是否滑动返回的判断
//        return children.count > 1
//    }
//
//    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        if interactivePopGestureRecognizer == gestureRecognizer,
//            let vc = topViewController,
//            !vc.navigationShouldPop() {
//            _ = popViewController(animated: true)
//            return false
//        }
//        return true
//    }
}
