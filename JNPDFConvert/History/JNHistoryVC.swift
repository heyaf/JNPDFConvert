//
//  JNHistoryVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import UIKit

class JNHistoryVC: BaseViewController {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Converted files"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    var bgHeader = UIFastCreatTool.createImageView("Rectangle 23309")
    let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Filter", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        // 设置图标（右边的三条线图标）
        let icon = UIImage(named: "history_filter")
        button.setImage(icon, for: .normal)
        
        // 设置按钮图片和标题的布局关系
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black

        // 设置图标在右边，文字在左边
        button.semanticContentAttribute = .forceRightToLeft
        
        // 调整按钮图片和标题之间的间距
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 5)

        // 边框和圆角设置
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.hex("dddddd").cgColor
        
        // 设置按钮的内容边距
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.backgroundColor = .white
        return button
    }()
    let tableView: UITableView = {
        var tableView = UITableView()
        // TableView setup
        tableView.backgroundColor = .hex("f9f9f9")
        tableView.separatorStyle = .none
        return tableView
    }()
    var selectedOption = 0
    var newFileId = ""
    // Sample data
    var pdfList : [[String : Any]] = [
       
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hex("f9f9f9")
        isHideCustomNav = true
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name(rawValue: "Savedfile"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customNav.backgroundColor = .clear
        if newFileId.isEmpty {
            tableView.y = kNavBarHeight + 80
            UIView.animate(withDuration: 0.3) {
                self.tableView.y = kNavBarHeight + 70
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadFileData()
    }
    func setupUI() {
        setNav()
        view.addSubview(titleLabel)
        view.addSubview(filterButton)
        
        // 使用 SnapKit 进行布局
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(kNavBarHeight + 30)
        }
        
        filterButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(titleLabel)
            make.height.equalTo(30) // 设置按钮的高度
            make.width.equalTo(90)
        }
        filterButton.addTarget(self, action: #selector(filterevent), for: .touchUpInside)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(PDFTableViewCell.self, forCellReuseIdentifier: "PDFCell")
//        tableView.bounces = false
        tableView.frame = CGRect(x: 0, y: kNavBarHeight + 80, width: kScreenWidth, height: kScreenHeight - kNavBarHeight - 70 - kBottomSafeHeight)
        
    }
    func setNav(){
        
        view.addSubview(bgHeader)
        bgHeader.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavBarHeight + 10)
        
        
        let titleL = UIFastCreatTool.createLabel("History",fontSize: 26,textColor: .white)
        titleL.font = .systemFont(ofSize: 26, weight: UIFont.Weight(rawValue: 900.0))
        view.addSubview(titleL)
        
        let searchBtn = UIFastCreatTool.createButton(normalImage: UIImage(named: "Group_homeSearch"))
        searchBtn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        view.addSubview(searchBtn)
        
        let settingBtn = UIFastCreatTool.createButton(normalImage: UIImage(named: "Group 1000005306"))
        settingBtn.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
        view.addSubview(settingBtn)
        
        titleL.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(statusBarHeight + 7)
            make.height.equalTo(31)
            make.width.equalTo(200)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarHeight + 8)
            make.right.equalToSuperview().inset(66)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        settingBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarHeight + 8)
            make.right.equalToSuperview().inset(19)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        
    }
    @objc func filterevent() {
        
        // 初始化弹窗视图
        let popup = PopupSelectionView(frame: self.view.bounds, selectedOption: selectedOption)
        
        // 设置代理
        popup.delegate = self
        
        // 添加到视图中
        AppUtil.getWindow()?.rootViewController?.view.addSubview(popup)
        
        
    }
    @objc func searchAction(){
        let searchVC = JNSearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
        
    }
    @objc func settingAction(){
        let setVC = JNSettingVC()
        pushViewCon(setVC)
    }
    @objc func handleNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let value1 = userInfo["id"] as? String, !value1.isEmpty {
                newFileId = value1
            }
            
        }
    }
    func reloadFileData() {
        let arr = JNDataUtil.shared.loadAllData()
        let sortList: [[String : Any]]
        
        switch selectedOption {
        case 1:
            sortList = JNDataUtil.shared.sortByTitle(data: arr)
        case 2:
            sortList = JNDataUtil.shared.sortByFileSize(data: arr)
        default:
            sortList = JNDataUtil.shared.sortByTimeDescending(data: arr)
        }
        
        pdfList = sortList // 直接赋值
        tableView.reloadData()
    }
    func changeNameWithIndex(index : Int){
        let pdfData = pdfList[index]
        if let title = pdfData["title"] as? String ,let ID = pdfData["id"] as? String{
            let popupView = JNUrlPopView(frame: self.view.bounds, title: "Name",placeholder: "Enter Name", confirmButtonText: "Confirm")
            popupView.textField.text = title
            // 设置确定按钮的回调
            popupView.onConfirm = { inputText in
                JNDataUtil.shared.updateTitle(forID: ID, newTitle: inputText ?? "")
                self.reloadFileData()
                
            }
            // 添加到视图中
            AppUtil.getWindow()?.rootViewController?.view.addSubview(popupView)
        }
        
    }
    
    
}
extension JNHistoryVC :UITableViewDelegate, UITableViewDataSource,EmptyDataSetSource, EmptyDataSetDelegate,PopupSelectionDelegate{
    // MARK: - UITableView DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pdfList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PDFCell", for: indexPath) as? PDFTableViewCell else {
            return UITableViewCell()
        }
        
        let pdfData = pdfList[indexPath.row]
        cell.configureData(with: pdfData)
        cell.backgroundColor = .hex("f9f9f9")
        cell.contentView.backgroundColor = .hex("f9f9f9")
        if let ID = pdfData["id"] as? String,ID == newFileId {
            cell.doAnimations()
            newFileId = ""
        }
        let ID = pdfData["id"] as? String ?? ""
        let pdfpath = pdfData["filePath"] as? String ?? ""
        cell.selectActionBlock = { index in
            switch index {
            case 0:
                self.changeNameWithIndex(index: indexPath.row)
                break
            case 1:
                JNDataUtil.shared.deleteData(forID: ID)
                self.reloadFileData()
                break
            case 2:
                JNFileUtil().shareFile(from: pdfpath, viewController: self)
                break
            default:
                break
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pdfData = pdfList[indexPath.row]

        if let filePath = pdfData["filePath"] as? String,!filePath.isEmpty {
            let detailVC = JNPDFDetailViewController()
            detailVC.urlString = filePath
            pushViewCon(detailVC)
        }
        
        
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "No data".local
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.hex("#141416", alpha: 0.6)]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
    }
    ////空数据按钮图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "Group 1000005413")
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -20
    }
    func didSelectOption(_ option: Int) {
        selectedOption = option
        reloadFileData()
//        let names = ["Newest","Name","Size"]
//        self.filterButton .setTitle(names[selectedOption], for: .normal)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("height == \(bgHeader.height),\(scrollView.contentOffset.y)")
        let tabviewHframe = CGFloat(pdfList.count * 84)
        let tableviewHeight = kScreenHeight - kNavBarHeight - kBottomSafeHeight - 60
        guard tabviewHframe > tableviewHeight else { return  }
        if scrollView.contentOffset.y > 30 {
            bgHeader.height = kNavBarHeight
            titleLabel.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(kNavBarHeight + 20)
            }
            bgHeader.image = UIImage(named: "history_bg_title")
        }else if bgHeader.height == kNavBarHeight{
            bgHeader.height = kNavBarHeight + 10
            bgHeader.image = UIImage(named: "Rectangle 23309")
            titleLabel.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(kNavBarHeight + 30)
            }
        }
    }
}
