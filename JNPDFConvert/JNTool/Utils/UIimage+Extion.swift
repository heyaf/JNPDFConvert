//
//  UIimage+Extion.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/18.
//

import Foundation
import CoreImage

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
    
    // 有效值范围
        struct AdjustmentRanges {
            static let brightness: ClosedRange<Float> = -1.0...1.0 // 亮度范围
            static let saturation: ClosedRange<Float> = 0.0...2.0   // 饱和度范围
            static let contrast: ClosedRange<Float> = 0.0...2.0     // 对比度范围
            static let exposure: ClosedRange<Float> = -6.0...6.0    // 曝光范围
            static let gamma: ClosedRange<Float> = 0.0...3.0        // Gamma范围
        }
        
        // 调整亮度
        func adjustedBrightness(_ brightness: Float) -> UIImage? {
            guard AdjustmentRanges.brightness.contains(brightness) else {
                return nil // 如果参数不在范围内则返回 nil
            }
            return applyFilter(name: "CIColorControls", parameters: [kCIInputBrightnessKey: brightness])
        }
        
        // 调整饱和度
        func adjustedSaturation(_ saturation: Float) -> UIImage? {
            guard AdjustmentRanges.saturation.contains(saturation) else {
                return nil
            }
            return applyFilter(name: "CIColorControls", parameters: [kCIInputSaturationKey: saturation])
        }
        
        // 调整对比度
        func adjustedContrast(_ contrast: Float) -> UIImage? {
            guard AdjustmentRanges.contrast.contains(contrast) else {
                return nil
            }
            return applyFilter(name: "CIColorControls", parameters: [kCIInputContrastKey: contrast])
        }
        
        // 调整曝光
        func adjustedExposure(_ exposure: Float) -> UIImage? {
            guard AdjustmentRanges.exposure.contains(exposure) else {
                return nil
            }
            return applyFilter(name: "CIExposureAdjust", parameters: [kCIInputEVKey: exposure])
        }
        
        // 调整 Gamma
        func adjustedGamma(_ gamma: Float) -> UIImage? {
            guard AdjustmentRanges.gamma.contains(gamma) else {
                return nil
            }
            return applyFilter(name: "CIGammaAdjust", parameters: ["inputPower": gamma]) // 修改这里
        }
        
        // 应用滤镜的方法
        private func applyFilter(name: String, parameters: [String: Any]) -> UIImage? {
            guard let ciImage = CIImage(image: self) else { return nil }
            
            // 创建 CIContext
            let context = CIContext(options: nil)
            
            // 创建滤镜
            let filter = CIFilter(name: name)!
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            // 设置参数
            for (key, value) in parameters {
                filter.setValue(value, forKey: key)
            }
            
            // 获取输出图像并转换为 UIImage
            guard let outputImage = filter.outputImage,
                  let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
            
            return UIImage(cgImage: cgImage)
        }
    // 将外部传入的值转换为各个类型的有效范围
        func convertValueToAdjustments(value: Float) -> (brightness: Float?, saturation: Float?, contrast: Float?, exposure: Float?, gamma: Float?) {
            guard value >= -100 && value <= 100 else {
                return (nil, nil, nil, nil, nil) // 输入值不在有效范围内
            }
            
            let brightness = value / 100.0 // 亮度范围: -1.0 到 1.0
            let saturation = (value / 100.0) + 1.0 // 饱和度范围: 0.0 到 2.0
            let contrast = (value / 100.0) + 1.0 // 对比度范围: 0.0 到 2.0
            let exposure = (value / 100.0) * 6.0 // 曝光范围: -6.0 到 6.0
            let gamma = (value / 100.0) * 3.0 + 1.0 // Gamma范围: 0.0 到 3.0
            
            return (brightness, saturation, contrast, exposure, gamma)
        }
}
