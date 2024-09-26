//
//  JNImageFilterVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/26.
//

import UIKit

class JNImageFilterVC: UIViewController {
    var selectindex = 0
    var editImages : [UIImage] = []
    var doneblock :((UIImage) -> ())?
    var cancleblock :(() -> ())?
    let buttonStack = UIView()
    let imageNames = ["Original","Auto","Black & White","Color","Clear","GrayScale"]
    let imageView = UIImageView()
    lazy var edittitleLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 80, y: kScreenHeight - kBottomSafeHeight - 70 + 20, width: kScreenWidth - 160, height: 20)
        label.textColor = BlackColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.backgroundColor = .white
        label.text = "Filter"
        return label
    }()
    private var collectionView: UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = grayColor
        setupBottomButtons()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 110)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(filterCollectionViewCell.self, forCellWithReuseIdentifier: filterCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = grayColor
        view.addSubview(collectionView!)
        collectionView?.frame = CGRect(x: 8, y: kScreenHeight - kBottomSafeHeight - 80 - 120, width: kScreenWidth - 8, height: 110)
        collectionView?.showsHorizontalScrollIndicator = false
        view.sendSubviewToBack(collectionView!)
    }
    
    func setupBottomButtons() {
        
        
        buttonStack.backgroundColor = .white
//        buttonStack.roundCorners(view: buttonStack, corners: [.topLeft,.topRight], radius: 14)
        view.addSubview(buttonStack)
        view.addSubview(edittitleLabel)
        

        let bHeight = 70 + kBottomSafeHeight
        buttonStack.frame = CGRect(x: 0, y: kScreenHeight - bHeight, width: kScreenWidth, height: bHeight)
        let imageV = UIFastCreatTool.createImageView("shadow")
        view.addSubview(imageV)
        imageV.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(0)
            make.bottom.equalTo(buttonStack.snp.top)
            make.height.equalTo(36) // 图标 + 文字
        }
        
        let cancleBtn = UIButton()
        cancleBtn.imageView?.contentMode = .center
        cancleBtn.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)
        cancleBtn.setImage(UIImage(named: "filter_close"), for: .normal)
        cancleBtn.backgroundColor = .white
        view.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(buttonStack.snp.top).offset(20)
            make.size.equalTo(28) // 图标 + 文字
        }
        
        let doneBtn = UIButton()
        doneBtn.imageView?.contentMode = .center
        doneBtn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneBtn.setImage(UIImage(named: "filter_done"), for: .normal)
        doneBtn.backgroundColor = .white
        view.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(buttonStack.snp.top).offset(20)
            make.size.equalTo(28) // 图标 + 文字
        }
        
        imageView.image = editImages.first
        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .red
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight + 8)
            make.left.equalTo(view).offset(8)
            make.right.equalTo(view).offset(-8)
            make.bottom.equalToSuperview().inset(kBottomSafeHeight + 80 + 135)
        }
        
    }
    @objc func cancleButtonTapped() {
        print("Done 按钮点击")
        dismiss(animated: false)
        cancleblock?()
    }
    @objc func doneButtonTapped() {
        print("Done 按钮点击")
        dismiss(animated: false)
        doneblock?(editImages[selectindex])
    }

}
extension JNImageFilterVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editImages.count // Number of items
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCollectionViewCell.identifier, for: indexPath) as? filterCollectionViewCell else {
                fatalError("Unable to dequeue CustomCollectionViewCell")
            }
            // Configure the cell
            if indexPath.row < editImages.count {
                let image = editImages[indexPath.row]
                // 使用 image 变量
                cell.configure(with: image, title: imageNames[indexPath.row])
            }
            cell.setSelectAction(isselect: indexPath.row == selectindex)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectindex = indexPath.row
            imageView.image = editImages[selectindex]
            collectionView.reloadData()
        }
}

class filterCollectionViewCell: UICollectionViewCell {
    static let identifier = "filterCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .hex("#141416").withAlphaComponent(0.6)
        return label
    }()
    
    private let checkmarkIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "filter_choosed"))
        icon.isHidden = false // Hidden by default
//        icon.tintColor = .red
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkIcon)
        contentView.layer.borderWidth = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height - 32)
        titleLabel.frame = CGRect(x: 0, y: contentView.frame.size.height - 27, width: contentView.frame.size.width - 0, height: 30)
        checkmarkIcon.frame = CGRect(x: contentView.frame.size.width - 24, y: -2, width: 24, height: 18)
    }
    
    public func configure(with image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
    func setSelectAction(isselect : Bool){
        imageView.layer.borderWidth = isselect ? 2 : 0
        imageView.layer.borderColor = isselect ? UIColor.red.cgColor : UIColor.clear.cgColor
        checkmarkIcon.isHidden = !isselect
    }
    
}
