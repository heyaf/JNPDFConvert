//
//  UIConfig.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
import UIKit

//登录颜色
public let MainColor = UIColor.hexString("#F90000")
//#141416
public let BlackColor = UIColor.hexString("#141416")

public func boldSystemFont(ofSize fontSize: CGFloat) -> UIFont {
    return .boldSystemFont(ofSize: fontSize)
}

public func middleFont(ofSize fontSize: CGFloat) -> UIFont {
    return .systemFont(ofSize: fontSize, weight: UIFont.Weight(rawValue: 600))
}

public func font(size fontSize: CGFloat)-> UIFont {
    return .systemFont(ofSize: fontSize)
}
