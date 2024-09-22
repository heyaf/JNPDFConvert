//
//  JNFileToPDFVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/21.
//

import UIKit
import WebKit
class JNFileToPDFVC: BaseViewController {
    
    var webView: WKWebView!
    var filepath: String!
    private var pageCount: Int = 0             // PPT 页数
    var callback: (([UIImage]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.title = "Detail"
        
        // 设置界面
        setupWebView()
        //        setupProgressView()
        
        // 加载传入的 URL
        // 将文件路径转换为 URL
        if let fileURL = URL(string: filepath) {
            let request = URLRequest(url: fileURL)
            webView.load(request)
        } else {
            print("无效的文件路径: \(filepath ?? "")")
        }
        
        // 添加观察者，监听进度变化
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    // 设置 WKWebView
    func setupWebView() {
        webView = WKWebView()
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight + 20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-180) // 留出按钮位置
        }
        
    }
    
    
    
    // KVO 观察到进度变化时的处理
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            
            // 隐藏进度条，当加载完成时
            if webView.estimatedProgress >= 1.0 {
                self.getPPTPageInfo()
                
            } else {
            }
        }
    }
    // 设置生成 PDF 的按钮
    func setupGeneratePDFButton() {
        let button = UIButton(type: .system)
        button.setTitle("Generate PDF", for: .normal)
        button.titleLabel?.font = boldSystemFont(ofSize: 18)
        button.backgroundColor = MainColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        view.addSubview(button)
        
        // 使用 SnapKit 设置按钮的约束
        button.snp.makeConstraints { make in
            make.height.equalTo(59)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        // 按钮点击事件
        button.addTarget(self, action: #selector(generatePDFButtonTapped), for: .touchUpInside)
    }
    
    // 生成 PDF 按钮的点击事件
    @objc func generatePDFButtonTapped() {
        guard webView.url != nil else {
            print("WebView 尚未加载任何内容")
            return
        }
        
        if #available(iOS 14, *) {
            let config = WKPDFConfiguration()
            webView.createPDF(configuration: config) { result in
                switch result {
                case .success(let data):
                    self.savePDF(data: data)
                case .failure(let error):
                    print("生成 PDF 失败: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 移除观察者
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // 保存 PDF 文件到本地
    func savePDF(data: Data) {
        let filePath = getDocumentsDirectory().appendingPathComponent("webview.pdf")
        
        do {
            try data.write(to: filePath)
            print("PDF 已保存至: \(filePath)")
            previewPDF(at: filePath)
        } catch {
            print("无法保存 PDF 文件: \(error.localizedDescription)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func previewPDF(at url: URL) {
        let converter = PDFToSingleImageConverter()
        var images: [UIImage] = []  // 替换为你的 UIImage 数组
        if let combinedImage = converter.convertPDFToSingleImage(pdfURL: url) {
            // `combinedImage` 是拼接后的长图片，可以展示或保存
            print("PDF 成功转换为长图片")
            if let splitImages = combinedImage.splitImageIntoParts(numberOfParts: self.pageCount) {
                images = splitImages
            }
        } else {
            print("转换失败")
        }
        // 回调最终生成的图片数组
        if let callback = self.callback {
            callback(images)
        }
        
        
    }
    // 获取 PPT 页数及每一页的尺寸信息
    private func getPPTPageInfo() {
        let getPageCountScript = "document.getElementsByClassName('slide').length"
        
        webView.evaluateJavaScript(getPageCountScript) { (result, error) in
            if let count = result as? Int {
                self.pageCount = count
                
            }
        }
    }
    
}
extension JNFileToPDFVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
