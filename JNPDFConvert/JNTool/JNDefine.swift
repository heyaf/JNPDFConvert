//
//  JNDefine.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
import UIKit

/// 屏幕宽高
public let kMainBounds = UIScreen.main.bounds
/// 屏幕高度
public  let kScreenHeight = UIScreen.main.bounds.size.height
/// 屏幕宽度
public  let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕宽度比例
public let kWidthScale =  UIScreen.main.bounds.size.width/375.0
/// 屏幕高度比例
public let kHeightScale =  UIScreen.main.bounds.size.height/667.0


//返回状态栏高度

var statusBarHeight: CGFloat {
    if #available(iOS 13.0, *) {
        let statusManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
        return statusManager?.statusBarFrame.height ?? 20.0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}


//返回状态栏和导航栏的高度
let kNavBarHeight = statusBarHeight + 44
// 获取刘海屏底部home键高度,  34或0  普通屏为0
public let kBottomSafeHeight = AppUtil.getWindow()?.safeAreaInsets.bottom ?? 0


public func JNPrint(_ items: Any..., fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    
#if DEBUG
    print("""
        -------------------------------------------
        \((fileName as NSString).lastPathComponent)
        行号:\(lineNumber)
        方法:\(methodName)
        \(items)
        -------------------------------------------
        """)
#endif
}
