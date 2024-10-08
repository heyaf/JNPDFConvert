//
//  JNConversationDetailVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/29.
//

import UIKit

class JNConversationDetailVC: BaseViewController {

    var backToRoot = false
    var pathString: URL?
    var titleStr: String!
    var headerView : JNPDFDetailHeaderView!
    var image : UIImage!
    var mainImageV : UIImageView!
    var logoImageV : UIImageView!
    var fileSize = ""
    var filePath = ""
    let successLabel = UIFastCreatTool.createLabel("Successful conversion!", textColor: BlackColor, textAlignment:.center,alpha: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.title = titleStr
        
        // 设置界面
        setupWebView()
        setupGeneratePDFButton()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.mainImageV.y = kNavBarHeight + 98
            self.logoImageV.y = kNavBarHeight + 122
            self.mainImageV.alpha = 1
            self.logoImageV.alpha = 1
        } completion: {[self] Bool in
            successLabel.alpha = 1
        }
    }
    
    // 设置 WKWebView
    func setupWebView() {

        mainImageV = UIImageView(image: image)
        mainImageV.contentMode = .scaleAspectFill
        mainImageV.alpha = 0
        mainImageV.layer.cornerRadius = 6
        mainImageV.layer.masksToBounds = true
        view.addSubview(mainImageV)
        mainImageV.frame = CGRect(x: kScreenWidth/2 - 146/2, y: kNavBarHeight + 88, width: 146, height: 206)
        
        logoImageV = UIImageView(image: UIImage(named: "logo_pdf"))
        logoImageV.contentMode = .scaleAspectFill
        logoImageV.alpha = 0
        view.addSubview(logoImageV)
        logoImageV.frame = CGRect(x: kScreenWidth/2 - 146/2 - 14, y: kNavBarHeight + 112, width: 64, height: 43)
        successLabel.font = boldSystemFont(ofSize: 18)
        successLabel.frame = CGRect(x: 20, y:kNavBarHeight + 335, width: kScreenWidth - 40, height: 24)
        view.addSubview(successLabel)
    }
    
   
    
    
    // 设置生成 PDF 的按钮
    func setupGeneratePDFButton() {
        let button = UIButton(type: .system)
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = boldSystemFont(ofSize: 18)
        button.backgroundColor = MainColor
        button.setTitleColor(.white, for: .normal)
//        button.addGradationColor(width: Float(kScreenWidth) - 100, height: 59)

        button.setImage(UIImage(named: "detail_share_icon"), for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.tintColor = .white
        view.addSubview(button)
        let spacing: CGFloat = 14 // 图片和文字之间的间隔
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -button.imageView!.frame.size.width - spacing, bottom: 0, right: button.imageView!.frame.size.width + spacing)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: button.titleLabel!.intrinsicContentSize.width + spacing, bottom: 0, right: -button.titleLabel!.intrinsicContentSize.width - spacing)
        // 使用 SnapKit 设置按钮的约束
        button.snp.makeConstraints { make in
            make.height.equalTo(59)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-130)
        }
        

        // 按钮点击事件
        button.addTarget(self, action: #selector(sharePDFButtonTapped), for: .touchUpInside)
        
        let Delebutton = UIButton(type: .system)
        Delebutton.setTitle("Done", for: .normal)
        Delebutton.titleLabel?.font = boldSystemFont(ofSize: 18)
        Delebutton.backgroundColor = .white
        Delebutton.setTitleColor(BlackColor, for: .normal)
        Delebutton.tintColor = MainColor
        Delebutton.layer.cornerRadius = 16
        Delebutton.layer.masksToBounds = true
        Delebutton.layer.borderWidth = 2
        Delebutton.layer.borderColor = MainColor.cgColor
        view.addSubview(Delebutton)

      

        // 使用 SnapKit 设置按钮的约束
        Delebutton.snp.makeConstraints { make in
            make.height.equalTo(59)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-46)
        }
        
        // 按钮点击事件
        Delebutton.addTarget(self, action: #selector(DeletePDFButtonTapped), for: .touchUpInside)
    }
    
    // 生成 PDF 按钮的点击事件
    @objc func sharePDFButtonTapped() {
        guard !filePath.isEmpty else {
            return
        }
        JNFileUtil().shareFile(from: filePath, viewController: self)
        
    }
    @objc func DeletePDFButtonTapped() {
//        ProgressHUD.showSuccess("Delete Success")
//        AfterGCD(timeInval: 1.0) {
//            self.popToRootViewCon()
//        }
        guard !filePath.isEmpty else {
            return
        }
        let id = JNDataUtil.shared.saveData(image: image, title: titleStr, fileSize: JNDataUtil.shared.getFileSize(at: filePath), filePath: filePath)
        if id != nil {
            ProgressHUD.showSuccess("Save Success")
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Savedfile"),object: nil, userInfo: ["id":id ?? ""])
            AfterGCD(timeInval: 0.5) {
                self.popToRootViewCon()
                
            }

        }
    }
    
    
    
    open override func onBackClick(){
        if backToRoot {
            popToRootViewCon()

        }else{
            popViewCon()
        }
    }

}
