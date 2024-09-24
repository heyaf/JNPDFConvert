//
//  UIButton+Extion.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/24.
//

import Foundation

extension UIButton {
    func addGradationColor(width:Float,height:Int) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.hex("#F13236").cgColor, UIColor.hex("#D60005").cgColor] // 渐变颜色
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: Int(width), height: height)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
