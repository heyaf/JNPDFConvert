//
//  JNImagesCropVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/25.
//

import UIKit
import PEPhotoCropEditor
class JNImagesCropVC: BaseViewController {
    var editImage : UIImage! = UIImage()
    var cropbgView : PECropView = PECropView()
    var doneblock :((UIImage) -> ())?
    lazy var doneBtn:UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = boldSystemFont(ofSize: 18)
        button.setTitleColor(MainColor, for: .normal)
        button.backgroundColor = .clear
        button.setTitle("Done", for: .normal)

        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.title = "Crop"
        view.backgroundColor = BlackColor
        setUpUI()
    }
    func setUpUI(){
        
        view.addSubview(doneBtn)
        
        doneBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(statusBarHeight + 12)
            make.height.equalTo(20)
        }
        let cropView = PECropView.init(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenWidth, height: kScreenHeight - kNavBarHeight))
        cropView.image = editImage
        cropView.backgroundColor = BlackColor
        cropbgView = cropView
        view.addSubview(cropView)
        view.sendSubviewToBack(cropView)
    }
    @objc func doneButtonTapped() {
        
        // 处理 Done 按钮点击事件
        doneblock?(cropbgView.croppedImage)
        popViewCon()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cropbgView.removeFromSuperview()
    }

}
