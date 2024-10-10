//
//  JNImportHistoryVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/10/10.
//

import UIKit

class JNImportHistoryVC: BaseViewController {
    let tableView: UITableView = {
        var tableView = UITableView()
        // TableView setup
        tableView.backgroundColor = .hex("f9f9f9")
        tableView.separatorStyle = .none
        return tableView
    }()
    var selelctedArr : [String] = []
    var pdfList : [[String : Any]] = []
    let button = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.barBackgroundImage = UIImage(color: grayColor)
        customNav.title = "History"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(PDFhidtoryTableViewCell.self, forCellReuseIdentifier: "PDFhidtoryTableViewCell")
//        tableView.bounces = false
        tableView.frame = CGRect(x: 0, y: kNavBarHeight, width: kScreenWidth, height: kScreenHeight - kNavBarHeight - 90 - kBottomSafeHeight)
        
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = boldSystemFont(ofSize: 18)
        button.backgroundColor = MainColor
        button.setTitleColor(.white, for: .normal)
        button.addGradationColor(width: Float(kScreenWidth) - 40, height: 59)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addClickAction(action: confirmAction)
        view.addSubview(button)
        button.isHidden = true
        // 使用 SnapKit 设置按钮的约束
        button.snp.makeConstraints { make in
            make.height.equalTo(59)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
//        let topView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavBarHeight))
//        view.addSubview(topView)
//        topView.backgroundColor = grayColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let arr = JNDataUtil.shared.loadAllData()
        pdfList = JNDataUtil.shared.sortByTimeDescending(data: arr)
        tableView.reloadData()
    }
    
    @objc func confirmAction(Btn:UIButton){
        let filteredArray = pdfList.filter { dict in
            if let id = dict["id"] as? String{
                return selelctedArr.contains(id)
            }
            return false
        }
        let vc = JNImportHistoryEditVC()
        vc.pdfList = filteredArray
        pushViewCon(vc)
    }
    

}
extension JNImportHistoryVC :UITableViewDelegate, UITableViewDataSource,EmptyDataSetSource, EmptyDataSetDelegate{

    
    // MARK: - UITableView DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pdfList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PDFhidtoryTableViewCell", for: indexPath) as? PDFhidtoryTableViewCell else {
            return UITableViewCell()
        }
        
        let pdfData = pdfList[indexPath.row]
        cell.configureData(with: pdfData)
        cell.backgroundColor = .hex("f9f9f9")
        cell.contentView.backgroundColor = .hex("f9f9f9")
        
        let ID = pdfData["id"] as? String ?? ""
        if !selelctedArr.contains(ID) {
            cell.selectImageV.image = UIImage(named: "history_choose_normal")
        }else{
            cell.selectImageV.image = UIImage(named: "history_choose_sel")

        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pdfData = pdfList[indexPath.row]
        let ID = pdfData["id"] as? String ?? ""
        if let index = selelctedArr.firstIndex(of: ID) {
            // 如果包含字符串A，删除它
            selelctedArr.remove(at: index)
        } else {
            // 如果不包含字符串A，添加它
            selelctedArr.append(ID)
        }

        button.isHidden = selelctedArr.count < 2
        tableView.reloadData()
        
        
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
// Custom UITableViewCell
class PDFhidtoryTableViewCell: UITableViewCell {
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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
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
    

    let selectImageV  = UIFastCreatTool.createImageView()
    var selectActionBlock:((_ index:Int)->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        backgroundColor = .white
        selectionStyle = .none
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        selectImageV.image = UIImage(named: "history_choose_normal")
        contentView.addSubview(bgview)
        bgview.addSubview(pdfIconImageView)
        bgview.addSubview(titleLabel)
        bgview.addSubview(dateLabel)
        bgview.addSubview(selectImageV)
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
            make.right.equalTo(selectImageV.snp.left).offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        
        selectImageV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(-5)
            make.width.height.equalTo(22)
        }
    }
    
    func configure(with title: String, date: String, size: String) {
        titleLabel.text = title
        dateLabel.text = date
        pdfIconImageView.image = UIImage(named: "scan_word")
        
    }
    func configureData(with data:[String:Any]) {
        if let title = data["title"] as? String {
            titleLabel.text = title
        }
        if let date = data["currentTime"] as? String ,let dateStr = String().convertDateFormat(dateString: date),let sizeStr = data["fileSize"] as? String{
            dateLabel.text = "\(dateStr) \(sizeStr)"
        }
        if let image = data["image"] as? Data {
            pdfIconImageView.image = UIImage(data: image)
        }else if let imageUrl = data["image"] as? String,imageUrl.hasSuffix(".ico"){
            pdfIconImageView.kf.setImage(with: URL(string: imageUrl),placeholder: UIImage(named: "pdfImage_placeholder"))
        }else{
            pdfIconImageView.image = UIImage(named: "pdfImage_placeholder")
        }
        
        
    }
    @objc func moreAction(_ button:UIButton){
    }
}
