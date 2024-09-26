//
//  JNImagesEditVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/25.
//

import UIKit

class JNImagesEditVC: BaseViewController {
    
    var images : [UIImage] = []
    let scrollView = UIScrollView()
    let buttonNames = ["Rotation", "Crop", "Filter", "Sign", "Adjust"]
//    let buttonImage = ["Contrast_normal","editimage1_normal",
//                       "editimage2_normal","editimage3_normal",
//                       "editimage4_normal"]
//    let buttonImage_sec = ["Contrast_select","editimage1_select",
//                           "editimage2_select","editimage3_select",
//                           "editimage4_select"]
    let buttonImage = ["ic_Rotation","ic_Crop","ic_Filter","ic_sign","ic_adjust"]
    var buttonArr : [UIButton] = []
    lazy var edittitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = BlackColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.backgroundColor = .clear
        label.text = "edit"
        return label
    }()
    lazy var pageLabel:UILabel = {
        let label = UILabel()
        label.textColor = .hex("#141416").withAlphaComponent(0.6)
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.backgroundColor = .clear
        return label
    }()
    lazy var doneBtn:UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = boldSystemFont(ofSize: 18)
        button.setTitleColor(MainColor, for: .normal)
        button.backgroundColor = .clear
        button.setTitle("Done", for: .normal)
        return button
    }()
    let buttonStack = UIView()
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = grayColor
        setUpUI()
    }
    func setUpUI(){
        view.addSubview(edittitleLabel)
        view.addSubview(pageLabel)
        pageLabel.text = "1/\(images.count)"
        // 添加顶部导航栏的"Done"按钮
        view.addSubview(doneBtn)
        customNav.title = ""
        edittitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(statusBarHeight)
            make.height.equalTo(21)
        }
        pageLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(statusBarHeight + 21)
            make.height.equalTo(19)
        }
        doneBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(statusBarHeight + 12)
            make.height.equalTo(20)
            //            make.width.equalTo(40)
        }
        // 设置 ScrollView
        setupScrollView()
        
        // 添加图片到 ScrollView
        setupImagePages()
        
        
        // 添加底部按钮
        setupBottomButtons()
    }
    
    @objc func doneButtonTapped() {
        print("Done 按钮点击")
        // 处理 Done 按钮点击事件
    }
    
    func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight + 8)
            make.left.equalTo(view).offset(8)
            make.right.equalTo(view).offset(-8)
            make.bottom.equalToSuperview().inset(190)
        }
    }
    
    func setupImagePages() {
        let pageWidth = UIScreen.main.bounds.width - 16 // ScrollView 左右各留出 8 像素
        let pageHeight = UIScreen.main.bounds.height * 0.6
        
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(images.count), height: pageHeight)
        
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: CGFloat(index) * pageWidth, y: 0, width: pageWidth, height: pageHeight)
            imageView.tag = 10000 + index
            scrollView.addSubview(imageView)
        }
    }
    
    
    func setupBottomButtons() {
        
        
        
        buttonStack.backgroundColor = .white
        view.addSubview(buttonStack)
        buttonStack.backgroundColor = .white
        buttonStack.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(0)
            make.bottom.equalToSuperview()
            make.height.equalTo(80 + kBottomSafeHeight) // 图标 + 文字
        }
        
        for (index, buttonName) in buttonNames.enumerated() {
            let button = createBottomButton(name: buttonName, imagename: buttonImage[index])
            button.tag = 1000 + index
            
            
            let btnW = (kScreenWidth - 64 - 5 * 4)/5
            button.frame = CGRect(x: 32 + CGFloat(index) * (btnW + 5), y: 10, width: btnW, height: 60)
            button.imagePosition(style: .top, spacing: 6)
            
            buttonStack.addSubview(button)
        }
        let imageV = UIFastCreatTool.createImageView("shadow")
        view.addSubview(imageV)
        imageV.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(0)
            make.bottom.equalTo(buttonStack.snp.top)
            make.height.equalTo(36) // 图标 + 文字
        }
        
    }
    
    func createBottomButton(name: String, imagename: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(name, for: .normal)
        button.titleLabel?.font = boldSystemFont(ofSize: 14)
        button.setTitleColor(.hex("#141416").withAlphaComponent(0.6), for: .normal)
        button.setImage(UIImage(named: imagename), for: .normal)
        
        // 按钮点击事件
        button.addTarget(self, action: #selector(bottomButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func bottomButtonTapped(_ sender: UIButton) {
        // 取消其他按钮选中状态
        let titleStr = sender.title(for: .normal) ?? ""
        if titleStr == buttonNames[0] {
            let imageview = scrollView.viewWithTag(tag: (10000 + page)) as! UIImageView
            if let imageRotation = imageview.image?.rotate(.right) {
                imageview.image = imageRotation
                images[page] = imageRotation

            }
        }else if titleStr == buttonNames[1] {
            let vc = JNImagesCropVC()
            vc.editImage = images[page]
            vc.doneblock = { [self] editimage in
                let imageview = scrollView.viewWithTag(tag: (10000 + page)) as! UIImageView
                imageview.image = editimage
                images[page] = editimage
            }
            pushViewCon(vc)
        }else if titleStr == buttonNames[2] {
            
        }else if titleStr == buttonNames[3] {
            
        }else if titleStr == buttonNames[4] {
            
        }
        
        
        // 打印选中按钮的 title
        print("\(sender.title(for: .normal) ?? "") 按钮点击")
    }
    
    func dropAction(){
        
    }
    
    
    
}
extension JNImagesEditVC : UIScrollViewDelegate{
    // 监听分页滑动事件
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        page = pageIndex
//        print("当前页: \(pageIndex + 1)/\(images.count)")
        pageLabel.text = "\(pageIndex + 1)/\(images.count)"
    }
}
