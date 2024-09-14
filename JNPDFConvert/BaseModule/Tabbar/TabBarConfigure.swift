//
//  TabBarConfigure.swift
//  Extend
//
//  Created by 郑浩 on 2018/4/18.
//  Copyright © 2018年 敬信. All rights reserved.
//

import Foundation
import UIKit

public class TabBarConfigure {
    var bgColor: UIColor?
    var titleFont: UIFont?
    var unselectTitleColor: UIColor?
    var selectTitleColor: UIColor?
    
    ///图片和文字间距离
    var verticalSpace: CGFloat = 0
    
    fileprivate init() {
        
    }
    
    public class func newBuilder() -> TabBarConfigBuilder {
        return TabBarConfigBuilder();
    }
}

public class TabBarConfigBuilder {
    var bgColor: UIColor?
    var titleFont: UIFont?
    var unselectTitleColor: UIColor?
    var selectTitleColor: UIColor?
    
    var verticalSpace: CGFloat = 0
    
    fileprivate init() {
        
    }
    
    public func bgColor(_ color: UIColor) -> Self {
        self.bgColor = color
        return self
    }
    
    public func titleFont(_ font: UIFont) -> Self {
        self.titleFont = font
        return self
    }
    
    public func unselectTitleColor(_ color: UIColor) -> Self {
        self.unselectTitleColor = color
        return self
    }
    
    public func selectTitleColor(_ color: UIColor) -> Self {
        self.selectTitleColor = color
        return self
    }
    
    public func verticalSpace(_ space: CGFloat) -> Self {
        self.verticalSpace = space
        return self
    }
    
    public func build() -> TabBarConfigure {
        let configure = TabBarConfigure()
        configure.bgColor = bgColor
        configure.titleFont = titleFont
        configure.unselectTitleColor = unselectTitleColor
        configure.selectTitleColor = selectTitleColor
        configure.verticalSpace = verticalSpace
        return configure;
    }
}
