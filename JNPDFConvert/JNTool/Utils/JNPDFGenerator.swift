//
//  JNPDFGenerator.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/24.
//

import Foundation
class JNPDFGenerator {

    
    static func convertPDF(with images: [UIImage], fileName: String, border: Int = 2, quality: CGFloat = 0.9) -> String? {
        
        guard !images.isEmpty else { return nil }
        
        // PDF 文件存储路径
        let pdfPath = saveDirectory(fileName: fileName)
        print("****************文件路径：\(pdfPath)*******************")
        
        // 开始 PDF 上下文
        UIGraphicsBeginPDFContextToFile(pdfPath, CGRect.zero, nil)
        
        // 获取 PDF 页面的尺寸
        let pdfBounds = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavBarHeight - kBottomSafeHeight) // A4 纸的尺寸
        let borderWidth: CGFloat
        
        // 根据边框类型设置边框宽度
        switch border {
        case 0:
            borderWidth = 0
        case 1:
            borderWidth = 10
        case 2:
            borderWidth = 20
        default:
            borderWidth = 20
        }
        let Newimages = compressImages(images, quality: quality)
        for image in Newimages {
            UIGraphicsBeginPDFPageWithInfo(pdfBounds, nil)
            
            let imageW = image.size.width
            let imageH = image.size.height
            var w: CGFloat, h: CGFloat
            
            // 计算缩放后的宽高
            if (imageW / imageH) > (pdfBounds.width / pdfBounds.height) {
                w = pdfBounds.width - borderWidth * 2 // 留出边距
                h = (w * imageH) / imageW
            } else {
                h = pdfBounds.height - borderWidth * 2 // 留出边距
                w = (h * imageW) / imageH
            }
            
            // 图片居中绘制
            let originX = (pdfBounds.width - w) / 2
            let originY = (pdfBounds.height - h) / 2
            image.draw(in: CGRect(x: originX + borderWidth, y: originY + borderWidth, width: w, height: h))
        }
        
        UIGraphicsEndPDFContext()
        
        // 处理 PDF 质量（0-100%）
        // 由于 UIGraphics 不直接支持质量设置，可以选择使用图像压缩
        // 在此处返回 PDF 路径
        return pdfPath
    }
    
    static func saveDirectory(fileName: String) -> String {
        // 根据需要自定义保存路径
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName).path
    }
    static func compressImages(_ images: [UIImage], quality: CGFloat) -> [UIImage] {
        var compressedImages: [UIImage] = []
        
        // 确保质量参数在 0 到 100 之间
        let adjustedQuality = max(0, min(quality, 100)) / 100.0
        
        for image in images {
            // 将 UIImage 转换为 JPEG 数据
            if let imageData = image.jpegData(compressionQuality: adjustedQuality) {
                // 将 JPEG 数据转换回 UIImage
                if let compressedImage = UIImage(data: imageData) {
                    compressedImages.append(compressedImage)
                }
            }
        }
        
        return compressedImages
    }
}
