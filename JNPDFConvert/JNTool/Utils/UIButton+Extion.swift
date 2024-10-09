//
//  UIButton+Extion.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/24.
//

import Foundation
// MARK: - 点击事件闭包与扩充点击范围
typealias BtnAction = (UIButton)->()
extension UIButton {
    private struct AssociatedKeys{
            static var actionKey = "actionKey"
        }
    @objc dynamic var action: BtnAction? {
           set{
               objc_setAssociatedObject(self,&AssociatedKeys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
           }
           get{
               if let action = objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? BtnAction{
                   return action
               }
               return nil
           }
       }

    func addGradationColor(width:Float,height:Int) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.hex("#F13236").cgColor, UIColor.hex("#D60005").cgColor] // 渐变颜色
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: Int(width), height: height)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    /// 添加一个点击事件
        /// - Parameter action: 点击时执行的闭包
        @discardableResult // 消除未使用返回值时的警告
        func addClickAction(action:@escaping BtnAction) -> UIButton {
            return self.addEvent(event: .touchUpInside, action: action)
        }
        
        
        /// 添加一个事件
        /// - Parameters:
        ///   - event: 添加的事件
        ///   - action: 事件响应时执行的闭包
        @discardableResult //消除未使用返回值时的警告
        func addEvent(event:UIControl.Event, action:@escaping  BtnAction ) -> UIButton{
            self.action = action
            self.addTarget(self, action: #selector(touchUpInSideBtnAction), for: event)
            return self
        }

        @objc func touchUpInSideBtnAction(btn: UIButton) {
             if let action = self.action {
                 action(btn)
             }
        }

    enum RGButtonImagePosition {
            case top          //图片在上，文字在下，垂直居中对齐
            case bottom       //图片在下，文字在上，垂直居中对齐
            case left         //图片在左，文字在右，水平居中对齐
            case right        //图片在右，文字在左，水平居中对齐
        }
        
        
        /// - Description 设置Button图片的位置
        /// - Parameters:
        ///   - style: 图片位置
        ///   - spacing: 按钮图片与文字之间的间隔
        func imagePosition(style: RGButtonImagePosition, spacing: CGFloat) {
            //得到imageView和titleLabel的宽高
            let imageWidth = self.imageView?.frame.size.width
            let imageHeight = self.imageView?.frame.size.height
            var labelWidth: CGFloat! = 0.0
            var labelHeight: CGFloat! = 0.0
            labelWidth = self.titleLabel?.intrinsicContentSize.width
            labelHeight = self.titleLabel?.intrinsicContentSize.height
            //初始化imageEdgeInsets和labelEdgeInsets
            var imageEdgeInsets = UIEdgeInsets.zero
            var labelEdgeInsets = UIEdgeInsets.zero
            //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
            switch style {
            case .top:
                //上 左 下 右
                imageEdgeInsets = UIEdgeInsets(top: -labelHeight-spacing/2, left: 0, bottom: 0, right: -labelWidth)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-spacing/2, right: 0)
                break;
            case .left:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
                break;
            case .bottom:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-spacing/2, right: -labelWidth)
                labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-spacing/2, left: -imageWidth!, bottom: 0, right: 0)
                break;
            case .right:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+spacing/2, bottom: 0, right: -labelWidth-spacing/2)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-spacing/2, bottom: 0, right: imageWidth!+spacing/2)
                break;
            }
            self.titleEdgeInsets = labelEdgeInsets
            self.imageEdgeInsets = imageEdgeInsets
        }
    @objc func buttonaddAnimation() {
        // 缩放动画
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
}
