//
//  JNImportHistoryEditVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/10/10.
//

import UIKit

class JNImportHistoryEditVC: BaseViewController {

    let tableView: UITableView = {
        var tableView = UITableView()
        // TableView setup
        tableView.backgroundColor = .hex("f9f9f9")
        tableView.separatorStyle = .none
        return tableView
    }()
    var pdfList : [[String : Any]] = []
    let button = UIButton(type: .system)
    var deleteBlock :((String) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.barBackgroundImage = UIImage(color: grayColor)

        customNav.title = "Mergr Files"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(PDFhidtoryEditCell.self, forCellReuseIdentifier: "PDFhidtoryEditCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.dragInteractionEnabled = true  // 开启拖动手势
//        tableView.bounces = false
        tableView.frame = CGRect(x: 18, y: kNavBarHeight, width: kScreenWidth - 36, height: kScreenHeight - kNavBarHeight - 90 - kBottomSafeHeight)
        tableView.layer.cornerRadius = 14
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = grayColor
        button.setTitle("Merge PDF", for: .normal)
        button.titleLabel?.font = boldSystemFont(ofSize: 18)
        button.backgroundColor = MainColor
        button.setTitleColor(.white, for: .normal)
        button.addGradationColor(width: Float(kScreenWidth) - 40, height: 59)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addClickAction(action: confirmAction)
        view.addSubview(button)
        // 使用 SnapKit 设置按钮的约束
        button.snp.makeConstraints { make in
            make.height.equalTo(59)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        tableView.yh_enableLongPressDrag { IndexPath, CGPoint in
            return IndexPath.row != self.pdfList.count;
        } isDragMoveItem: { from, to in
            if to.row != self.pdfList.count,from.row != self.pdfList.count{
                let movedItem = self.pdfList.remove(at: from.row)
                self.pdfList.insert(movedItem, at: to.row)
                return true
            }
            return false
        }


    }
    
    
    @objc func confirmAction(Btn:UIButton){
        
    }
    

}
extension JNImportHistoryEditVC :UITableViewDelegate, UITableViewDataSource,EmptyDataSetSource, EmptyDataSetDelegate{

    
    // MARK: - UITableView DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pdfList.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < pdfList.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PDFhidtoryEditCell", for: indexPath) as? PDFhidtoryEditCell else {
                return UITableViewCell()
            }
            let pdfData = pdfList[indexPath.row]
            cell.configureData(with: pdfData)
            cell.DeleteAction = {
                self.pdfList.remove(at: indexPath.row)
                tableView.reloadData()
                self.deleteBlock?(pdfData["id"] as! String)
//                    tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
            return cell
        } else {
            let cell = UITableViewCell()
            let addImageButton = UIButton(type: .custom)
            
            // 设置图标和文字
            let addImage = UIImage(named: "conversation_add")
            addImageButton.setImage(addImage, for: .normal)
            addImageButton.setTitle("  Add more images", for: .normal)
            addImageButton.setTitleColor(MainColor, for: .normal)
            addImageButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
            addImageButton.backgroundColor = .hex("#F0F0F0")
            addImageButton.isUserInteractionEnabled = false
            // 居中显示
            cell.contentView.addSubview(addImageButton)
            addImageButton.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 36, height: 50)
            cell.contentView.backgroundColor = grayColor
            addImageButton.roundCorners(view:addImageButton,corners: [.bottomLeft, .bottomRight], radius: 14)
            return cell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == pdfList.count {
            popViewCon()
        }
    }
    
    // 允许 cell 拖动
        func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        // 更新数据源以反映拖动后的顺序
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            
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
class PDFhidtoryEditCell: UITableViewCell {
    let menuBubble = BTBubble()
    let bgview = UIView().then{
        $0.backgroundColor = .hex("#F0F0F0")
//        $0.layer.cornerRadius = 15
//        $0.layer.masksToBounds = true
//        $0.layer.borderColor = UIColor.hexString("#AAB1BC",alpha: 0.2).cgColor
//        $0.layer.borderWidth = 1
    }
    
    let deleteButton = UIButton(type: .custom)

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
    var DeleteAction: (() -> ())?

    let lineV = UIFastCreatTool.getLine(.hex("#E3E3E3"))
    let selectImageV  = UIFastCreatTool.createImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = grayColor
        backgroundColor = .white
        selectionStyle = .none
        setupUI()
        deleteButton.setBackgroundImage(UIImage(named: "conversation_reduce"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        selectImageV.image = UIImage(named: "merge_edit")
        contentView.addSubview(bgview)
        bgview.addSubview(pdfIconImageView)
        bgview.addSubview(titleLabel)
        bgview.addSubview(dateLabel)
        bgview.addSubview(selectImageV)
        bgview.addSubview(lineV)
        bgview.addSubview(deleteButton)
        bgview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // Layout using SnapKit
        pdfIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
            make.width.equalTo(42)
            make.height.equalTo(50)
            
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
        lineV.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(2)
            make.size.equalTo(24)
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
    // 处理删除按钮点击事件
    @objc func deleteTapped() {
        // 删除逻辑
        self.DeleteAction?()
    }
    @objc func moreAction(_ button:UIButton){
    }
}
