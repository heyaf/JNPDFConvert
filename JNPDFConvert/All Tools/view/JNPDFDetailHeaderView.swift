//
//  JNPDFDetailHeaderView.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/24.
//

import UIKit

class JNPDFDetailHeaderView: UIView {

   
    // 创建label和imageView
    private let label = UILabel()
    private let imageView = UIImageView()
    var editBlock : (() -> ())?
    var titleStr : String = ""
    // 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTapGesture()
    }
    // 初始化方法
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        setupUI()
        titleStr = title
        setupTapGesture()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupTapGesture()
    }

    private func setupUI() {
        // 设置label属性
        label.text = titleStr
        label.font = boldSystemFont(ofSize: 16)
        label.textColor = BlackColor
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // 设置imageView属性
        imageView.image = UIImage(named: "edit_icon_detail") // 替换成你的图标
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 18, height: 18)) // 设置图片尺寸
        }

        // 将label和imageView添加到视图中
        self.addSubview(label)
        self.addSubview(imageView)

        // 使用SnapKit进行布局
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // label的x中心与父视图x中心相同
            make.centerY.equalToSuperview() // 垂直居中
        }

        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview() // 与label垂直居中
            make.leading.equalTo(label.snp.trailing).offset(10) // 与label保持10像素间距
        }
    }

    // 点击手势处理
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }

    // 点击时改变label内容
    @objc private func handleTap() {
        editBlock?()
        // 更新布局
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    func changeTitle(title:String) {
        label.text = title
        
        // 更新布局
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}
