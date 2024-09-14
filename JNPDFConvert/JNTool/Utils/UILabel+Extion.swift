//
//  UILabel+Extion.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
import UIKit
// MARK:- 富文本插入图片位置
public enum ImgAttributePosition {
    case first, last
}


public extension UILabel {
    
    /// 改变label部分文字属性
    ///
    /// - Parameters:
    ///   - partText: 要改变的部分文字
    ///   - font: 字体大小
    ///   - fontName: 字体样式
    ///   - fontColor: 字体颜色
    func attributedFont(partText: String, font: CGFloat, fontName: String? = nil, fontColor: UIColor? = nil) {
        guard let content = self.attributedText else { return }
        let allText = NSMutableAttributedString(attributedString: content)
        let range = NSRange(location: (allText.string as NSString).range(of: partText).location, length: (allText.string as NSString).range(of: partText).length)
        
        // 设置字体颜色
        if let fontColor = fontColor {
            allText.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: range)
        }
        // 设置字体大小和字体样式
        var fontValue: UIFont?
        if let fontName = fontName {
            fontValue = UIFont(name: fontName, size: font)
        } else {
            fontValue = UIFont.systemFont(ofSize: font)
        }
        guard let value = fontValue else { return }
        allText.addAttribute(NSAttributedString.Key.font, value: value, range: range)
        
        self.attributedText = allText
    }
    
    
    /// 创建带有图片的Label
    func attributedImage(image: UIImage, frame: CGRect, _ position: ImgAttributePosition = .last) {
        guard let content = self.text else { return }
        let attri = NSMutableAttributedString(string: content)
        
        // NSTextAttachment可以将要插入的图片作为特殊字符处理
        let attch = NSTextAttachment()
        
        // 定义图片内容及位置和大小
        attch.image = image
        attch.bounds = frame
        
        // 创建带有图片的富文本
        let newAttri = NSAttributedString(attachment: attch)
        
        // 判断图片要穿插的位置
        if position == .first {
            attri.insert(newAttri, at: 0)
        }
        
        // 用label的attributedText属性来使用富文本
        self.attributedText = attri
    }
    
    
    /// 获取文字的CGSize
    func textSize(_ font : UIFont, _ maxSize : CGSize) -> CGSize? {
        return self.text?.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    
    
    /// 根据文字内容自适应大小
    ///
    /// - Parameters:
    ///   - maxSize: 最大size
    func fitTextSize(_ maxSize : CGSize) {
        let size = self.sizeThatFits(maxSize)
        self.frame = CGRect.init(x: self.x, y: self.y, width: size.width, height: size.height)
    }
    
    ///下划线
    func addUnderLine() {
        guard let text = self.text else { return }
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.addAttribute(.underlineStyle, value: 1, range: NSRange(location: 0, length: text.count))
        attributedText = attrStr
    }
}
