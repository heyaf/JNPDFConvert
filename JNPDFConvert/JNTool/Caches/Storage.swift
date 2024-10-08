//
//  Storage.swift
//  Common
//
//  Created by CoderAFI on 2020/5/4.
//
// https://stackoverflow.com/questions/59473051/userdefault-property-wrapper-not-saving-values-ios-versions-below-ios-13

import Foundation

@propertyWrapper
public struct Storage<T: Codable> {
    
    struct Wrapper<T> : Codable where T : Codable {
        let wrapped : T
    }
    
    private let key: String
    private let defaultValue: T
    private let userDefaults = UserDefaults.standard
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            guard let data = userDefaults.object(forKey: key) as? Data else {
                return defaultValue
            }
            if #available(iOS 13, *) {
                let value = try? JSONDecoder().decode(T.self, from: data)
                return value ?? defaultValue
            } else {
                let value = try? JSONDecoder().decode(Wrapper<T>.self, from: data)
                return value?.wrapped ?? defaultValue
            }
        }
        set {
            if #available(iOS 13, *) {
                let data = try? JSONEncoder().encode(newValue)
                userDefaults.set(data, forKey: key)
            } else {
                let data = try? JSONEncoder().encode(Wrapper(wrapped:newValue))
                userDefaults.set(data, forKey: key)
            }
            userDefaults.synchronize()
        }
    }
    
}
