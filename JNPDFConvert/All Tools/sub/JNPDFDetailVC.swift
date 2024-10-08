//
//  JNPDFDetailVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/24.
//

import UIKit
import WebKit
class JNPDFDetailVC: BaseViewController {
    var backToRoot = false
    var webView: WKWebView!
    var pathString: URL?
    var titleStr: String!
    var headerView : JNPDFDetailHeaderView!
    var fileId = ""
    var image:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.title = "Detail"
        titleStr = String().generateImageString(geshi: "PDF")
        // 设置界面
        setupWebView()
        setupGeneratePDFButton()
        //        view.backgroundColor = .RGB(241, 241, 245)
        if let pathString = pathString {
            // 确保路径有效且文件存在
            if FileManager.default.fileExists(atPath: pathString.path) {
                webView.loadFileURL(pathString, allowingReadAccessTo: pathString.deletingLastPathComponent())
            } else {
                print("文件不存在")
            }
        } else {
            print("路径字符串为 nil")
        }
        
        if let pdfPath = pathString?.path {
            let id = JNDataUtil.shared.saveData(image: image ?? [UIImage(named: "pdfImage_placeholder")], title: titleStr, fileSize: JNDataUtil.shared.getFileSize(at: pdfPath), filePath: pdfPath)
            fileId = id ?? ""
        }


        
    }
    
    // 设置 WKWebView
    func setupWebView() {
        webView = WKWebView()
        view.addSubview(webView)
        webView.scrollView.showsVerticalScrollIndicator = false
        headerView = .init(frame: CGRect(x: 0, y: kNavBarHeight + 20, width: kScreenWidth, height: 20), title: titleStr)
        headerView.changeTitle(title: titleStr)
        headerView.editBlock = {
            let popupView = JNUrlPopView(frame: self.view.bounds, title: "Name",placeholder: "Enter Name", confirmButtonText: "Confirm")
            popupView.textField.text = self.titleStr
            // 设置确定按钮的回调
            popupView.onConfirm = { inputText in
                self.titleStr = inputText ?? ""
                self.headerView.changeTitle(title: self.titleStr)
                if !self.fileId.isEmpty {
                    JNDataUtil.shared.updateTitle(forID: self.fileId, newTitle: inputText ?? "")

                }
            }
            // 添加到视图中
            AppUtil.getWindow()?.rootViewController?.view.addSubview(popupView)
        }
        view.addSubview(headerView)
        
        // 使用 SnapKit 设置约束
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight + 60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-240) // 留出按钮位置
        }
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = grayColor
        webView.alpha = 0.9
//        addShadowAndCornerRadiusToWebView()
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
        Delebutton.setTitle("Delete", for: .normal)
        Delebutton.titleLabel?.font = boldSystemFont(ofSize: 18)
        Delebutton.backgroundColor = .white
        Delebutton.setTitleColor(BlackColor, for: .normal)
        Delebutton.setImage(UIImage(named: "detail_delete"), for: .normal)
        Delebutton.tintColor = MainColor
        Delebutton.layer.cornerRadius = 16
        Delebutton.layer.masksToBounds = true
        Delebutton.layer.borderWidth = 2
        Delebutton.layer.borderColor = MainColor.cgColor
        view.addSubview(Delebutton)

        Delebutton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -Delebutton.imageView!.frame.size.width - spacing, bottom: 0, right: Delebutton.imageView!.frame.size.width + spacing)
        Delebutton.imageEdgeInsets = UIEdgeInsets(top: 0, left: Delebutton.titleLabel!.intrinsicContentSize.width + spacing, bottom: 0, right: -Delebutton.titleLabel!.intrinsicContentSize.width - spacing)

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
        
    }
    @objc func DeletePDFButtonTapped() {
        guard fileId.isEmpty else {
            return
        }
        JNDataUtil.shared.deleteData(forID: fileId)
        ProgressHUD.showSuccess("Delete Success")
        AfterGCD(timeInval: 1.0) {
            self.popToRootViewCon()
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
