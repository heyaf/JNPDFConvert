//
//  AppUtil.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
import UIKit

///window相关，获取当前window,当前根控制器，当前导航控制器，当前控制器等
public class AppUtil {
    ///获取当前window
    public class func getWindow()->UIWindow?{
        return UIApplication.shared.delegate?.window ?? nil
    }
    //获取当前控制器
    public class func getTopVC() -> (UIViewController?) {
        //是否为当前显示的window
        var vc: UIViewController?
        let semaphore = DispatchSemaphore(value: 0)
            var window = UIApplication.shared.keyWindow
            if window?.windowLevel != UIWindow.Level.normal{
                let windows = UIApplication.shared.windows
                for  windowTemp in windows{
                    if windowTemp.windowLevel == UIWindow.Level.normal{
                        window = windowTemp
                        break
                    }
                }
            vc = getTopVC(withCurrentVC: window?.rootViewController)
            semaphore.signal()
        }
        semaphore.wait()
        return vc
    }
    ///获取当前导航控制器，有模态弹出无法找到
    public class func getCurrentNav()->UINavigationController?{
        
        return getTopVC()?.navigationController
    }
    
    ///根据控制器获取 顶层控制器
    public class func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
        if VC == nil {
            return nil
        }
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器
            return getTopVC(withCurrentVC: presentVC)
        }else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return nil
        } else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav 过滤掉顶层nav
            if let tabVC = naiVC.viewControllers.first as? UITabBarController,
               let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return getTopVC(withCurrentVC:naiVC.visibleViewController)
        } else {
            // 返回顶控制器
            return VC
        }
    }
    
    
    static public func isContacts(urlString: String) -> Bool {
        return urlString.contains(".com") ||
        urlString.contains(".cn") ||
        urlString.contains("http") ||
        urlString.contains("https") ||
        urlString.contains(".top") ||
        urlString.contains(".xyz") ||
        urlString.contains(".net") ||
        urlString.contains(".ltd") ||
        urlString.contains(".vip") ||
        urlString.contains(".shop") ||
        urlString.contains(".cc") ||
        urlString.contains(".store") ||
        urlString.contains(".online") ||
        urlString.contains(".fun") ||
        urlString.contains(".tech") ||
        urlString.contains(".art") ||
        urlString.contains(".site") ||
        urlString.contains(".co") ||
        urlString.contains(".icu") ||
        urlString.contains(".clu") ||
        urlString.contains(".work") ||
        urlString.contains(".xin") ||
        urlString.contains(".wang") ||
        urlString.contains(".space") ||
        urlString.contains(".group") ||
        urlString.contains(".ink") ||
        urlString.contains(".pub") ||
        urlString.contains(".ren") ||
        urlString.contains(".live") ||
        urlString.contains(".link") ||
        urlString.contains(".cloud") ||
        urlString.contains(".com.cn") ||
        urlString.contains(".website") ||
        urlString.contains(".pro") ||
        urlString.contains(".life") ||
        urlString.contains(".asia") ||
        urlString.contains(".biz") ||
        urlString.contains(".cool") ||
        urlString.contains(".mobi") ||
        urlString.contains(".fit") ||
        urlString.contains(".plus") ||
        urlString.contains(".press") ||
        urlString.contains(".wiki") ||
        urlString.contains(".love") ||
        urlString.contains(".red") ||
        urlString.contains(".design") ||
        urlString.contains(".video") ||
        urlString.contains(".run") ||
        urlString.contains(".show") ||
        urlString.contains(".zone") ||
        urlString.contains(".kim") ||
        urlString.contains(".city") ||
        urlString.contains(".gold") ||
        urlString.contains(".today") ||
        urlString.contains(".host") ||
        urlString.contains(".chat") ||
        urlString.contains(".fund") ||
        urlString.contains(".beer") ||
        urlString.contains(".center") ||
        urlString.contains(".company") ||
        urlString.contains(".email") ||
        urlString.contains(".yoga") ||
        urlString.contains(".luxe") ||
        urlString.contains(".net.cn") ||
        urlString.contains(".org.cn") ||
        urlString.contains(".world") ||
        urlString.contains(".fans") ||
        urlString.contains(".guru") ||
        urlString.contains(".law") ||
        urlString.contains(".social") ||
        urlString.contains(".gov.cn") ||
        urlString.contains("www")
    }
    
    
   static func validateUrl(url: String,handler: @escaping (Bool)->()) {
        if let url = URL(string: url) {
          var request = URLRequest(url: url)
          request.httpMethod = "HEAD"
            JNPrint(url)
          URLSession(configuration: .default)
            .dataTask(with: request) { (_, response, error) -> Void in
              guard error == nil else {
                handler(false)
                  JNPrint(2222)
                return
              }

              guard (response as? HTTPURLResponse)?
                .statusCode == 200 else {
                  handler(true)
                  JNPrint(11)
                  return
              }
                JNPrint(3333)

                handler(true)
            }.resume()
        }
    }
    
}
//回到主线程
func MainThread (completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
        completion!()
    }
}
//延迟执行
func delayGCD (timeInval:CGFloat, completion: (() -> Void)? = nil) {
    DispatchQueue.main.asyncAfter(deadline: .now() + timeInval) {
        completion!()
    }
}
