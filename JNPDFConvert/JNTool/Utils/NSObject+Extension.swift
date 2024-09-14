//
//  NSObject+Extension.swift
//  Account
//
//  Created by 王子威 on 2020/12/5.
//

import UIKit

extension NSObject {
    // 返回类对象 名称
    public static var className: String {
        get {
            let classN = self.description()
            if (classN.contains(".")) {
                return classN.components(separatedBy: ".").last ?? ""
            } else {
                return classN
            }
        }
    }
}
