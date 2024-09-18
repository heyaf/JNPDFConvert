//
//  HomeVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import UIKit

class HomeVC: BaseViewController {
    
    // UI Elements
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Last 3 days", "Month", "6 Month"])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .clear
        
        // 设置默认选中和未选中的状态
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    let segmengView = UIView().then { make in
        make.layer.cornerRadius = 8
        make.layer.masksToBounds = true
        make.backgroundColor = MainColor
    }
    
    
    let tableView: UITableView = {
        var tableView = UITableView()
        // TableView setup
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    var topbgimageV = UIImageView()
    
    
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
        view.backgroundColor = .white
        isHideCustomNav = true
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customNav.backgroundColor = .clear
    }
    
    func setupUI() {
        topUI()
        setNav()
        bottomUI()
        pdfList.removeAll()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(PDFTableViewCell.self, forCellReuseIdentifier: "PDFCell")
    }
    
    func setNav(){
        let titleL = UIFastCreatTool.createLabel("PDF Convert",fontSize: 26,textColor: .white)
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
    func topUI(){
        let bgImageV = UIFastCreatTool.createHeadImageView("bg_home")
        self.view.addSubview(bgImageV)
        bgImageV.backgroundColor = MainColor
        bgImageV.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(kNavBarHeight + kWidthScale * 132 + 18 + 32 + 18 + 70)
        }
        topbgimageV = bgImageV
        let corverImageV = UIFastCreatTool.createHeadImageView("img_banner")
        
        let wordView = UIFastCreatTool.createView(backgroundColor: .white,cornerRadius: 18)
        let scanView = UIFastCreatTool.createView(backgroundColor: .white,cornerRadius: 18)
        let bottomView = UIFastCreatTool.createView(backgroundColor: .white,cornerRadius: 18)
        bgImageV.addSubviews([corverImageV,wordView,scanView,bottomView])
        
        corverImageV.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(kNavBarHeight + 18)
            make.height.equalTo(kWidthScale * 132)
        }
        
        let width = (kScreenWidth - 36 - 16) / 2
        wordView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(corverImageV.snp.bottom).offset(16)
            make.size.equalTo(CGSize(width: width, height: 70))
        }
        scanView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(18)
            make.top.equalTo(corverImageV.snp.bottom).offset(16)
            make.size.equalTo(CGSize(width: width, height: 70))
        }
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.bottom.equalToSuperview().offset(18)
            make.left.right.equalToSuperview()
        }
        setmodule(view: wordView, title: "Word to PDF", Icon: "scan 877")
        setmodule(view: scanView, title: "Scan", Icon: "scan 879")

        let corverTap = UITapGestureRecognizer(target: self, action: #selector(cotverImage(_:)))
        corverImageV.addGestureRecognizer(corverTap)
        bgImageV.isUserInteractionEnabled = true
        corverImageV.isUserInteractionEnabled = true
        
        
    }
    func bottomUI(){
        
        let historyL = UIFastCreatTool.createLabel("History",fontSize: 20,textColor: .hexString("#141416"))
        historyL.font = .boldSystemFont(ofSize: 18)
        view.addSubview(historyL)
        
        let moreL = UIFastCreatTool.createLabel("More",fontSize: 20,textColor: UIColor.hexString("#141416"),textAlignment: .right)
        moreL.font = .boldSystemFont(ofSize: 18)
        view.addSubview(moreL)
        
        let moreimageV = UIFastCreatTool.createImageView("Group 1000005286")
        view.addSubview(moreimageV)
        
        historyL.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(topbgimageV.snp.bottom).offset(9)
            make.size.equalTo(CGSize(width: 150, height: 21))
        }
        moreL.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(48)
            make.top.equalTo(topbgimageV.snp.bottom).offset(9)
            make.size.equalTo(CGSize(width: 90, height: 21))
        }
        moreimageV.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(18)
            make.centerY.equalTo(moreL)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        let moreBtn = UIFastCreatTool.createButton()
        view.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(18)
            make.centerY.equalTo(topbgimageV)
            make.size.equalTo(CGSize(width: 120, height: 20))
        }
        moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        
        view.addSubview(segmentControl)
        segmentControl.addSubview(segmengView)
        segmentControl.sendSubviewToBack(segmengView)
        // 添加值改变事件监听
                segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        view.addSubview(tableView)
        
        // Layout with SnapKit
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(historyL.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.height.equalTo(32)
        }
        segmengView.frame = CGRect(x: 0, y: 0, width: (kScreenWidth - 32) / 3, height: 32)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    func setmodule(view: UIView,title : String,Icon:String) {
        let title = UIFastCreatTool.createLabel(title,textColor: .hexString("#141416"))
        title.font = .boldSystemFont(ofSize: 16)
        
        let icon = UIFastCreatTool.createImageView(Icon)
        
        view.addSubviews([title,icon])
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.right.equalTo(icon.snp.left).offset(10)
        }
        icon.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.width.equalTo(34)
            make.height.equalTo(34)
        }
        
    }
    @objc func searchAction(){
        
    }
    @objc func settingAction(){
        
    }
    @objc func moreAction(){
        
    }
    @objc func cotverImage(_ gesture: UITapGestureRecognizer) {
        let menuBubble = BTBubble.makeMenuBubble()
        
        let item1 = BTBubble.Menu.Item(text: "Rename", identifier: "Rename", image: UIImage(named: "edit_edit"))
        let item2 = BTBubble.Menu.Item(text: "Delete", identifier: "Delete", image: UIImage(named: "edit_del"))
        let item3 = BTBubble.Menu.Item(text: "Share", identifier: "Share", image: UIImage(named: "edit_share"))
  

        
        var config = BTBubble.Menu.Config()
        config.width = .fixed(220)
        let menuView = BTBubbleMenu(items: [item1, item2, item3], config: config)
        menuView.selectItemBlock = { item in
           
            switch item.identifier {
            case "Delete":
                break
            case "Share":
                break
           
            default:
                break
            }
            
        }
        
        menuBubble.show(customView: menuView, direction: .auto, from:gesture.view! , duration: nil)
        menuBubble.shouldShowMask = true
        menuBubble.maskColor = .black.withAlphaComponent(0.2)
    }
    @objc func segmentChanged(_ sender: UISegmentedControl) {
            // 处理切换逻辑
        let segmentWidth = (view.frame.width - 32) / 3

        UIView.animate(withDuration: 0.2) {
            self.segmengView.x = segmentWidth * CGFloat(sender.selectedSegmentIndex)
        }
        
        }
}
extension HomeVC :UITableViewDelegate, UITableViewDataSource,EmptyDataSetSource, EmptyDataSetDelegate{
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
        return -80
    }
    
}
// Custom UITableViewCell
class PDFTableViewCell: UITableViewCell {
    let menuBubble = BTBubble()
    let bgview = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.hexString("#AAB1BC",alpha: 0.2).cgColor
        $0.layer.borderWidth = 1
    }
    
    
    let pdfIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pdf_icon") // Place your PDF icon image here
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .hexString("#141416")
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .hexString("#ACB4BE")
        return label
    }()

    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("...", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
       
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        backgroundColor = .white
        selectionStyle = .none
        setupUI()
        moreButton.addTarget(self, action: #selector(moreAction(_:)), for: .touchUpInside)
        menuBubble.shouldShowMask = true
        menuBubble.maskColor = .hexString("#0C0C0C").withAlphaComponent(0.6)
        menuBubble.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(bgview)
        bgview.addSubview(pdfIconImageView)
        bgview.addSubview(titleLabel)
        bgview.addSubview(dateLabel)
        bgview.addSubview(moreButton)
        bgview.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(72)
        }
        // Layout using SnapKit
        pdfIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(49)
            make.height.equalTo(58)

        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(pdfIconImageView.snp.right).offset(14)
            make.right.equalTo(moreButton.snp.left).offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        
        moreButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(-5)
            make.width.height.equalTo(30)
        }
    }
    
    func configure(with title: String, date: String, size: String) {
        titleLabel.text = title
        dateLabel.text = date
        
    }
    @objc func moreAction(_ button:UIButton){
        
        let item1 = BTBubble.Menu.Item(text: "Rename", identifier: "Rename", image: UIImage(named: "edit_edit"))
        let item2 = BTBubble.Menu.Item(text: "Delete", identifier: "Delete", image: UIImage(named: "edit_del"))
        let item3 = BTBubble.Menu.Item(text: "Share", identifier: "Share", image: UIImage(named: "edit_share"))
  

        
        var config = BTBubble.Menu.Config()
        config.width = .fixed(220)
        let menuView = BTBubbleMenu(items: [item1, item2, item3], config: config)
        menuView.selectItemBlock = { item in
           
            switch item.identifier {
            case "Delete":
                break
            case "Share":
                break
           
            default:
                break
            }
            
        }
        
        menuBubble.show(customView: menuView, direction: .auto, from: button, duration: nil)
//        menuBubble.y = kScreenH - TabBarHeight - menuBubble.height - 10
//        menuBubble.fillColor = UIColor.black.withAlphaComponent(0.2)
//        addFullwithView(view: menuBubble)
        
//        let linv = UIFastCreatTool.getLine(UIColor.hexString("#545458").withAlphaComponent(0.7))
//        linv.frame = CGRect(x: 0, y: 42, width: menuBubble.width, height: 0.5)
//        
//        let linv2 = UIFastCreatTool.getLine(UIColor.hexString("#545458").withAlphaComponent(0.7))
//        linv2.frame = CGRect(x: 0, y: 84, width: menuBubble.width, height: 0.5)
//        
//        let linv3 = UIFastCreatTool.getLine(UIColor.hexString("#545458").withAlphaComponent(0.7))
//        linv3.frame = CGRect(x: 0, y: 126, width: menuBubble.width, height: 0.5)
//        menuBubble.addSubviews([linv,linv2,linv3])
    }
}
