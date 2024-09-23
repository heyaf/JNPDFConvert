import UIKit
import WebKit

class JNFileToPDFVC: BaseViewController {

    var webView: WKWebView!
    var filepath: String!
    private var pageCount: Int = 0              // PPT 页数
    var filetype:Int = 0   //0=word 1=ppt
    var callback: (([UIImage]) -> Void)?
    var failureCallback: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // 开始转换流程
    func startConversion() {
        setupWebView()
        loadFile()
        // 添加观察者，监听进度变化
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }

    // 加载文件
    private func loadFile() {
        guard let fileURL = URL(string: filepath) else {
            failureCallback?("无效的文件路径: \(filepath ?? "")")
            return
        }
        let request = URLRequest(url: fileURL)
        webView.load(request)
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
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress >= 1.0 {
                if filetype == 0{
                    let contentHeight = webView.scrollView.contentSize.height
                    let height = kScreenHeight - kNavBarHeight - kBottomSafeHeight - 100
                    pageCount = Int(contentHeight / height)
                    self.generatePDFButtonTapped()
                }else{
                    self.getPPTPageInfo()
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // 生成 PDF 按钮的点击事件
    @objc func generatePDFButtonTapped() {
        guard webView.url != nil else {
            failureCallback?("WebView 尚未加载任何内容")
            return
        }

        if #available(iOS 14, *) {
            let config = WKPDFConfiguration()
            webView.createPDF(configuration: config) { result in
                switch result {
                case .success(let data):
                    self.savePDF(data: data)
                case .failure(let error):
                    self.failureCallback?("生成 PDF 失败: \(error.localizedDescription)")
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
            failureCallback?("无法保存 PDF 文件: \(error.localizedDescription)")
        }
    }

    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func previewPDF(at url: URL) {
        let converter = PDFToSingleImageConverter()
        if let combinedImage = converter.convertPDFToSingleImage(pdfURL: url) {
            // `combinedImage` 是拼接后的长图片，可以展示或保存
            print("PDF 成功转换为长图片")
            if let splitImages = combinedImage.splitImageIntoParts(numberOfParts: self.pageCount) {
                self.callback?(splitImages)
            }else{
                failureCallback?("分割图片失败")
            }
        }else{
            failureCallback?("转换图片失败")
        }
//        if filetype == 0{
//            let (images, pageCount) = converter.convertWordToImages(pdfURL: url)
//            if let imageArr = images {
//                self.callback?(imageArr)
//            }else{
//                failureCallback?("分割图片失败")
//            }
//            
//        }else{
//            
//        }
        
    }

    // 获取 PPT 页数及每一页的尺寸信息
    private func getPPTPageInfo() {
        let getPageCountScript = "document.getElementsByClassName('slide').length"
        
        webView.evaluateJavaScript(getPageCountScript) { (result, error) in
            if let error = error {
                self.failureCallback?("获取页数失败: \(error.localizedDescription)")
                return
            }
            if let count = result as? Int {
                self.pageCount = count
                self.generatePDFButtonTapped()
            } else {
                self.failureCallback?("无法解析页数")
            }
        }
    }
}

extension JNFileToPDFVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
