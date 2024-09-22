//
//  UIimage+Extion.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/18.
//

import Foundation
extension UIImage {
    convenience init(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    // 将长图按长度平均分为 N 份
    func splitImageIntoParts(numberOfParts: Int) -> [UIImage]? {
        guard numberOfParts > 0 else { return nil }
        
        let imageHeight = self.size.height
        let imageWidth = self.size.width
        let partHeight = imageHeight / CGFloat(numberOfParts)
        
        var images: [UIImage] = []
        
        for i in 0..<numberOfParts {
            let originY = CGFloat(i) * partHeight
            let cropRect = CGRect(x: 0, y: originY, width: imageWidth, height: partHeight)
            
            if let croppedImage = self.crop(rect: cropRect) {
                images.append(croppedImage)
            }
        }
        
        return images
    }
    
    // 裁剪指定区域的图片
    private func crop(rect: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }
}
