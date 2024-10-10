//
//  AllToolsVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import UIKit
import UniformTypeIdentifiers
import MobileCoreServices
import VisionKit

class AllToolsVC: BaseViewController, UINavigationControllerDelegate {
   
    let dcVc = VNDocumentCameraViewController()
    // 数据源
    let sections = [
        ("Help you get started", [
            ("Image to \n PDF", "scan_image"),
            ("Word to PDF", "scan_word"),
            ("Scan", "scan _scan")
        ]),
        ("Files Convert", [
            ("PPT to PDF", "scan_pdf"),
            ("URL to PDF", "Group 1000005318"),
            ("Camera", "scan_camera"),
            ("iCloud", "scan_icloud"),
            ("Other app", "scan_menu")
        ]),
        ("PDF Toolbox", [
            
            ("Merge pdf files", "scan_copy"),
            ("Compress files", "scan_yasuo")
        ])
    ]
    var images = [UIImage()]
    var chooseFileType = 0
    let imagePickTool = CLImagePickerTool()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemW = (kScreenWidth - 80)/3
        layout.itemSize = CGSize(width: itemW, height: itemW) // 设置卡片的大小
        layout.minimumLineSpacing = 16 // 设置卡片之间的行距
        layout.minimumInteritemSpacing = 7 // 设置卡片之间的列间距
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // 内边距
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 40) // 设置标题视图的高度
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .hex("f9f9f9")
        //        isHideCustomNav = true
        setupUI()
        setupCollectionView()
    }
    
    // 设置 CollectionView
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .hex("F9F9F9")
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarHeight + 20)
        }}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customNav.backgroundColor = .clear
    }
    func setupUI() {
        setNav()
    }
    func setNav(){
        let bgHeader = UIFastCreatTool.createImageView("Rectangle 23309")
        view.addSubview(bgHeader)
        bgHeader.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavBarHeight + 10)
        
        
        let titleL = UIFastCreatTool.createLabel("All Tools",fontSize: 26,textColor: .white)
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
    @objc func event() {
        
        
        
        
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
    // 打开“文件”应用以选择 Word 文件
    func openDocumentPicker(for type: Int) {
        chooseFileType = type
        let documentPicker: UIDocumentPickerViewController
        
        // 根据传入的参数设置支持的文件类型
        var supportedTypes: [String] = []
        
        if type == 0 {
            // Word 文件类型：.doc 和 .docx
            if #available(iOS 14.0, *) {
                let docTypes: [UTType] = [UTType("com.microsoft.word.doc")!, UTType("org.openxmlformats.wordprocessingml.document")!]
                documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: docTypes, asCopy: true)
            } else {
                // iOS 14.0 之前使用 kUTType 常量
                supportedTypes = [kUTTypeText as String, kUTTypeCompositeContent as String]
                documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
            }
        } else if type == 1 {
            // PowerPoint 文件类型：.ppt 和 .pptx
            if #available(iOS 14.0, *) {
                let pptTypes: [UTType] = [UTType("com.microsoft.powerpoint.ppt")!, UTType("org.openxmlformats.presentationml.presentation")!]
                documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: pptTypes, asCopy: true)
            } else {
                // iOS 14.0 之前使用 kUTType 常量
                supportedTypes = [kUTTypePresentation as String, kUTTypeCompositeContent as String]
                documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
            }
        }else if type == 2{
            if #available(iOS 14.0, *) {
                        // iOS 14 及以后使用 UTType 常量，允许选择图片、Word、PPT 文件
                        let supportedTypes: [UTType] = [
                            UTType.image, // 图片类型 (.jpeg, .png, .heic 等)
                            UTType(filenameExtension: "ppt")!, // PowerPoint 文件 .ppt
                            UTType(filenameExtension: "pptx")!, // PowerPoint 文件 .pptx
                            UTType(filenameExtension: "doc")!, // Word 文件 .doc
                            UTType(filenameExtension: "docx")! // Word 文件 .docx
                        ]
                        documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
                    } else {
                        // iOS 14 之前使用 kUTType 常量
                        let supportedTypes = [
                            kUTTypeImage as String, // 图片类型
                            kUTTypePresentation as String, // PPT 文件类型
                            kUTTypeCompositeContent as String, // Word 文件类型
                        ]
                        documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
                    }
        }else {
            // 非法类型
            print("未知的文件类型选择")
            return
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
    func cameraAction(){
        // 检查设备是否有相机
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true // 如果你希望用户可以编辑照片
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("相机不可用")
            // 提示用户相机不可用
            let alert = UIAlertController(title: "Error", message: "Camera not available on this device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension AllToolsVC:UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        let item = sections[indexPath.section].1[indexPath.item]
        cell.configure(with: item.0, imageName: item.1)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0,indexPath.row == 0 {
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
                            } else {
                                self.editimagesAction(with: imageArr)
                            }
                        }
                        self.present(popupVC, animated: true, completion: nil)
                    }
                }, failedClouse: { () in
                })
                
            }
        } else if indexPath.section == 1,indexPath.row == 2 {
            imagePickTool.cameraOut = true
            imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1, superVC: self) { (asset,cutImage) in
                print("返回的asset数组是\(asset)")
            }
        }else if indexPath.section == 1,indexPath.row == 1 {
            urlToPdf()
        }else if indexPath.section == 0,indexPath.row == 1 {
            openDocumentPicker(for: 0)
        }else if indexPath.section == 0,indexPath.row == 2 {
            scanAction()
        }else if indexPath.section == 1,indexPath.row == 0 {
            openDocumentPicker(for: 1)
        }else if indexPath.section == 1,indexPath.row == 2 {
            openDocumentPicker(for: 1)
        }else if indexPath.section == 1,indexPath.row == 3 {
            openDocumentPicker(for: 2)
        }else if indexPath.section == 1,indexPath.row == 4 {
            pushViewCon(JNImportDocumentViewController())
        }else if indexPath.section == 2,indexPath.row == 0 {
            mergeAction()
        }else if indexPath.section == 2,indexPath.row == 1 {
            openDocumentPicker(for: 1)
        }
    }
    
    // MARK: - Section Header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            header.titleLabel.text = sections[indexPath.section].0
            return header
        }
        return UICollectionReusableView()
    }
    func urlToPdf(){
        let popupView = JNUrlPopView(frame: self.view.bounds, title: "URL to PDF",placeholder: "Enter Url", confirmButtonText: "Confirm")
        
        // 设置确定按钮的回调
        popupView.onConfirm = { inputText in
            if let validURL = String().validateAndFormatURL(inputText!) {
                print("有效的网址: \(validURL)")
                let urlPdf = JNWebToPDFVC()
                urlPdf.urlString = validURL
                self.navigationController?.pushViewController(urlPdf, animated: true)
            } else {
                ProgressHUD.showMessage("Please enter the correct URL")
            }
            
        }
        // 添加到视图中
        AppUtil.getWindow()?.rootViewController?.view.addSubview(popupView)
        
    }
    func mergeAction(){
        let popupView = JNImportChooseView(frame: self.view.bounds, title: "Import File")
        
        popupView.onConfirm = { index in
            if index == 0 {
                self.pushViewCon(JNImportHistoryVC())
            }
        }
        // 添加到视图中
        AppUtil.getWindow()?.rootViewController?.view.addSubview(popupView)
    }
}
extension AllToolsVC: UIDocumentPickerDelegate ,VNDocumentCameraViewControllerDelegate,UIImagePickerControllerDelegate{

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        print("Selected file URL: \(selectedFileURL)")
        // 获取的是图片
        let fileExtension = selectedFileURL.pathExtension.lowercased()
        let fileName = selectedFileURL.lastPathComponent // 获取文件名

        if ["jpg", "jpeg", "png", "heic"].contains(fileExtension) {
            // 如果是图片，读取图片对象
            if let image = UIImage(contentsOfFile: selectedFileURL.path) {
                let vc = JNConversationVC()
                vc.images = [image]
                vc.imageNames = [fileName]
                navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
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
            urlPdf.filetype = chooseFileType
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

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("用户取消了选择")
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // 获取拍摄的照片
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.conversationAction(with: [image])
            } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.conversationAction(with: [image])

            }
            
            // 关闭相机界面
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // 用户取消了拍照
            picker.dismiss(animated: true, completion: nil)
        }
        
}

class CustomCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .hex("#141416")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-17)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(34)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(5)
            make.height.equalTo(34)
        }
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, imageName: String) {
        titleLabel.text = title
        imageView.image = UIImage(named: imageName)
    }
}

class SectionHeader: UICollectionReusableView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
