//
//  JNPDFDetailViewController.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/10/8.
//

import UIKit
import WebKit

class JNPDFDetailViewController: BaseViewController {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.title = "Detail"
        
        // 设置界面
        setupWebView()
        setupProgressView()
        
        // 将文件路径转换为 URL
        let fileURL = URL(fileURLWithPath: urlString)
        
        // 检查文件是否存在
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // 加载 PDF 文件
            let request = URLRequest(url: fileURL)
            webView.load(request)
        } else {
            print("文件不存在: \(urlString ?? "")")
        }
        // 添加观察者，监听进度变化
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    // 设置 WKWebView
    func setupWebView() {
        webView = WKWebView()
        view.addSubview(webView)
        webView.scrollView.showsVerticalScrollIndicator = false

        // 使用 SnapKit 设置约束
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight + 20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-130) // 留出按钮位置
        }
        
        addShadowAndCornerRadiusToWebView()
    }
    
    // 设置进度条
    func setupProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = MainColor // 设置进度条颜色为红色
        progressView.trackTintColor = .hex("eeeeee") // 设置背景颜色
        
        view.addSubview(progressView)
        
        // 使用 SnapKit 设置约束
        progressView.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.top).offset(0) // 让进度条在 WebView 顶部
            make.leading.trailing.equalTo(webView)
            make.height.equalTo(2) // 设置进度条高度
        }
    }
    
    // KVO 观察到进度变化时的处理
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            
            // 隐藏进度条，当加载完成时
            if webView.estimatedProgress >= 1.0 {
                progressView.isHidden = true
            } else {
                progressView.isHidden = false
            }
        }
    }
    
    
    
    
    // 为 WebView 添加四个方向的阴影和圆角
    func addShadowAndCornerRadiusToWebView() {
        // 设置圆角
        webView.layer.cornerRadius = 10                          // 设置圆角半径
        webView.layer.masksToBounds = true                      // 不裁剪子视图，允许阴影超出边界
        
        let shadowView = UIView()
        view.addSubview(shadowView)
        shadowView.backgroundColor = .white
        shadowView.snp.makeConstraints { make in
            make.top.left.equalTo(webView).offset(8)
            make.bottom.right.equalTo(webView).inset(8)

        }
        
        // 设置阴影
        shadowView.layer.shadowColor = UIColor.black.cgColor      // 阴影颜色
        shadowView.layer.shadowOpacity = 0.3                     // 阴影透明度
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0) // 偏移量（四个方向的阴影可以设置为0）
        shadowView.layer.shadowRadius = 15                        // 阴影半径
        shadowView.layer.masksToBounds = false                    // 允许超出边界绘制阴影
        view.sendSubviewToBack(shadowView)
        
    }
    
    // 移除观察者
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
   
    // 获取 Documents 目录路径的方法
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    
}

extension JNPDFDetailVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
