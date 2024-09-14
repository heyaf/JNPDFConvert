//
//  UIColor+Extion.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
import UIKit


extension UIColor{
    
    /// 根据十六进制的字符传得出UIColor
    ///
    /// - Parameters:
    ///   - color: 十六进制的字符传的颜色值
    ///   - alpha: 透明读
    /// - Returns:
    static func hexString(_ color:String,  alpha:CGFloat=1) -> UIColor{
        return self.colorString(color, alpha: alpha)
    }
    /// 根据color得出UIColor,透明读为1
    ///
    /// - Parameters:
    ///   - color: Color
    /// - Returns:
    //    class func Color(_ color:Color) -> UIColor{
    //        return colorString(colorStr:color.rawValue,alpha:1)
    //    }
    
    /// 根据color和透明度得出UIColor
    ///
    /// - Parameters:
    ///   - color: Color
    ///   - alpha: 透明读
    /// - Returns:
    //    class func Color(_ color:Color,  alpha:CGFloat) -> UIColor{
    //        return colorString(colorStr:color.rawValue,alpha:alpha)
    //    }
    
    /// RGB 数字返回颜色
    ///
    /// - Parameters:
    ///   - num: 16进制
    ///   - alpha: 透明度
    /// - Returns:
    static func RGBHexNum(_ num:CGFloat, alpha:CGFloat) -> UIColor{
        let red: CGFloat = num / (256.0 * 256.0)
        let green: CGFloat = (num.truncatingRemainder(dividingBy:  (256.0 * 256.0))) / 256.0
        let blue: CGFloat = num.truncatingRemainder(dividingBy: 256.0)
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    /// 设置随机色
    static func randomColor() -> UIColor {
        return UIColor.init(red: CGFloat(arc4random_uniform(256)), green: CGFloat(arc4random_uniform(256)), blue: CGFloat(arc4random_uniform(256)), alpha: 1)
    }
    
    
   
    
    /// Hex 十六进制返回颜色
    ///
    /// - Parameters:
    ///   - colorStr: 十六进制字符串
    ///   - alpha: 透明度
    /// - Returns: color
    static func colorString(_ colorStr:String, alpha:CGFloat=1) -> UIColor{
        var color = UIColor.clear
        var cStr : String = colorStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cStr.hasPrefix("#") {
            let index = cStr.index(after: cStr.startIndex)
            cStr = String(cStr[index...])
        }
        if cStr.hasPrefix("0X") {
            let index = cStr.index(after: cStr.startIndex)
            cStr = String(cStr[index...])
        }
        if cStr.count != 6 {
            return UIColor.clear
        }
        
        let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
        let rStr = String(cStr[rRange])
        
        let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
        let gStr = String(cStr[gRange])
        
        let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
        let bStr = String(cStr[bIndex...])
        
        color = UIColor(red: CGFloat(changeToInt(numStr: rStr)) / 255, green: CGFloat(changeToInt(numStr: gStr)) / 255, blue: CGFloat(changeToInt(numStr: bStr)) / 255, alpha: alpha)
        return color
    }
    
    ///生成RGBA颜色
    static func RGB(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat=1) -> UIColor
    {
        return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
    }
    
    ///hexColor(0xFF4500)
    static func hexColor(_ hexColor : Int64) -> UIColor {
        let red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0
        let green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0
        let blue = ((CGFloat)(hexColor & 0xFF))/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static func RANDCOLOR() -> UIColor {
        return self.RGB(CGFloat(arc4random_uniform(255)), CGFloat(arc4random_uniform(255)), CGFloat(arc4random_uniform(255)))
    }
    
}




private func changeToInt(numStr:String) -> Int {
    let str = numStr.uppercased()
    var sum = 0
    for i in str.utf8 {
        sum = sum * 16 + Int(i) - 48
        if i >= 65 {
            sum -= 7
        }
    }
    return sum
}
