//
//  StorageManager.swift

//

import UIKit

class StorageManager: NSObject {
    
    public static let shared = StorageManager()
    
    //购买过期时间戳(秒)
    @Storage(key: "vipExpirationTimestamp", defaultValue: 0)
    var vipExpirationTimestamp:Int
    
    //是否享受vip
    var isVipValid:Bool {
        //获取当前时间戳
        let timeInterval = Date().timeIntervalSince1970
        let currTime = Int(timeInterval)
        return (vipExpirationTimestamp > currTime)
    }
    
    
    //是否首次启动
    @Storage(key: "isFirstBoot", defaultValue: true)
    var isFirstBoot:Bool
    
    //打开app次数
    @Storage(key: "openCount", defaultValue: 0)
    var openCount:Int
    
   
}
