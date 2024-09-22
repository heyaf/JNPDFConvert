//
//  GCD+Extion.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/21.
//

import Foundation
private var onceTracker = [String]()


 extension DispatchQueue{
    /// 主线程异步执行，当前在主线程则立即返回
    /// - Parameter block:
    static func safeMainAsync(_ block: @escaping ()->()) {
        self.main.safeAsync(block)
    }
    /// 主线程异步执行，当前在主线程则立即返回
    /// - Parameter block:
    func safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async(execute: block)
        }
    }
}
//延迟执行
func AfterGCD (timeInval:CGFloat, completion: (() -> Void)? = nil) {
    DispatchQueue.main.asyncAfter(deadline: .now() + timeInval) {
        completion!()
    }
}
