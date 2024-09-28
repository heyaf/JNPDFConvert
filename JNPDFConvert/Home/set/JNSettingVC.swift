//
//  JNSettingVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/28.
//

import UIKit
import LinkPresentation
import MessageUI
class JNSettingVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    let appID = "6590607143"

    let tableView = UITableView()
    
    let items: [(image: UIImage?, title: String)] = [
        (UIImage(named: "Setting_share"), "Share App"),
        (UIImage(named: "Setting_Rate"), "Rate Us"),
        (UIImage(named: "Setting_contact"), "Contact Us"),
        (UIImage(named: "Setting_term"), "Terms of Use"),
        (UIImage(named: "Setting_privacy"), "Privacy Policy")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.title = "Settings"
        // 设置 TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarHeight)
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        let item = items[indexPath.row]
        cell.configure(with: item.image, title: item.title)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        switch indexPath.row {
        case 3:
            openUrl("https://www.notion.so/Terms-of-Use-f5a04b9fca9f493dafa8d49952b425ca")
        case 4:
            openUrl("https://www.notion.so/Privacy-Policy-12e1fb8957eb498eb7bbac31334876df")
        case 2:
            OpenEmail()
        case 1:
            let shareUrl = URL(string: "https://itunes.apple.com/app/twitter/id\(appID)?mt=8&action=write-review")!
            UIApplication.shared.open(shareUrl)
        case 0:
            shareContent()
        default:
            break
        }
    }
    
    public func openUrl(_ urlStr: String) {
        guard let url = URL(string: urlStr) else {
            print("无法创建URL: \(urlStr)")
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                print("成功打开 \(urlStr)")
            } else {
                print("无法打开 URL: \(urlStr)。请确保应用已正确安装。")
            }
        }
    }
    func shareContent() {
        ProgressHUD.showLoading()
        
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "App"
        let imageToShare = UIImage(named: "AppIcon")
        
        // 使用compactMap创建分享内容，去除nil值
        let activityItems: [Any] = [appName, imageToShare].compactMap { $0 }
        
        // 如果分享内容为空则返回
        guard !activityItems.isEmpty else {
            ProgressHUD.dismiss()
            print("分享内容为空")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // 排除不需要的活动类型
        activityVC.excludedActivityTypes = [
            .print,
            .copyToPasteboard,
            .assignToContact,
            .saveToCameraRoll
        ]
        
        // 展示分享视图
        present(activityVC, animated: true, completion: nil)
        
        // 处理分享结果的回调
        activityVC.completionWithItemsHandler = { _, completed, _, _ in
            ProgressHUD.dismiss()
            if completed {
                print("分享成功")
            } else {
                print("分享取消")
            }
        }
    }
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        let emailClients = [
            "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)",
            "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)",
            "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)",
            "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
        ]
        
        // 优先使用已安装的邮箱客户端
        for client in emailClients {
            if let url = URL(string: client), UIApplication.shared.canOpenURL(url) {
                return url
            }
        }
        
        // 使用默认邮件协议
        return URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
    }
    private func OpenEmail(){
        ProgressHUD.showLoading(delay: 3.0)
        //设置主题
        let recipientEmail = "fjtech_help@outlook.com"
        let subject = "Feedback and technical support".local
        let body = "------\n\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            //设置主题
            controller.setSubject(subject)
            //设置收件人
            controller.setToRecipients([recipientEmail])
            controller.setMessageBody(body, isHTML: false)
            //打开界面
            self.present(controller, animated: true, completion: nil)
        }else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }else{
            UIPasteboard.general.string = recipientEmail
            ProgressHUD.showMessage(String(format: "email address has been copied, please go to send feedback email".local))
        }
    }

}

class SettingTableViewCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    // 箭头图标
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "conversation_unright") // 默认箭头图标
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 添加图标和标签到内容视图
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)

        contentView.backgroundColor = .white
        // 使用 SnapKit 进行布局
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-46)
        }
        // 箭头图标布局
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18) // 固定大小
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage?, title: String) {
        iconImageView.image = image
        titleLabel.text = title
    }
}
