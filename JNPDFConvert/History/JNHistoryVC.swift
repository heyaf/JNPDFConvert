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
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)

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
    
    
    // Sample data
    var pdfList = [
        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hex("f9f9f9")
        isHideCustomNav = true
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customNav.backgroundColor = .clear
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
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(PDFTableViewCell.self, forCellReuseIdentifier: "PDFCell")
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    func setNav(){
        let bgHeader = UIFastCreatTool.createImageView("Rectangle 23309")
        view.addSubview(bgHeader)
        bgHeader.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavBarHeight + 10)
        
        
        let titleL = UIFastCreatTool.createLabel("History",fontSize: 26,textColor: .white)
        titleL.font = .systemFont(ofSize: 26, weight: UIFont.Weight(rawValue: 900.0))
        view.addSubview(titleL)
        
        let searchBtn = UIFastCreatTool.createButton(normalImage: UIImage(named: "Group 1000005307"))
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
        
        
        
        
    }
    @objc func searchAction(){
        
    }
    @objc func settingAction(){
        
    }
    
    
    
}
extension JNHistoryVC :UITableViewDelegate, UITableViewDataSource,EmptyDataSetSource, EmptyDataSetDelegate{
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
        cell.configure(with: pdfData.0, date: pdfData.1, size: pdfData.2)
        cell.backgroundColor = .hex("f9f9f9")
        cell.contentView.backgroundColor = .hex("f9f9f9")
        return cell
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
    
}
