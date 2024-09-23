//
//  JNConversationVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/23.
//

import UIKit

class JNConversationVC: BaseViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var images: [UIImage] = [] // 用于存储图片
    var imageNames:[String] = []
    var isSettingsExpanded = false // 控制设置项展开或折叠
    let convertButton = UIButton()
    let settitleArr = ["Convert to","Quality","Margins","Name"]
    var quality = 90 //默认是90
    var margins = 2 //2=normal 0 = none 1 = narrow
    var pdfName = String().generateImageString(geshi: "PDF")
    override func viewDidLoad() {
        super.viewDidLoad()
        customNav.title = "New Conversion"
        view.backgroundColor = .white
        setupTableView()
        setupConvertButton()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(JNConverImageCell.self, forCellReuseIdentifier: "JNConverImageCell")
        tableView.register(JNSettingsCell.self, forCellReuseIdentifier: "JNSettingsCell")
        tableView.register(JNSettingsSliderCell.self, forCellReuseIdentifier: "JNSettingsSliderCell")
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight + 10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(80 + kBottomSafeHeight)
        }
    }
    
    func setupConvertButton() {
        convertButton.setTitle("Convert", for: .normal)
        convertButton.layer.cornerRadius = 10
        convertButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        convertButton.setTitleColor(.white, for: .normal)
        
        // 设置渐变背景色
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.hex("#F13236").cgColor, UIColor.hex("#D60005").cgColor] // 渐变颜色
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        convertButton.layer.insertSublayer(gradientLayer, at: 0)
        convertButton.layer.cornerRadius = 16
        convertButton.layer.masksToBounds = true
        view.addSubview(convertButton)
        convertButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(60)
        }
        
        convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
    }
    
    @objc func convertButtonTapped() {
        // 处理点击转换的逻辑
        print("Convert button tapped")
    }
    
    
}
extension JNConversationVC:UITableViewDelegate, UITableViewDataSource {
    // UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 图片列表部分和设置项部分
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return images.count + 1 // 图片项 + "Add More" 按钮
        } else {
            return settitleArr.count // 展开时有3项，折叠时只有1项
        }
    }
    // 自定义 header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView()
            let label = UILabel()
            label.text = "Settings"
            label.textColor = BlackColor
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            
            headerView.addSubview(label)
            
            // 使用 SnapKit 布局
            label.snp.makeConstraints { make in
                make.left.right.bottom.top.equalToSuperview()
            }
            
            return headerView
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 40, height: 28))
        headerView.backgroundColor = grayColor
        headerView.roundCorners(view: headerView, corners: [.topLeft,.topRight], radius: 14)
        return headerView // 第一组无标题
    }
    
    // 设置 header 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50 // 设置第二组标题的高度
        }
        return 14 // 第一组没有标题，高度为 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row < images.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JNConverImageCell", for: indexPath) as! JNConverImageCell
                cell.configure(image: images[indexPath.row],name: imageNames[indexPath.row])
                
                
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
                addImageButton.backgroundColor = grayColor
                // 居中显示
                cell.contentView.addSubview(addImageButton)
                addImageButton.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 40, height: 50)
                cell.contentView.backgroundColor = .white
                addImageButton.roundCorners(view:addImageButton,corners: [.bottomLeft, .bottomRight], radius: 14)
                return cell
            }
        } else {
            if indexPath.row == 1,isSettingsExpanded {
                let cell = tableView.dequeueReusableCell(withIdentifier: "JNSettingsSliderCell", for: indexPath) as! JNSettingsSliderCell
                cell.configure(number: quality)
                cell.valueChanged = { number in
                    self.quality = number
                }
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "JNSettingsCell", for: indexPath) as! JNSettingsCell
            var subtitle = ".pdf"
            var arrowname = "conversation_unright"
            let marginArr = ["None","Narrow","Normal"]
            if indexPath.row == 1 {
                subtitle = "\(quality)" + "%"
                arrowname = "conversation_down"
            }else if indexPath.row == 2 {
                subtitle = marginArr[margins]
                arrowname = "conversation_right"
            }else if indexPath.row == 3 {
                subtitle = pdfName
                arrowname = "conversation_right"
            }
            cell.configure(title: settitleArr[indexPath.row], subtitle: subtitle, arrowImage: UIImage(named: arrowname))
            cell.subtitleLabel.textColor = indexPath.row == 0 ? .gray : BlackColor
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == images.count {
                return 60
            }
            return 68
            
        }
        if indexPath.row == 1,isSettingsExpanded {return 117 + 16}
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == images.count {
            // 处理添加图片的逻辑
            print("Add more images tapped")
        } else if indexPath.section == 1 , indexPath.row == 1{
            isSettingsExpanded.toggle() // 点击展开或折叠设置项
            let indexPath = IndexPath(row: 1, section: 1)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else if indexPath.section == 1 , indexPath.row == 2{
            
        } else if indexPath.section == 1 , indexPath.row == 3{
            ChangeName()
        }
    }
    func ChangeName(){
        let popupView = JNUrlPopView(frame: self.view.bounds, title: "Name",placeholder: "Enter Name", confirmButtonText: "Confirm")
        popupView.textField.text = pdfName
        // 设置确定按钮的回调
        popupView.onConfirm = { inputText in
            self.pdfName = inputText ?? ""
            let indexPath = IndexPath(row: 3, section: 1)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        // 添加到视图中
        AppUtil.getWindow()?.rootViewController?.view.addSubview(popupView)
        
    }
}

// MARK: - Cell


class JNConverImageCell: UITableViewCell {
    
    // 图片和按钮
    let thumbnailImageView = UIImageView()
    let deleteButton = UIButton(type: .custom)
    let rightImageView = UIImageView()
    let titleL = UILabel().then { make in
        make.textColor = .black
        make.font = .boldSystemFont(ofSize: 16)
    }
    let lineV = UIFastCreatTool.getLine(.hex("#F3F3F3"))
    
    
    // 初始化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化子视图
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 6
        
        deleteButton.setBackgroundImage(UIImage(named: "conversation_reduce"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        rightImageView.image = UIImage(named: "conversation_right")
        // 添加到 contentView
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(rightImageView)
        contentView.backgroundColor = grayColor // 设置背景颜色
        contentView.addSubview(titleL)
        contentView.addSubview(lineV)
        // 约束
        setupConstraints()
        
        
    }
    
    // 布局约束
    private func setupConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.width.equalTo(42)
            make.height.equalTo(50)
            
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(24)
        }
        rightImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }
        titleL.snp.makeConstraints { make in
            make.left.equalTo(thumbnailImageView.snp.right).offset(18)
            make.right.equalTo(rightImageView.snp.left).offset(18)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        lineV.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(titleL)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    // 处理删除按钮点击事件
    @objc func deleteTapped() {
        // 删除逻辑
    }
    
    // 设置图片和删除操作
    func configure(image: UIImage,name:String) {
        thumbnailImageView.image = image
        titleL.text = name
    }
    
    // 必须的 init 解析器
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JNSettingsCell: UITableViewCell {
    // MARK: - UI Components
    
    // 背景视图
    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = grayColor
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    // 标题标签
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = BlackColor
        return label
    }()
    
    // 副标题标签
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = BlackColor
        label.textAlignment = .right
        return label
    }()
    
    // 箭头图标
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "conversation_right") // 默认箭头图标
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 禁用默认的选中背景颜色
        selectionStyle = .none
        
        // 添加背景容器视图
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        // 添加 UI 元素
        backgroundContainerView.addSubview(titleLabel)
        backgroundContainerView.addSubview(subtitleLabel)
        backgroundContainerView.addSubview(arrowImageView)
        
        // 布局约束
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupConstraints() {
        // 标题标签布局
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        // 箭头图标布局
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18) // 固定大小
        }
        
        // 副标题布局
        subtitleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
        }
    }
    
    // MARK: - Configuration
    
    // 配置方法，允许外部设置标题、副标题、箭头图标
    func configure(title: String, subtitle: String, arrowImage: UIImage? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        if let image = arrowImage {
            arrowImageView.image = image
        }
    }
}

class JNSettingsSliderCell: UITableViewCell {
    // MARK: - UI Components
    
    // 背景视图
    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = grayColor
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    // 标题标签
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = BlackColor
        return label
    }()
    
    // 副标题标签
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = BlackColor
        label.textAlignment = .center
        return label
    }()
    
    // 箭头图标
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "conversation_right") // 默认箭头图标
        return imageView
    }()
    let customSlider = JNConversationSliderView()
    // MARK: - Initialization
    var valueChanged: ((Int) -> Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 禁用默认的选中背景颜色
        selectionStyle = .none
        
        // 添加背景容器视图
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(117)
        }
        
        // 添加 UI 元素
        backgroundContainerView.addSubview(titleLabel)
        backgroundContainerView.addSubview(subtitleLabel)
        backgroundContainerView.addSubview(arrowImageView)
        backgroundContainerView.addSubview(customSlider)
        titleLabel.text = "Quality"
        arrowImageView.image = UIImage(named: "conversation_up")
        subtitleLabel.text = "90%"
        customSlider.configure(minimumValue: 0, maximumValue: 100, initialValue: 90, thumbImage: UIImage(named: "conversation_slider"))
        // 布局约束
        setupConstraints()
        customSlider.valueChanged = { value in
            let intValue = Int(value)
            self.valueChanged?(intValue)
            self.subtitleLabel.text = String(intValue) + "%"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupConstraints() {
        // 标题标签布局
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(19)
        }
        
        // 箭头图标布局
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(18) // 固定大小
        }
        
        // 副标题布局
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(17)
        }
        customSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(66)
            make.height.equalTo(34)
        }
    }
    
    // MARK: - Configuration
    
    // 配置方法，允许外部设置标题、副标题、箭头图标
    func configure(number : Int) {
        customSlider.setSliderValue(Float(number))
        subtitleLabel.text = String(number) + "%"
    }
}
