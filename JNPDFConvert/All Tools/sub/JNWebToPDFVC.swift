import UIKit
import WebKit

class JNWebToPDFVC: BaseViewController {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.title = "Detail"
        
        // 设置界面
        setupWebView()
        setupProgressView()
        setupGeneratePDFButton()
        
        // 加载传入的 URL
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        // 添加观察者，监听进度变化
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    // 设置 WKWebView
    func setupWebView() {
        webView = WKWebView()
        view.addSubview(webView)
        
        // 使用 SnapKit 设置约束
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight + 20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-180) // 留出按钮位置
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
        guard let currentURL = webView.url else {
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
        let documentController = UIDocumentInteractionController(url: url)
        documentController.delegate = self
        documentController.presentPreview(animated: true)
    }
}

extension JNWebToPDFVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
