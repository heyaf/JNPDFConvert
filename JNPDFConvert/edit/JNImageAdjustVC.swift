//
//  JNImageAdjustVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/26.
//

import UIKit

class JNImageAdjustVC: UIViewController {

    var selectindex = 0
    var editImage:UIImage!
    var doneblock :((UIImage) -> ())?
    var cancleblock :(() -> ())?
    let buttonStack = UIView()
    let imageNames = ["Original","Auto","Black & White","Color","Clear","GrayScale"]
    let imageView = UIImageView()
    let buttonNames = ["Rotation", "Crop", "Filter", "Sign", "Adjust"]
    let buttonImage = ["Contrast_normal","editimage1_normal",
                       "editimage2_normal","editimage3_normal",
                       "editimage4_normal"]
    let buttonImage_sec = ["Contrast_select","editimage1_select",
                           "editimage2_select","editimage3_select",
                           "editimage4_select"]
    var buttonArr : [UIButton] = []
    lazy var edittitleLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 80, y: kScreenHeight - kBottomSafeHeight - 70 + 20, width: kScreenWidth - 160, height: 20)
        label.textColor = BlackColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.backgroundColor = .white
        label.text = "Adjust"
        return label
    }()
    var slider: JNImageAdjustSliderView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = grayColor
        setupBottomButtons()
        setupChooseBottomButtons()
    }
    
    func setupBottomButtons() {
        
        
        buttonStack.backgroundColor = .white
//        buttonStack.roundCorners(view: buttonStack, corners: [.topLeft,.topRight], radius: 14)
        view.addSubview(buttonStack)
        view.addSubview(edittitleLabel)
        

        let bHeight = 70 + kBottomSafeHeight
        buttonStack.frame = CGRect(x: 0, y: kScreenHeight - bHeight, width: kScreenWidth, height: bHeight)
        
        
        let cancleBtn = UIButton()
        cancleBtn.imageView?.contentMode = .center
        cancleBtn.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)
        cancleBtn.setImage(UIImage(named: "filter_close"), for: .normal)
        cancleBtn.backgroundColor = .white
        view.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(buttonStack.snp.top).offset(20)
            make.size.equalTo(28) // 图标 + 文字
        }
        
        let doneBtn = UIButton()
        doneBtn.imageView?.contentMode = .center
        doneBtn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneBtn.setImage(UIImage(named: "filter_done"), for: .normal)
        doneBtn.backgroundColor = .white
        view.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(buttonStack.snp.top).offset(20)
            make.size.equalTo(28) // 图标 + 文字
        }
        
        imageView.image = editImage
        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .red
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight + 8)
            make.left.equalTo(view).offset(8)
            make.right.equalTo(view).offset(-8)
            make.bottom.equalToSuperview().inset(kBottomSafeHeight + 80 + 135)
        }
        
    }
    func setupChooseBottomButtons() {
        
        
        let layerView = UIView()
        layerView.backgroundColor = .white
        layerView.layer.cornerRadius = 15
        layerView.layer.masksToBounds = true
        view.addSubview(layerView)
        
        let buttonBG = UIView()
        buttonBG.backgroundColor = .white
        view.addSubview(buttonBG)
        buttonBG.backgroundColor = .white
        let bHeight = 70 + kBottomSafeHeight
        buttonBG.frame = CGRect(x: 0, y: kScreenHeight - bHeight - 50 - 50 , width: kScreenWidth, height: 50)
        
        layerView.frame = CGRect(x: 0, y: buttonBG.y - 15, width: kScreenWidth, height: 30)
        
        for (index, buttonName) in buttonNames.enumerated() {
            let button = createBottomButton(name: buttonName, imagename: buttonImage[index],imageSelectname: buttonImage_sec[index])
            button.tag = 10000 + index
            
            
            let btnW = (kScreenWidth - 44 - 5 * 4)/5
            button.frame = CGRect(x: 22 + CGFloat(index) * (btnW + 5), y: 0, width: btnW, height: 40)
            button.imagePosition(style: .top, spacing: 6)
            
            buttonBG.addSubview(button)
            if index == 0 {
                button.isSelected = true
            }
            buttonArr.append(button)
        }
        slider = JNImageAdjustSliderView(frame: CGRect(x: 0, y: buttonBG.bottom, width: kScreenWidth, height: 50))
        slider?.backgroundColor = .white
        view.addSubview(slider!)
        slider?.onValueChanged = {[self] value in
            changeValueAction(value: value)
        }
        
        
    }
    func changeValueAction(value:Int){
        let adjustments = editImage?.convertValueToAdjustments(value: Float(value))
        switch selectindex {
        case 0:
            // 调整对比度
            if let contrast = adjustments?.contrast ,let adjustedImage = editImage?.adjustedContrast(contrast) {
                imageView.image = adjustedImage
            }
        case 1:
            // 调整对比度
            if let contrast = adjustments?.saturation ,let adjustedImage = editImage?.adjustedSaturation(contrast) {
                imageView.image = adjustedImage
            }
        case 2:
            // 调整亮度
            if let contrast = adjustments?.brightness ,let adjustedImage = editImage?.adjustedBrightness(contrast) {
                imageView.image = adjustedImage
            }
        case 3:
            // 调整对比度
            if let contrast = adjustments?.exposure ,let adjustedImage = editImage?.adjustedExposure(contrast) {
                imageView.image = adjustedImage
            }
        case 4:
            // 调整对比度
            if let contrast = adjustments?.gamma ,let adjustedImage = editImage?.adjustedGamma(contrast) {
                imageView.image = adjustedImage
            }
            
        default: break
            
        }

    }
    func createBottomButton(name: String, imagename: String,imageSelectname: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(name, for: .normal)
        button.titleLabel?.font = boldSystemFont(ofSize: 14)
        button.setTitleColor(.hex("#141416").withAlphaComponent(0.6), for: .selected)
        button.setTitleColor(.hex("#141416").withAlphaComponent(0.4), for: .normal)

        button.setImage(UIImage(named: imagename), for: .normal)
        button.setImage(UIImage(named: imageSelectname), for: .selected)

        // 按钮点击事件
        button.addTarget(self, action: #selector(bottomButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    @objc func cancleButtonTapped() {
        print("Done 按钮点击")
        dismiss(animated: false)
        cancleblock?()
    }
    @objc func doneButtonTapped() {
        print("Done 按钮点击")
        dismiss(animated: false)
        doneblock?(self.imageView.image!)
    }
    @objc func bottomButtonTapped(_ sender: UIButton) {
        for item in buttonArr {
            item.isSelected = false
        }
        selectindex = sender.tag - 10000
        sender.isSelected = true
        slider?.resetValue()
        // 取消其他按钮选中状态
        let titleStr = sender.title(for: .normal) ?? ""
        if titleStr == buttonNames[0] {
            
        }
    }

}
