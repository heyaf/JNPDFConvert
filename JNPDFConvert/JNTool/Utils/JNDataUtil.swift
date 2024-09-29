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
    func saveData(image: UIImage, title: String, fileSize: String, filePath: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTime = dateFormatter.string(from: Date())
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("图片转换失败")
            return nil
        }
        
        let uniqueID = generateUniqueID()
        let newData: [String: Any] = [
            "id": uniqueID,
            "image": imageData,
            "title": title,
            "currentTime": currentTime,
            "fileSize": fileSize,
            "filePath": filePath
        ]
        
        var allData = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String: Any]] ?? []
        allData.append(newData)
        
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
    
    // 按照文件大小排序
    func sortByFileSize(data: [[String: Any]]) -> [[String: Any]] {
        return data.sorted {
            let size1 = ($0["fileSize"] as? String ?? "").replacingOccurrences(of: "MB", with: "")
            let size2 = ($1["fileSize"] as? String ?? "").replacingOccurrences(of: "MB", with: "")
            return (Double(size1) ?? 0) < (Double(size2) ?? 0)
        }
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
                var updatedData = data
                updatedData["title"] = newTitle
                allData[index] = updatedData
                print("标题已更新为: \(newTitle)")
                break
            }
        }
        UserDefaults.standard.set(allData, forKey: userDefaultsKey)
    }
    
    // MARK: - 删除某一项
    func deleteData(forID id: String) {
        var allData = loadAllData()
        allData.removeAll { $0["id"] as? String == id }
        UserDefaults.standard.set(allData, forKey: userDefaultsKey)
        print("数据已删除，ID: \(id)")
    }
    
    // MARK: - 按照最近时间规则取数据
    func filterByDateRange(days: Int) -> [[String: Any]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: currentDate) ?? Date.distantPast
        
        return loadAllData().filter {
            let dataDate = dateFormatter.date(from: $0["currentTime"] as? String ?? "") ?? Date.distantPast
            return dataDate >= cutoffDate
        }
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
                // 将文件大小转换为 MB 并返回字符串
                let fileSizeInKB = Double(fileSize) / 1024
                return "\(fileSizeInKB)"
            }
        } catch {
            print("获取文件大小失败: \(error)")
        }
        return "未知大小"
    }
}
