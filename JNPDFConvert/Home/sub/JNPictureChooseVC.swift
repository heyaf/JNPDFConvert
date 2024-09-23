//
//  JNPictureChooseVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/23.
//

import UIKit

class JNPictureChooseVC: UIViewController {

    
//    private var imageViewStack: UIStackView!
    private var images: [UIImage]
    private let maxDisplayImages = 3
    var buttonAction: ((Int) -> Void)?
    let popupView = UIView()
    init(images: [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMaskLayer()
        setupPopupView()
        setupImageViewStack()
        setupButtons()
    }
    
    // 设置遮罩层
    private func setupMaskLayer() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 设置弹窗视图
    private func setupPopupView() {
        
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 20
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(376)
        }
    }
    
    // 设置图片展示区域
    private func setupImageViewStack() {
        let imageBg = UIView()
        
        popupView.addSubview(imageBg)
        
        imageBg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 176, height: 176))
        }
        
        let displayedImages = images.prefix(maxDisplayImages)  // 只获取前 maxDisplayImages 张图片
        var imageVArr: [UIImageView] = []

        // 遍历创建 UIImageView 并设置布局
        for index in 0..<min(displayedImages.count, 3) {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 14
            
            // 计算图片的位置
            let xOffset = 23 + 10 * index
            let yOffset = 20 - 10 * index
            imageView.frame = CGRect(x: xOffset, y: yOffset, width: 109, height: 154)
            
            // 设置图片
            imageView.image = displayedImages[index]
            
            // 将 UIImageView 添加到数组并添加到视图
            imageVArr.append(imageView)
            imageBg.addSubview(imageView)
            
            // 将当前 UIImageView 置于其他图片的后面
            imageBg.sendSubviewToBack(imageView)
        }


        // 添加角标
        let badgeLabel = UILabel()
        badgeLabel.text = "\(images.count)"
        badgeLabel.textColor = .white
        badgeLabel.font = boldSystemFont(ofSize: 18)
        badgeLabel.backgroundColor = MainColor
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 16
        badgeLabel.clipsToBounds = true
        popupView.addSubview(badgeLabel)
        
        badgeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(imageBg.snp.bottom)
            make.size.equalTo(CGSize(width: 43, height: 27))
        }
        
        
        let infoLabel = UILabel()
        infoLabel.text = "How would you like to proceed?"
        infoLabel.textColor = .black
        infoLabel.font = middleFont(ofSize: 20)
        infoLabel.backgroundColor = .white
        infoLabel.textAlignment = .center

        popupView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(imageBg.snp.bottom).offset(36)
            make.height.equalTo(20)
        }
    }
    
    // 设置按钮
    private func setupButtons() {
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit & Convert", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = boldSystemFont(ofSize: 18)
        editButton.backgroundColor = MainColor
        editButton.layer.cornerRadius = 16
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        popupView.addSubview(editButton)
        
        let convertButton = UIButton(type: .system)
        convertButton.setTitle("Convert", for: .normal)
        convertButton.setTitleColor(.white, for: .normal)
        convertButton.titleLabel?.font = boldSystemFont(ofSize: 18)
        convertButton.backgroundColor = MainColor
        convertButton.layer.cornerRadius = 16
        convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
        popupView.addSubview(convertButton)
        
        let width = (kScreenWidth - 40 - 32 - 10)/2
        // 按钮布局
        editButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(50)
            make.width.equalTo(width)
        }
        
        convertButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(50)
            make.width.equalTo(width)
            make.right.equalToSuperview().offset(-16)

        }
    }
    
    // Edit 按钮点击事件
    @objc private func editButtonTapped() {
        buttonAction?(0)
        dismissPopup()
    }
    
    // Convert 按钮点击事件
    @objc private func convertButtonTapped() {
        buttonAction?(1)
        dismissPopup()
    }
    
    // 点击遮罩层关闭弹窗
    @objc private func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }
}
