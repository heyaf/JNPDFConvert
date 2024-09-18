//
//  AllToolsVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import UIKit

class AllToolsVC: BaseViewController {
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
        isHideCustomNav = true
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
    @objc func event() {
        
        
        
        
    }
    @objc func searchAction(){
        
    }
    @objc func settingAction(){
        
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
    
    // MARK: - Section Header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            header.titleLabel.text = sections[indexPath.section].0
            return header
        }
        return UICollectionReusableView()
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
