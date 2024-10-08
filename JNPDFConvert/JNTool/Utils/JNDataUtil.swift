import UIKit

class JNDataUtil {
    
    static let shared = JNDataUtil()
    
    private let userDefaultsKey = "savedDataArray"
    
    private init() {}
    
    // MARK: - 生成唯一ID
    private func generateUniqueID() -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let randomNum = Int.random(in: 100_000...999_999)
        return "\(timestamp)\(randomNum)"
    }
    
    // MARK: - 保存数据
    func saveData(image: Any, title: String, fileSize: String, filePath: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTime = dateFormatter.string(from: Date())
        
        var imageData: Data?
        var imageUrl: String?
        
        // 判断传入的 image 参数类型
        if let image = image as? UIImage {
            // 如果是 UIImage 类型，将图片转换为 JPEG 数据
            imageData = image.jpegData(compressionQuality: 0.8)
            if imageData == nil {
                print("图片转换失败")
                return nil
            }
        } else if let imageURL = image as? String {
            // 如果是 String 类型，则认为是图片的 URL，直接存储该 URL
            imageUrl = imageURL
        } else {
            print("无效的图片类型")
            return nil
        }
        
        let uniqueID = generateUniqueID()
        var newData: [String: Any] = [
            "id": uniqueID,
            "title": title,
            "currentTime": currentTime,
            "fileSize": fileSize,
            "filePath": filePath
        ]
        
        // 根据不同的情况添加数据
        if let imageData = imageData {
            newData["image"] = imageData
        }
        
        if let imageUrl = imageUrl {
            newData["image"] = imageUrl
        }
        
        var allData = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String: Any]] ?? []
        allData.insert(newData, at: 0)  // 将最新数据放在前面
        
        UserDefaults.standard.set(allData, forKey: userDefaultsKey)
        print("数据保存成功，ID: \(uniqueID)")
        return uniqueID
    }

    
    // MARK: - 读取所有数据
    func loadAllData() -> [[String: Any]] {
        return UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String: Any]] ?? []
    }
    
    // MARK: - 排序方法
    
    // 按照名字(A-Z)排序
    func sortByTitle(data: [[String: Any]]) -> [[String: Any]] {
        return data.sorted { ($0["title"] as? String ?? "") < ($1["title"] as? String ?? "") }
    }
    
    func sortByFileSize(data: [[String: Any]]) -> [[String: Any]] {
        return data.sorted {
            let size1 = fileSizeInBytes(from: $0["fileSize"] as? String ?? "")
            let size2 = fileSizeInBytes(from: $1["fileSize"] as? String ?? "")
            return size1 < size2
        }
    }

    func fileSizeInBytes(from fileSizeString: String) -> Double {
        let sizeString = fileSizeString.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if sizeString.hasSuffix("gb") {
            if let size = Double(sizeString.replacingOccurrences(of: "gb", with: "")) {
                return size * 1024 * 1024 * 1024 // 转换为字节
            }
        } else if sizeString.hasSuffix("mb") {
            if let size = Double(sizeString.replacingOccurrences(of: "mb", with: "")) {
                return size * 1024 * 1024 // 转换为字节
            }
        } else if sizeString.hasSuffix("kb") {
            if let size = Double(sizeString.replacingOccurrences(of: "kb", with: "")) {
                return size * 1024 // 转换为字节
            }
        } else {
            // 默认按字节处理
            return Double(sizeString) ?? 0
        }
        
        return 0
    }

    
    // 按照时间倒序排序
    func sortByTimeDescending(data: [[String: Any]]) -> [[String: Any]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return data.sorted {
            let date1 = dateFormatter.date(from: $0["currentTime"] as? String ?? "") ?? Date.distantPast
            let date2 = dateFormatter.date(from: $1["currentTime"] as? String ?? "") ?? Date.distantPast
            return date1 > date2
        }
    }
    
    // MARK: - 修改某一项的名字
    func updateTitle(forID id: String, newTitle: String) {
        var allData = loadAllData()
        
        for (index, data) in allData.enumerated() {
            if let existingID = data["id"] as? String, existingID == id {
                // 获取文件路径
                if let filePath = data["filePath"] as? String {
                    // 解析旧文件路径
                    let oldURL = URL(fileURLWithPath: filePath)
                    let fileManager = FileManager.default

                    // 生成新文件路径
                    let newFileName = "\(newTitle)\(oldURL.pathExtension.isEmpty ? "" : ".\(oldURL.pathExtension)")"
                    let newURL = oldURL.deletingLastPathComponent().appendingPathComponent(newFileName)

                    do {
                        // 重命名文件
                        try fileManager.moveItem(at: oldURL, to: newURL)

                        // 更新filePath
                        var updatedData = data
                        updatedData["title"] = newTitle
                        updatedData["filePath"] = newURL.path
                        allData[index] = updatedData
                        print("文件重命名成功，新文件路径: \(newURL.path)")
                    } catch {
                        print("文件重命名失败: \(error)")
                    }
                }
                break
            }
        }
        // 保存更新后的数据
        UserDefaults.standard.set(allData, forKey: userDefaultsKey)
    }
    // 根据关键字过滤标题包含该关键字的数据
    func filterByKeyword(keyword: String) -> [[String: Any]] {
        let allData = loadAllData()
        
        // 过滤出标题中包含关键字的数据，忽略大小写
        let filteredData = allData.filter {
            if let title = $0["title"] as? String {
                return title.lowercased().contains(keyword.lowercased())
            }
            return false
        }
        
        // 按时间倒序排列返回
        return sortByTimeDescending(data: filteredData)
    }

    
    // MARK: - 删除某一项
    func deleteData(forID id: String) {
        var allData = loadAllData()
        allData.removeAll { $0["id"] as? String == id }
        UserDefaults.standard.set(allData, forKey: userDefaultsKey)
        print("数据已删除，ID: \(id)")
    }
    
    // 按日期范围过滤数据，并按时间倒序排列
    func filterByDateRange(days: Int) -> [[String: Any]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: currentDate) ?? Date.distantPast
        
        let filteredData = loadAllData().filter {
            let dataDate = dateFormatter.date(from: $0["currentTime"] as? String ?? "") ?? Date.distantPast
            return dataDate >= cutoffDate
        }
        
        // 按时间倒序排列
        return sortByTimeDescending(data: filteredData)
    }

    
    // 获取最近三天的数据
    func getRecentThreeDaysData() -> [[String: Any]] {
        return filterByDateRange(days: 3)
    }
    
    // 获取最近一个月的数据
    func getRecentMonthData() -> [[String: Any]] {
        return filterByDateRange(days: 30)
    }
    
    // 获取最近六个月的数据
    func getRecentSixMonthsData() -> [[String: Any]] {
        return filterByDateRange(days: 180)
    }
    func getFileSize(at filePath: String) -> String {
        let fileManager = FileManager.default
        do {
            // 获取文件属性
            let attributes = try fileManager.attributesOfItem(atPath: filePath)
            // 提取文件大小，单位是字节
            if let fileSize = attributes[.size] as? Int64 {
                // 根据文件大小动态使用合适的单位
                return formatFileSize(fileSize)
            }
        } catch {
            print("获取文件大小失败: \(error)")
        }
        return "未知大小"
    }

    func formatFileSize(_ sizeInBytes: Int64) -> String {
        let fileSizeInKB = Double(sizeInBytes) / 1024
        let fileSizeInMB = fileSizeInKB / 1024
        let fileSizeInGB = fileSizeInMB / 1024

        if fileSizeInGB >= 1.0 {
            return String(format: "%.2f GB", fileSizeInGB)
        } else if fileSizeInMB >= 1.0 {
            return String(format: "%.2f MB", fileSizeInMB)
        } else {
            return String(format: "%.2f KB", fileSizeInKB)
        }
    }

}
