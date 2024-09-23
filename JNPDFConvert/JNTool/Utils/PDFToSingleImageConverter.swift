//
//  PDFToSingleImageConverter.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/22.
//

import UIKit
import CoreGraphics

class PDFToSingleImageConverter {

    // 将 PDF 文件转换为拼接后的 UIImage
    func convertPDFToSingleImage(pdfURL: URL) -> UIImage? {
        guard let pdfDocument = CGPDFDocument(pdfURL as CFURL) else {
            print("无法打开 PDF 文件")
            return nil
        }

        var pageImages: [UIImage] = []
        let pageCount = pdfDocument.numberOfPages

        // 将每一页 PDF 渲染为 UIImage
        for i in 1...pageCount {
            guard let page = pdfDocument.page(at: i) else { continue }
            if let image = renderPageToImage(page: page) {
                pageImages.append(image)
            }
        }

        // 拼接所有 UIImage 成为一张长图
        return combineImages(images: pageImages)
    }
    // 渲染单个 PDF 页为 UIImage
    private func renderPageToImage(page: CGPDFPage) -> UIImage? {
        let pageRect = page.getBoxRect(.mediaBox)
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = 1.0

        let renderer = UIGraphicsImageRenderer(size: pageRect.size, format: rendererFormat)
        let image = renderer.image { context in
            UIColor.white.set()
            context.fill(pageRect)

            context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            context.cgContext.scaleBy(x: 1.0, y: -1.0)

            context.cgContext.drawPDFPage(page)
        }

        return image
    }

    // 拼接图片
    private func combineImages(images: [UIImage]) -> UIImage? {
        guard images.count > 0 else { return nil }

        // 计算拼接后总图片的尺寸
        let totalHeight = images.reduce(0) { $0 + $1.size.height }
        let maxWidth = images.max(by: { $0.size.width < $1.size.width })?.size.width ?? 0

        let totalSize = CGSize(width: maxWidth, height: totalHeight)
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = 1.0

        // 创建长图片
        let renderer = UIGraphicsImageRenderer(size: totalSize, format: rendererFormat)
        let combinedImage = renderer.image { context in
            var yOffset: CGFloat = 0

            for image in images {
                image.draw(at: CGPoint(x: 0, y: yOffset))
                yOffset += image.size.height
            }
        }

        return combinedImage
    }
}

