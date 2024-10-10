//
//  JNImportDocumentViewController.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/10/10.
//

import UIKit

class JNImportDocumentViewController: UIViewController {
    let backBtn :UIButton = {
        let cancleBtn = UIButton()
        cancleBtn.imageView?.contentMode = .center
        cancleBtn.setImage(UIImage(named: "back_black"), for: .normal)
        cancleBtn.backgroundColor = .clear
        cancleBtn.frame = CGRect(x: 10, y: statusBarHeight, width: 40, height: 44)
       return cancleBtn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let frame =  CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavBarHeight + 80)
        let gradientView = UIView(frame: frame) // 设置视图的大小
        self.view.addSubview(gradientView)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [MainColor.withAlphaComponent(0.1).cgColor,UIColor.white.cgColor] // 渐变颜色
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(backBtn)

        // 设置标题
        let titleLabel = UILabel()
        titleLabel.text = "Importing documents from other applications"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        // 使用富文本设置内容
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.attributedText = createAttributedText()
        view.addSubview(contentLabel)
        
        // 图片视图 (这里需要替换为你的图像)
        let imageView = UIImageView(image: UIImage(named: "share_Icon"))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        let button = UIButton(type: .system)
        button.setTitle("I got it", for: .normal)
        button.titleLabel?.font = boldSystemFont(ofSize: 18)
        button.backgroundColor = MainColor
        button.setTitleColor(.white, for: .normal)
        button.addGradationColor(width: Float(kScreenWidth) - 40, height: 59)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addClickAction(action: dismissViewController)
        view.addSubview(button)
        
        // 使用 SnapKit 设置按钮的约束
        button.snp.makeConstraints { make in
            make.height.equalTo(59)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        
        // 使用 SnapKit 进行布局
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
        }
        backBtn.addClickAction(action: dismissViewController)
       
    }
    
    // 创建富文本
    func createAttributedText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: "You can import documents from any app that supports Open In () feature.\n\nStep1: Open the app that has the document you want to convert.\n\nStep2: Select the document and press Open in ( ) button or menu option.\n\nStep3: Select Copy to Image Converter to import the document.\n\n",
            attributes: [
                .font: middleFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ])
        
        // Step1 (加粗的部分)
        let step1Range = (attributedString.string as NSString).range(of: "Step1:")
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: step1Range)
        
        // Step2 (加粗的部分)
        let step2Range = (attributedString.string as NSString).range(of: "Step2:")
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: step2Range)
        
        // Step3 (加粗的部分)
        let step3Range = (attributedString.string as NSString).range(of: "Step3:")
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: step3Range)
        
        let step31Range = (attributedString.string as NSString).range(of: "You can import documents from any app that supports Open In (")
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: step31Range)
        
        let step32Range = (attributedString.string as NSString).range(of: ") feature.")
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: step32Range)
        // Open In (红色)
        let openInRange = (attributedString.string as NSString).range(of: "Open In")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: openInRange)
        
        let openInRange1 = (attributedString.string as NSString).range(of: "Open in")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: openInRange1)
        // Copy to PDF Convert (红色)
        let copyToPDFRange = (attributedString.string as NSString).range(of: "Copy to Image Converter")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: copyToPDFRange)
        
        // 添加系统图标到步骤中的指定位置
        let attachment = NSTextAttachment()
        if let shareImage = UIImage(named: "share_logo")?.withTintColor(.blue, renderingMode: .alwaysOriginal) {
            attachment.image = shareImage
        }
        let attachmentString = NSAttributedString(attachment: attachment)
        attributedString.insert(attachmentString, at: openInRange.location + openInRange.length + 2)
        attributedString.insert(attachmentString, at: openInRange1.location + openInRange1.length + 3)  // 再次插入图标到另一个位置
        
        return attributedString
    }
    
    // 按钮动作
    @objc func dismissViewController(button:UIButton) {
        popViewCon()
    }
    
}
