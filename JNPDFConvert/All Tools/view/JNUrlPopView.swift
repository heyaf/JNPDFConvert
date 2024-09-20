//
//  JNUrlPopView.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/20.
//

import UIKit

class JNUrlPopView: UIView {

    
    // UI元素
    private var dimmingView: UIView!
    private var popupView: UIView!
    private var titleLabel: UILabel!
    private var textField: UITextField!
    private var confirmButton: UIButton!
    private var closeButton: UIButton!
    
    // 回调函数，点击确定按钮时触发
    var onConfirm: ((String?) -> Void)?
    
    // 初始化方法
    init(frame: CGRect, title: String, confirmButtonText: String) {
        super.init(frame: frame)
        setupUI(title: title, confirmButtonText: confirmButtonText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化UI
    private func setupUI(title: String, confirmButtonText: String) {
        // 创建遮罩层
        dimmingView = UIView(frame: self.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(dimmingView)
        
        // 点击遮罩层时隐藏弹窗
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopup))
        dimmingView.addGestureRecognizer(tapGesture)
        
        // 创建弹窗视图
        popupView = UIView(frame: CGRect(x: 18, y: self.frame.height / 2 - 150, width: self.frame.width - 36, height: 246))
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
        closeButton = UIButton(frame: CGRect(x: popupView.frame.width - 40, y: 10, width: 30, height: 30))
//        closeButton.setTitle("✕", for: .normal)
//        closeButton.setTitleColor(.black, for: .normal)
        closeButton.setBackgroundImage(UIImage(named: "url_pdf_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
        popupView.addSubview(closeButton)
        
        // 添加输入框
        textField = UITextField(frame: CGRect(x: 20, y: 77, width: popupView.frame.width - 40, height: 50))
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter URL"
        textField.backgroundColor = .hex("#F3F3F3")
        popupView.addSubview(textField)
        
        // 添加确定按钮
        confirmButton = UIButton(frame: CGRect(x: 96, y: 170, width: popupView.frame.width - 192, height: 46))
        confirmButton.setTitle(confirmButtonText, for: .normal)
        confirmButton.titleLabel?.font = boldSystemFont(ofSize: 18)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = MainColor
        confirmButton.layer.cornerRadius = 16
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        popupView.addSubview(confirmButton)
    }
    
    // 确定按钮点击事件
    @objc private func confirmButtonTapped() {
        onConfirm?(textField.text)
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
