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
}
