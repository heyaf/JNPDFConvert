//
//  JNImportChooseView.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/10/10.
//

import UIKit

class JNImportChooseView: UIView {

    
     // UI元素
     private var dimmingView: UIView!
     private var popupView: UIView!
     private var titleLabel: UILabel!

     private var closeButton: UIButton!
     
     // 回调函数，点击确定按钮时触发
     var onConfirm: ((Int) -> Void)?
     
     // 初始化方法
     init(frame: CGRect, title: String) {
         super.init(frame: frame)
         setupUI(title: title)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     // 初始化UI
     private func setupUI(title: String) {
         // 创建遮罩层
         dimmingView = UIView(frame: self.bounds)
         dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
         self.addSubview(dimmingView)
         
         // 点击遮罩层时隐藏弹窗
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopup))
         dimmingView.addGestureRecognizer(tapGesture)
         
         // 创建弹窗视图
         popupView = UIView(frame: CGRect(x: 18, y: self.frame.height / 2 - 150, width: self.frame.width - 36, height: 225))
         popupView.backgroundColor = UIColor.white
         popupView.layer.cornerRadius = 20
         popupView.layer.masksToBounds = true
         self.addSubview(popupView)
         
         // 添加标题
         titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: popupView.frame.width, height: 40))
         titleLabel.text = title
         titleLabel.textAlignment = .center
         titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
         popupView.addSubview(titleLabel)
         
         // 添加关闭按钮 (叉号)
         closeButton = UIButton(frame: CGRect(x: popupView.frame.width - 50, y: 15, width: 30, height: 30))
 //        closeButton.setTitle("✕", for: .normal)
 //        closeButton.setTitleColor(.black, for: .normal)
         closeButton.setBackgroundImage(UIImage(named: "url_pdf_close"), for: .normal)
         closeButton.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
         popupView.addSubview(closeButton)
         
         let btn = UIButton(type: .custom)
         btn.frame = CGRect(x: 18, y: 77, width: kScreenWidth - 72, height: 50)
         btn.backgroundColor = .hex("#ACB4BE").withAlphaComponent(0.2)
         popupView.addSubview(btn)
         btn.addClickAction(action: confirmButtonTapped(_:))
         btn.layer.cornerRadius = 10
         btn.layer.masksToBounds = true
         
         let imageView = UIImageView(image: UIImage(named: "ic_history"))
         imageView.frame = CGRect(x: 14, y: 7, width: 36, height: 36)
         btn.addSubview(imageView)
         
         let lab = UIFastCreatTool.createLabel("Select from history",fontSize: 16,textColor: BlackColor)
         lab.frame = CGRect(x: 60, y: 16, width: kScreenWidth - 72 - 80, height: 19)
         lab.backgroundColor = .clear
         btn.addSubview(lab)
          
         
         let btn2 = UIButton(type: .custom)
         btn2.frame = CGRect(x: 18, y: 143, width: kScreenWidth - 72, height: 50)
         btn2.backgroundColor = .hex("#ACB4BE").withAlphaComponent(0.2)
         popupView.addSubview(btn2)
         btn2.addClickAction(action: confirmButtonTapped(_:))
         btn2.layer.cornerRadius = 10
         btn2.layer.masksToBounds = true
         
         let imageView2 = UIImageView(image: UIImage(named: "ic_files"))
         imageView2.frame = CGRect(x: 14, y: 7, width: 36, height: 36)
         btn2.addSubview(imageView2)
         
         let lab2 = UIFastCreatTool.createLabel("Select from files app",fontSize: 16,textColor: BlackColor)
         lab2.frame = CGRect(x: 60, y: 16, width: kScreenWidth - 72 - 80, height: 19)
         lab2.backgroundColor = .clear
         btn2.addSubview(lab2)
         btn.tag = 888
         btn2.tag = 889
         lab.font = middleFont(ofSize: 16)
         lab2.font = middleFont(ofSize: 16)

     }
     
     // 确定按钮点击事件
    @objc private func confirmButtonTapped(_ btn : UIButton) {
        onConfirm?(btn.tag - 888)
         hidePopup()
     }
     
     // 隐藏弹窗
     @objc private func hidePopup() {
         self.removeFromSuperview()
     }
     
     // 显示弹窗
     func show(in view: UIView) {
         view.addSubview(self)
     }
     
 }
