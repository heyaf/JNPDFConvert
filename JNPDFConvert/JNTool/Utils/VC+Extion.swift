//
//  VC+Extion.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
extension UIViewController {
    func presentViewCon(storyboard name: String) {
        let sb = UIStoryboard(name: name, bundle: nil)
        presentViewCon(sb.instantiateInitialViewController()!)
    }
    
    func presentViewCon(_ viewCon: UIViewController) {
        if #available(iOS 13, *) {
            viewCon.modalPresentationStyle = .fullScreen
        }
        present(viewCon, animated: true)
        
    }
    
    func pushViewCon(storyboard name: String) {
        let sb = UIStoryboard(name: name, bundle: nil)
        pushViewCon(sb.instantiateInitialViewController()!)
    }
    
    func pushViewCon(_ viewCon: UIViewController) {
        if let nav = self as? UINavigationController {
            nav.pushViewController(viewCon, animated: true)
            return
        }
        navigationController?.pushViewController(viewCon, animated: true)
    }
    
    func popViewCon(_ animated: Bool = true) {
        if let nav = self as? UINavigationController {
            nav.popViewController(animated:animated)
        } else {
            navigationController?.popViewController(animated:animated)
        }
    }
    
    func popToRootViewCon() {
        if let nav = self as? UINavigationController {
            nav.popToRootViewController(animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func popToViewCon(_ viewCon: UIViewController) {
        DispatchQueue.main.async(execute: {
            if let nav = self as? UINavigationController {
                nav.popToViewController(viewCon, animated: true)
            } else {
                self.navigationController?.popToViewController(viewCon, animated: true)
            }
        })
    }
    
    func pushViewCon(_ viewCon: UIViewController, _ completedClosure: (() -> Void)? = nil) {
        if let nav = self as? UINavigationController {
            nav.pushViewController(viewCon, animated: true)
        } else {
            self.navigationController?.pushViewController(viewCon, animated: true)
        }
        guard let coordinator = transitionCoordinator else {
            completedClosure?()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completedClosure?() }
    }
}
