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
}
