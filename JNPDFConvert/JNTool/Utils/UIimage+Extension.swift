//
//  UIimage+Extension.swift
//  Common
//
//  Created by 王子威 on 2020/12/13.
//

import UIKit

extension UIImage {
    /// 重设图片大小
    public func resizeImage( _ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg
    }

    
    // 压缩图片
    public static func compressImage(_ image: UIImage, toByte maxLength: Int) -> (UIImage, Data) {
        var compression: CGFloat = 1
        guard var data = image.jpegData(compressionQuality: compression),
            data.count > maxLength else { return (image, Data()) }
        
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxLength { return (resultImage, data) }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = image.jpegData(compressionQuality: compression)!
        }
        return (resultImage, data)
    }
    /// 生成一张二维码图片
    public static func getQRCode(_ string: String, _ size: CGFloat) -> UIImage? {
        let filter = CIFilter(name:"CIQRCodeGenerator")
        // 将滤镜恢复到默认状态
        filter?.setDefaults()
        // 为滤镜添加属性
        filter?.setValue(string.data(using: String.Encoding.utf8), forKey: "InputMessage")
        
        // 判断是否有图片
        guard let ciimage = filter?.outputImage else { return nil }
        return createNonInterpolatedUIImageFormCIImage(ciimage, size)
    }
    ///  生成高清二维码
    public static func createNonInterpolatedUIImageFormCIImage(_ image: CIImage, _ size: CGFloat) -> UIImage? {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 创建bitmap
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0,space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        bitmapRef.draw(bitmapImage, in: extent)
        
        // 保存bitmap到图片
        let scaledImage = bitmapRef.makeImage()
        let image = scaledImage != nil ? UIImage(cgImage: scaledImage!) : nil
        return image
    }
}
