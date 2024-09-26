//
//  AppImageUtil.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/26.
//

import UIKit
import CoreImage
class AppImageUtil: NSObject {
    func getNewImageFromFilter(filterName: String, originImage: UIImage) -> UIImage? {
        // 将 UIImage 转换为 CIImage
        guard let ciImage = CIImage(image: originImage) else { return nil }
        
        // 创建滤镜
        guard let filter = CIFilter(name: filterName) else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // 应用默认设置
        filter.setDefaults()
        
        // 创建 CIContext
        let context = CIContext(options: nil)
        
        // 获取滤镜处理后的图像
        guard let outputImage = filter.outputImage else { return nil }
        
        // 渲染输出图像并转换为 CGImage
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        // 将 CGImage 转换为 UIImage
        let image = UIImage(cgImage: cgImage)
        
        return image
    }
    func applyFiltersToImage(originImage: UIImage) -> [UIImage] {
        var filteredImages: [UIImage] = []

        // 定义滤镜的名称数组
        let filterNames = [
            "None",                         // 原图
            "CISepiaTone",                   // 棕褐色效果
            "CIInstant",                     // 即影即显效果
            "CIPhotoEffectMono",             // 黑白复古效果
            "CIColorControls",               // 饱和色彩效果（需要额外设置）
            "CIHueAdjust",                   // 色调转移效果（需要额外设置）
            "CIColorMonochrome",             // 单色效果（需要额外设置）
            "CIColorInvert"                  // 反转颜色效果
        ]
        
        // 创建 CIContext
        let context = CIContext(options: nil)

        // 将 UIImage 转换为 CIImage
        guard let ciImage = CIImage(image: originImage) else { return [] }
        
        // 添加原图
        filteredImages.append(originImage)

        // 遍历滤镜名称并应用每个滤镜
        for filterName in filterNames {
            if filterName == "None" {
                // 原图已添加，跳过
                continue
            }

            // 创建滤镜
            guard let filter = CIFilter(name: filterName) else { continue }
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            // 根据不同滤镜名称设置参数
            switch filterName {
            case "CIColorControls":
                // 设置饱和度
                filter.setValue(1.5, forKey: kCIInputSaturationKey)
            case "CIHueAdjust":
                // 设置色调角度
                filter.setValue(1.0, forKey: kCIInputAngleKey)
            case "CIColorMonochrome":
                // 设置单色滤镜颜色为灰色
                filter.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: kCIInputColorKey)
            default:
                break
            }
            
            // 获取滤镜处理后的图像
            guard let outputImage = filter.outputImage else { continue }
            
            // 渲染输出图像并转换为 CGImage
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                // 将 CGImage 转换为 UIImage 并添加到数组
                let filteredImage = UIImage(cgImage: cgImage)
                filteredImages.append(filteredImage)
            }
        }
        
        return filteredImages
    }
    func getFilteredImages(from originImage: UIImage) -> [UIImage] {
        var images: [UIImage] = []
        
        // 原图
        images.append(originImage)
        
        // 将UIImage转换为CIImage
        guard let ciImage = CIImage(image: originImage) else {
            return images // 如果转换失败，返回当前图像
        }
        
        // CIContext 初始化
        let context = CIContext(options: nil)
        
        // 准备滤镜
        let filterNames = [
            "CIPhotoEffectChrome",    // 滤镜名称为 CIPhotoEffectChrome
            
            "CIPhotoEffectMono",      // 滤镜名称为 CIPhotoEffectMono
            "CIPhotoEffectTransfer",   // 滤镜名称为 CIPhotoEffectTransfer
            "CIPhotoEffectInstant",   // 滤镜名称为 CIPhotoEffectInstant
        ]
        
        // 应用滤镜并生成图片
        for (index, filterName) in filterNames.enumerated() {
            if let filter = CIFilter(name: filterName) {
                filter.setValue(ciImage, forKey: kCIInputImageKey)
                if let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    let filteredImage = UIImage(cgImage: cgImage)
                    images.append(filteredImage)
                    // 将滤镜效果图插入索引1及之后的位置
                    
                }
            }
        }

        // 饱和度为2的滤镜处理 (CIColorControls 用于调整饱和度)
        if let saturationFilter = CIFilter(name: "CIColorControls") {
            saturationFilter.setValue(ciImage, forKey: kCIInputImageKey)
            saturationFilter.setValue(2.0, forKey: kCIInputSaturationKey) // 设置饱和度为 2.0
            if let outputImage = saturationFilter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                let saturatedImage = UIImage(cgImage: cgImage)
                // 在最后插入饱和度为2的图片
                // 将饱和度为2的图片添加到数组末尾
                images.insert(saturatedImage, at: 3)
            }
        }

        return images
    }

}
