//
//  HomeVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import UIKit
import VisionKit
import UniformTypeIdentifiers
import MobileCoreServices

class HomeVC: BaseViewController {
    let dcVc = VNDocumentCameraViewController()
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
    var selelctIndex = 0
    
    // Sample data
    var pdfList : [[String : Any]] = []
//    ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB"),
//        ("Pdf 202409081823", "May, 13 2024 18:23", "2.3 MB")
//    ]
    
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
        reloadFileData()
    }
    func reloadFileData() {
        let sortList: [[String : Any]]
        
        switch selelctIndex {
        case 1:
            sortList = JNDataUtil.shared.getRecentThreeDaysData()
        case 2:
            sortList = JNDataUtil.shared.getRecentMonthData()
        default:
            sortList = JNDataUtil.shared.getRecentSixMonthsData()
        }
        
        pdfList = sortList // 直接赋值
        tableView.reloadData()
    }
    func setupUI() {
        topUI()
        setNav()
        bottomUI()
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

        corverImageV.tag = 333
        wordView.tag = 334
        scanView.tag = 335
        let corverTap = UITapGestureRecognizer(target: self, action: #selector(cotverImage(_:)))
        corverImageV.addGestureRecognizer(corverTap)
        bgImageV.isUserInteractionEnabled = true
        corverImageV.isUserInteractionEnabled = true
        let corverTap1 = UITapGestureRecognizer(target: self, action: #selector(cotverImage(_:)))
        let corverTap2 = UITapGestureRecognizer(target: self, action: #selector(cotverImage(_:)))

        wordView.addGestureRecognizer(corverTap1)
        scanView.addGestureRecognizer(corverTap2)
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
            make.centerY.equalTo(moreL)
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
        let searchVC = JNSearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
    @objc func settingAction(){
        let setVC = JNSettingVC()
        pushViewCon(setVC)
    }
    @objc func moreAction(){
       let tabbar = AppUtil.getWindow()?.rootViewController as? TabBarController
        tabbar?.changeToIndex(index: 2)
    }
    @objc func cotverImage(_ gesture: UITapGestureRecognizer) {
        if gesture.view?.tag == 333 {
            imageAction()
        }else if gesture.view?.tag == 334 {
            openDocumentPicker()
        }else if gesture.view?.tag == 335 {
            scanAction()
        }
       
    }
    @objc func segmentChanged(_ sender: UISegmentedControl) {
            // 处理切换逻辑
        let segmentWidth = (view.frame.width - 32) / 3

        UIView.animate(withDuration: 0.2) {
            self.segmengView.x = segmentWidth * CGFloat(sender.selectedSegmentIndex)
        }
        selelctIndex = sender.selectedSegmentIndex
        reloadFileData()
        
        }
    
    func imageAction(){
        let imagePickTool = CLImagePickerTool()
        imagePickTool.isHiddenVideo = true
        imagePickTool.navColor = MainColor
        imagePickTool.navTitleColor = .white
        imagePickTool.statusBarType = .white
        imagePickTool.showCamaroInPicture = false
        
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 9, superVC: self) { (asset,cutImage) in
            var imageArr = [UIImage]()
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: { (image,assetItem) in
                imageArr.append(image)
                if imageArr.count == asset.count {
                    let popupVC = JNPictureChooseVC(images: imageArr)
                    popupVC.buttonAction = { action in
                        print("按钮点击: \(action)")
                        if action == 1 {
                            self.conversationAction(with: imageArr)
                        }else{
                            self.editimagesAction(with: imageArr)
                        }
                    }
                    self.present(popupVC, animated: true, completion: nil)
                }
            }, failedClouse: { () in
            })
            
        }
    }

    // 打开“文件”应用以选择 Word 文件
    func openDocumentPicker() {
        let documentPicker: UIDocumentPickerViewController
        
        // 根据传入的参数设置支持的文件类型
        var supportedTypes: [String] = []
        
            // Word 文件类型：.doc 和 .docx
            if #available(iOS 14.0, *) {
                let docTypes: [UTType] = [UTType("com.microsoft.word.doc")!, UTType("org.openxmlformats.wordprocessingml.document")!]
                documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: docTypes, asCopy: true)
            } else {
                // iOS 14.0 之前使用 kUTType 常量
                supportedTypes = [kUTTypeText as String, kUTTypeCompositeContent as String]
                documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
            }
       
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    func scanAction(){
        if #available(iOS 13.0, *) {
            
            // 判断当前设备是否支持 VNDocumentCameraViewController
            if !VNDocumentCameraViewController.isSupported {
                
                let alertController = UIAlertController(title: "Message", message: "", preferredStyle: .alert)
                
                if let view = alertController.view.subviews.first,
                   let view1 = view.subviews.first,
                   let view2 = view1.subviews.first {
                    view2.backgroundColor = .hexString("#1E1E1E", alpha: 0.75)
                }
                
                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                
                alertController.addAction(okAction)
                
                let str1 = "This device does not support it"
                let titleText = NSMutableAttributedString(string: str1)
                titleText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17), .foregroundColor: UIColor.white], range: NSRange(location: 0, length: str1.count))
                
                alertController.setValue(titleText, forKey: "attributedTitle")
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
           
            dcVc.delegate = self
            
            self.present(dcVc, animated: true, completion: nil)
        }
    }
    func conversationAction(with images:[UIImage]){
        let vc = JNConversationVC()
        vc.images = images
        vc.imageNames = AppUtil().generateStringArray(count: images.count)
        navigationController?.pushViewController(vc, animated: true)
    }
    func editimagesAction(with images:[UIImage]){
        let vc = JNImagesEditVC()
        vc.images = images
        navigationController?.pushViewController(vc, animated: true)
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
extension HomeVC :UITableViewDelegate, UITableViewDataSource,EmptyDataSetSource, EmptyDataSetDelegate,VNDocumentCameraViewControllerDelegate,UIDocumentPickerDelegate{
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
        let ID = pdfData["id"] as? String ?? ""
        let pdfpath = pdfData["filePath"] as? String ?? ""
        cell.configureData(with: pdfData)
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
        return -80
    }


    @available(iOS 13.0, *)
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        self.dcVc.dismiss(animated: true, completion: nil)
        
        if scan.pageCount < 1 {
            return
        }
        
        var images: [UIImage] = []
        for i in 0..<scan.pageCount {
            let img = scan.imageOfPage(at: i)
            images.append(img)
        }
        conversationAction(with: images)
    }

    @available(iOS 13.0, *)
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        self.dcVc.dismiss(animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        print("Selected file URL: \(selectedFileURL)")
        
        // 处理选择的文件
        do {
            let fileManager = FileManager.default
            let destURL = fileManager.temporaryDirectory.appendingPathComponent(selectedFileURL.lastPathComponent)
            if fileManager.fileExists(atPath: destURL.path) {
                try fileManager.removeItem(at: destURL) // 确保目标路径没有同名文件
            }
            try fileManager.copyItem(at: selectedFileURL, to: destURL)
            print("File copied to: \(destURL)")
            
            ProgressHUD.showLoading()
            let urlPdf = JNFileToPDFVC()
            urlPdf.filepath = destURL.absoluteString
            urlPdf.filetype = 0
            urlPdf.callback = { imageArr in
                ProgressHUD.dismiss()
                urlPdf.dismiss(animated: false)
                self.conversationAction(with: imageArr)
            }
            urlPdf.failureCallback = { string in
                ProgressHUD.showError("fail")
                
            }
            urlPdf.startConversion()
            urlPdf.modalPresentationStyle = .overFullScreen
            self.present(urlPdf, animated: false) {
                urlPdf.view.isHidden = true
            }
            
        } catch {
            print("文件复制失败: \(error)")
        }
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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
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
    var selectActionBlock:((_ index:Int)->())?
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
        
        let item1 = BTBubble.Menu.Item(text: "Rename", identifier: "Rename", image: UIImage(named: "edit_edit"))
        let item2 = BTBubble.Menu.Item(text: "Delete", identifier: "Delete", image: UIImage(named: "edit_del"))
        let item3 = BTBubble.Menu.Item(text: "Share", identifier: "Share", image: UIImage(named: "edit_share"))
  

        
        var config = BTBubble.Menu.Config()
        config.width = .fixed(220)
        let menuView = BTBubbleMenu(items: [item1, item2, item3], config: config)
        menuView.selectItemBlock = { item in
           var selectIndex = 0
            switch item.identifier {
            case "Delete":
                selectIndex = 1
                break
            case "Share":
                selectIndex = 2
                break
           
            default:
                break
            }
            self.selectActionBlock?(selectIndex)
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
    func doAnimations(){
        contentView.backgroundColor = .hex("#E1F0FF")
        AfterGCD(timeInval: 1.0) {
            self.contentView.backgroundColor = .clear
            AfterGCD(timeInval: 0.5) {
                self.contentView.backgroundColor = .hex("#E1F0FF")
                AfterGCD(timeInval: 1.0) {
                    self.contentView.backgroundColor = .clear
                    
                }
            }
        }
    }
}
