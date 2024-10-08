//
//  JNSearchViewController.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/20.
//

import UIKit

class JNSearchViewController: UIViewController {

    
    // 创建搜索栏
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        return sb
    }()
    
    // 创建表格视图
    let tableView: UITableView = {
        var tableView = UITableView()
        // TableView setup
        tableView.backgroundColor = .hex("f9f9f9")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var pdfList : [[String : Any]] = []
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
////        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
////        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
////        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
////        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
////        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
////        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
////        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hex("f9f9f9")
        // 设置背景图片
        let backgroundImage = UIImage(named: "history_bg_title")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kNavBarHeight)
        }
        // 设置搜索栏的背景为透明
            searchBar.backgroundImage = UIImage()
            searchBar.barTintColor = UIColor.clear // 确保背景是透明的
            searchBar.searchTextField.backgroundColor = .white // 设置搜索框内部背景色为白色
            searchBar.searchTextField.textColor = .black // 搜索框文本颜色
        // 设置搜索栏和取消按钮
        setupSearchBar()
        
        // 设置表格视图
        setupTableView()
    }
    
    // 隐藏导航栏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // 设置搜索栏和取消按钮
    func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        
        // 添加取消按钮
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        cancelButton.titleLabel?.font = boldSystemFont(ofSize: 16)
        // 使用SnapKit进行布局
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarHeight )
            make.left.equalTo(view.snp.left).offset(10)
            make.right.equalTo(cancelButton.snp.left).offset(-10)
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.right.equalTo(view.snp.right).offset(-10)
        }
    }
    
    // 设置表格视图
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(PDFTableViewCell.self, forCellReuseIdentifier: "PDFCell")
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(view)
        }
    }
    
    // 取消按钮操作
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    func searchResult(){
        if let key = searchBar.text {
            let arr = JNDataUtil.shared.filterByKeyword(keyword: key)
            pdfList = arr
            tableView.reloadData()
        }
        
    }
    func changeNameWithIndex(index : Int){
        let pdfData = pdfList[index]
        if let title = pdfData["title"] as? String ,let ID = pdfData["id"] as? String{
            let popupView = JNUrlPopView(frame: self.view.bounds, title: "Name",placeholder: "Enter Name", confirmButtonText: "Confirm")
            popupView.textField.text = title
            // 设置确定按钮的回调
            popupView.onConfirm = { inputText in
                JNDataUtil.shared.updateTitle(forID: ID, newTitle: inputText ?? "")
                self.searchResult()
                
            }
            // 添加到视图中
            AppUtil.getWindow()?.rootViewController?.view.addSubview(popupView)
        }
        
    }
    
}
extension JNSearchViewController:UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,EmptyDataSetSource, EmptyDataSetDelegate{
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
        let ID = pdfData["id"] as? String ?? ""
        let pdfpath = pdfData["filePath"] as? String ?? ""
        cell.selectActionBlock = { index in
            switch index {
            case 0:
                self.changeNameWithIndex(index: indexPath.row)
                break
            case 1:
                JNDataUtil.shared.deleteData(forID: ID)
                self.searchResult()
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
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "No data".local
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.hex("#141416", alpha: 0.6)]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pdfData = pdfList[indexPath.row]

        if let filePath = pdfData["filePath"] as? String,!filePath.isEmpty {
            let detailVC = JNPDFDetailViewController()
            detailVC.urlString = filePath
            pushViewCon(detailVC)
        }
        
        
    }
    ////空数据按钮图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "Group 1000005413")
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -20
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 实时更新搜索内容
        // 这里可以实现搜索过滤功能
        searchResult()
    }
}
