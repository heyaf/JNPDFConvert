//
//  JNFileUtil.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/10/8.
//

import UIKit

class JNFileUtil: NSObject {
    func shareFile(from filePath: String, viewController: UIViewController) {
        // 创建文件的URL
        let fileURL = URL(fileURLWithPath: filePath)

        // 确保文件存在
        guard FileManager.default.fileExists(atPath: filePath) else {
            print("文件不存在")
            return
        }

        // 使用UIActivityViewController分享文件
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

        // 适用于iPad，避免崩溃
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        // 显示分享界面
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
