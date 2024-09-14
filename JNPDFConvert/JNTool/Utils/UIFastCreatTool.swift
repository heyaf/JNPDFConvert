//
//  UIFastCreatTool.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
import UIKit
class UIFastCreatTool{
    /// 快速构建Label
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - fontSize: 字体大小 默认16
    ///   - textColor: 文本颜色 默认白色
    ///   - line: 文本行数 默认0
    ///   - isBold: 字体是否加粗
    /// - Returns: 返回Label对象
    public static func createLabel(_ text:String = "", fontSize:CGFloat = 16, textColor:UIColor = .white, line:Int = 0, textAlignment:NSTextAlignment = .left, alpha: CGFloat = 1.0) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont(name: "Nunito-Regular", size:  fontSize)
        label.numberOfLines = line
        label.textAlignment = textAlignment
        label.alpha = alpha
        label.sizeToFit()
        return label
    }
    
    /// 快速构建Button
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - fontSize: 字体大小 默认16
    ///   - textColor: 文本颜色 默认白色
    ///   - insets: 扩大相应区域 (参考系=>负数减小 正数扩大)
    ///   - isBold: 是否加粗
    /// - Returns: 返回Button对象
    public static func createButton(_ text:String = "", fontSize:CGFloat = 16, textColor:UIColor = UIColor.white) -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.text = text
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Regular", size:  fontSize)
        return button
    }
    
    ///创建标签label
    public static func createMarkLabel(_ text: String, fontSize:CGFloat = 11,  textColor:UIColor , bgColor:UIColor , radius: CGFloat = 9) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont(name: "Nunito-Regular", size:  fontSize)
        label.textColor = textColor
        label.backgroundColor = bgColor
        label.layer.cornerRadius = radius
        label.layer.masksToBounds = true
        return label
    }
    
    /// 快速构建Button
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - fontSize: 字体大小 默认16
    ///   - textColor: 文本颜色 默认白色
    ///   - insets: 扩大相应区域 (参考系=>负数减小 正数扩大)
    ///   - isBold: 是否加粗
    /// - Returns: 返回Button对象
    public static func createButton(normalImage: UIImage?, _ selectImage: UIImage? = nil) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(normalImage, for: .normal)
        button.setImage(selectImage, for: .selected)
        return button
    }
    
    /// 快速构建TaleView
    ///
    /// - Parameter vc: 当前所属ViewController
    /// - Returns: 返回TaleView对象
    public static func createTableView(_ vc:UIViewController, isNavHidden:Bool = false, isHiddenTabBar:Bool = false) -> UITableView {
        let tableView = UITableView.init(frame: CGRect(), style: .plain)
        tableView.backgroundColor = UIColor .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = vc as? UITableViewDataSource
        tableView.delegate = vc as? UITableViewDelegate
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never;
        } else {
            vc.automaticallyAdjustsScrollViewInsets = false;
        }
        
        vc.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
//            if isNavHidden == true {
                make.top.equalToSuperview()
//            }else {
//                make.top.equalTo(kDefaultNavHeight)
//            }
            make.left.right.equalToSuperview()
//            if (isHiddenTabBar == true) {
                make.bottom.equalToSuperview()
//            }else {
//                make.bottom.equalTo(-TabBarHeight)
//            }
        }
        
        return tableView
    }
    

    
  
    
    /**
     * 线条
     */
    public static func getLine(_ color: UIColor = UIColor.hexString("#F0F0F0")) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        return line
    }

    public static func createView(backgroundColor:UIColor = .white, alpha: CGFloat = 1 , cornerRadius:CGFloat = 0)->UIView{
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.alpha = alpha
        if cornerRadius > 0 {
            view.layer.cornerRadius = cornerRadius
        }
        return view
    }
    
    /// 快速创建ImageView
    public static func createImageView(_ imageStr: String = "picture_defalut") -> UIImageView {
        if imageStr.count > 0 {
            let imageView = UIImageView.init(image: UIImage(named:imageStr))
            imageView.contentMode = .scaleAspectFill
            return imageView
        }
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    /// 快速创建ImageView
    public static func createHeadImageView(_ imageStr: String = "default_avatar") -> UIImageView {
        if imageStr.count > 0 {
            let imageView = UIImageView.init(image: UIImage(named:imageStr))
            imageView.contentMode = .scaleAspectFill
            return imageView
        }
        let imageView = UIImageView()
        return imageView
    }
    
    /// 快速创建富文本
    /// - Parameter totalString: 全文
    /// - Parameter subString: 需要富文本的文字
    /// - Parameter font: 字体大小
    /// - Parameter textColor: 颜色
    public static func changeFontColor(totalString: String, subString: String, font: UIFont, textColor: UIColor)-> NSMutableAttributedString {
        let attStr = NSMutableAttributedString.init(string: totalString)
        guard let range: Range = totalString.range(of: subString) else {return attStr}
        let location = totalString.distance(from: subString.startIndex, to: range.lowerBound)
        attStr.addAttributes([NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font], range:
            NSRange.init(location: location, length: subString.count))
        return attStr
    }
}
