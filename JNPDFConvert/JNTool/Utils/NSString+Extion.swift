//
//  NSString+Extion.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import Foundation
extension String {
    var local: String {
        let userDefaults = UserDefaults.standard
        let appLanguage = userDefaults.object(forKey: "appLanguage") as? String ?? "en"  // 假设默认语言为英语
        let path = Bundle.main.path(forResource: appLanguage, ofType: "lproj") ?? Bundle.main.bundlePath
        let languageBundle = Bundle(path: path)
        return languageBundle?.localizedString(forKey: self, value: nil, table: "Localizable") ?? self
    }
    func generateImageString(geshi:String) -> String {
        // 获取当前日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd" // 设置日期格式为 "年月日"
        let currentDate = dateFormatter.string(from: Date())
        
        // 生成四位随机数
        let randomNumber = String(format: "%04d", Int.random(in: 0..<10000))
        
        // 组合成所需字符串
        let result = geshi + currentDate + randomNumber
        return result
    }
    func validateAndFormatURL(_ urlString: String) -> String? {
        var formattedURLString = urlString

        // 检查是否包含 "http://" 或 "https://"
        if !formattedURLString.hasPrefix("http://") && !formattedURLString.hasPrefix("https://") {
            formattedURLString = "https://" + formattedURLString
        }

        // 创建 URL 对象
        if isValidURL(formattedURLString) {
            return formattedURLString // 返回格式化后的有效 URL 字符串
        }
        
        return nil // 返回 nil 表示无效 URL
    }
    func isValidURL(_ content: String) -> Bool {
        // 定义正则表达式来匹配常见的域名后缀
        let pattern = "([\\w-]+\\.)+[\\w-]{2,}(/\\S*)?$"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        // 使用正则表达式进行匹配
        let range = NSRange(location: 0, length: content.utf16.count)
        return regex?.firstMatch(in: content, options: [], range: range) != nil
    }

}
