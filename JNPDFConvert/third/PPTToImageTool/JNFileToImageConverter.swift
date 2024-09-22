import UIKit
import WebKit

class JNFileToImageConverter: NSObject {
    
    private var webView: WKWebView!
    private var filepath: String!
    private var pageCount: Int = 0
    private var successCallback: (([UIImage]) -> Void)?
    private var failureCallback: ((String) -> Void)?
    
    // 初始化方法，传入文件路径、成功和失败的回调
    init(filepath: String, success: @escaping ([UIImage]) -> Void, failure: @escaping (String) -> Void) {
        self.filepath = filepath
        self.successCallback = success
        self.failureCallback = failure
    }
    
    // 开始文件处理流程
    func startConversion() {
        setupWebView()
        loadFile()
    }
    
    // 设置 WKWebView
    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
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
    
    // KVO 观察到进度变化时的处理
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", webView.estimatedProgress >= 1.0 {
            getPPTPageInfo()
        }
    }
    
    // 获取 PPT 页数及每一页的尺寸信息
    private func getPPTPageInfo() {
        let getPageCountScript = "document.getElementsByClassName('slide').length"
        webView.evaluateJavaScript(getPageCountScript) { [weak self] (result, error) in
            if let count = result as? Int {
                self?.pageCount = count
                self?.generatePDF()
            } else {
                self?.failureCallback?("无法获取 PPT 页数")
            }
        }
    }
    
    // 生成 PDF
    private func generatePDF() {
        if #available(iOS 14, *) {
            let config = WKPDFConfiguration()
            webView.createPDF(configuration: config) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.savePDF(data: data)
                case .failure(let error):
                    self?.failureCallback?("生成 PDF 失败: \(error.localizedDescription)")
                }
            }
        } else {
            failureCallback?("iOS 版本过低，不支持 PDF 生成")
        }
    }
    
    // 保存 PDF 文件到本地
    private func savePDF(data: Data) {
        let filePath = getDocumentsDirectory().appendingPathComponent("webview.pdf")
        
        do {
            try data.write(to: filePath)
            print("PDF 已保存至: \(filePath)")
            previewPDF(at: filePath)
        } catch {
            failureCallback?("无法保存 PDF 文件: \(error.localizedDescription)")
        }
    }
    
    // 获取本地文档目录路径
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // 预览并处理 PDF -> 图片转换
    private func previewPDF(at url: URL) {
        let converter = PDFToSingleImageConverter() // 假设已经实现该类
        if let combinedImage = converter.convertPDFToSingleImage(pdfURL: url) {
            print("PDF 成功转换为长图片")
            if let splitImages = combinedImage.splitImageIntoParts(numberOfParts: self.pageCount) {
                successCallback?(splitImages)
            } else {
                failureCallback?("无法分割 PDF 图片")
            }
        } else {
            failureCallback?("PDF 转换为图片失败")
        }
    }
    
    // 移除观察者
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

// 扩展 WKWebView 导航代理
extension JNFileToImageConverter: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        failureCallback?("加载文件失败: \(error.localizedDescription)")
    }
}
