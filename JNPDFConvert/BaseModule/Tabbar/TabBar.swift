//
//  LLTabBar.swift
//  Lib
//
//  Created by 迦南 on 2018/7/4.
//  Copyright © 2018年 ray. All rights reserved.
//

import UIKit

class TabBar: UITabBar {
    // 上一次点击位置
    fileprivate var lastIndex: Int? = nil

    private let kBaseTag = 889900

    private let beginFrame: CGFloat = 0
    private let selectedEndFrame: CGFloat = 11
    private let unselectedEndFrame: CGFloat = 21

    private let kBeginAnimationProgress: CGFloat = 0.0
    private let kEndAnimationProgress: CGFloat = 1.0

    @objc dynamic var tabImageViewDefaultOffset: CGFloat = 0.0 /// tabBar图片的偏移量
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        tintColor = UIConfig.hexString("#8F61FF")
//        self.shadowImage = UIImage()
        self.tintColor = .white
        self.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.6)
        self.backgroundColor = .white
        self.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.layer.shadowColor = UIColor.hexString("#dddddd").withAlphaComponent(0.3).cgColor
        self.layer.shadowOpacity = 5
        self.layer.shadowRadius = 2
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabBar {
    // MARK: 设置全局tabBar字体颜色, 和文字大小
    class func setupTabBarAttribute(_ norTextColor: UIColor?, _ selTextColor: UIColor?, _ font: UIFont?) {
        
        let item = UITabBarItem.appearance()
        
        // 设置按钮选中标题的颜色:富文本:描述一个文字颜色,字体,阴影,空心,图文混排
        var attrsSel = [NSAttributedString.Key : Any]()
        
        if let selTextColor = selTextColor {
            attrsSel[NSAttributedString.Key.foregroundColor] = selTextColor
            item.setTitleTextAttributes(attrsSel, for: .selected)
        }
        
        
        // 设置字体尺寸:只有设置正常状态下,才会有效果
        var attrsNor = [NSAttributedString.Key : Any]()
        
        if let norTextColor = norTextColor {
            attrsNor[NSAttributedString.Key.foregroundColor] = norTextColor
        }
        if let font = font {
            attrsNor[NSAttributedString.Key.font] = font
        }
        
        item.setTitleTextAttributes(attrsNor, for: .normal)

    }
    
    
    
}


extension TabBar {





}

extension TabBar {
    
    /// 显示小红点
    ///
    /// - Parameter index: index
//    public func showChatBarCount(_ count: Int) {
//        
////        self.removeBadgeOnItemIndex(2)
//        redLabel.isHidden = count == 0
//        redLabel.tag = 10086 + 2
//        redLabel.text = "\(count)"
//        let x = self.lx.width/4.0/2.0 + 10
//        if count > 0 {
//            var width: CGFloat = 18
//            if count > 9 && count <= 99{
//                width = 24
//            } else if count > 99 {
//                width = 32
//            }
//            redLabel.frame = CGRect(x: kScreenWidth/2 + x, y: 5, width: width, height: 18)
//        }
//
//        
//    }
    
    
    
//    func showChatBarCount(_ count: Int) {
//        removeBadgeOnItemIndex(100001)
//        self.addSubview(redLabel)
//
//        redLabel.tag = 100001
//        redLabel.text = count > 99 ? "\(count)+" : "\(count)"
//        redLabel.isHidden = count == 0
//        let left = self.lx.width/5.0/2.0 + 15
//        if count > 0 {
//            var width: CGFloat = 18
//            if count > 9 && count <= 99{
//                width = 24
//            } else if count > 99 {
//                width = 32
//            }
//            redLabel.snplayout {
//                $0.left.equalTo(left)
//                $0.top.equalTo(5)
//                $0.height.equalTo(18)
//                $0.width.equalTo(width)
//            }
//        } else {
//            redLabel.snplayout {
//                $0.left.equalTo(left)
//                $0.top.equalTo(5)
//                $0.right.equalTo(-15.5)
//                $0.size.equalTo(0)
//            }
//        }
        
//    }
    
    
    /// 隐藏小红点
    ///
    /// - Parameter index: index
//    public func hideBadgeOnItemIndex(_ index: Int) {
//        self.removeBadgeOnItemIndex(index)
//    }
////
////    /// 移除小红点内部方法
////    ///
////    /// - Parameter index: index
//    private func removeBadgeOnItemIndex(_ index: Int) {
//        for item in self.subviews {
//            if item.tag == 100001 {
//                item.removeFromSuperview()
//            }
//        }
//    }
}

