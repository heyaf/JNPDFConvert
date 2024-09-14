//
//  UIView+Extion.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
import UIKit

public extension UIView {
  
    /// x
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    var centerX: CGFloat {
        get { return self.center.x }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    var centerY: CGFloat {
        get { return self.center.y }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    /// height
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    /// width
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    /// size
    var size: CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    // 获取距离父控件左边的位置
    func left() -> CGFloat {
        return frame.origin.x
    }
    // 设置距离父控件左边的位置
    func setLeft(left: CGFloat) {
        frame.origin.x = left
    }
    
    // 获取控件右边距离父控件的位置
    func right() -> CGFloat {
        return frame.maxX
    }
    // 设置控件右边距离父控件的位置
    func setRight(right: CGFloat) {
        frame.origin.x = right - self.width
    }
    
    // 获取距离父控件上面的位置
    func top() -> CGFloat {
        return frame.origin.y
    }
    // 设置距离父控件上面的位置
    func setTop(top: CGFloat) {
        frame.origin.y = top
    }
    
    // 获取控件下面距离父控件的位置
    func bottom() -> CGFloat {
        return frame.maxY
    }
    // 设置控控件下面距离父控件的位置
    func setBottom(bottom: CGFloat) {
        frame.origin.y = bottom - self.height
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
