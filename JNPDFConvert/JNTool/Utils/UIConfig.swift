//
//  UIConfig.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
import UIKit


public func boldSystemFont(ofSize fontSize: CGFloat) -> UIFont {
    return .boldSystemFont(ofSize: fontSize)
}

public func middleFont(ofSize fontSize: CGFloat) -> UIFont {
    return .systemFont(ofSize: fontSize, weight: UIFont.Weight(rawValue: 600))
}

public func font(size fontSize: CGFloat)-> UIFont {
    return .systemFont(ofSize: fontSize)
}
