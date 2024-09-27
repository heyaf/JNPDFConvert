//
//  JNImageSignVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/27.
//

import UIKit

class JNImageSignVC: UIViewController {
    
    
    var selectindex = 10000
    var editImage:UIImage!
    var doneblock :((UIImage) -> ())?
    var cancleblock :(() -> ())?
    let buttonStack = UIView()
    let imageView = UIImageView()
    var imageViewB: UIImageView!
    var imageViewA:UIImageView!
    var buttonArr : [UIButton] = []
    var markView : UIImageView!
    var isDraggingMarkView = false
    var borderView : UIView!
    var warterMarkView: ImageWaterMarkView!
    let Mainheight = kScreenHeight - kNavBarHeight - kBottomSafeHeight - 88 - 135

    var signImages : [UIImage?] = []
    lazy var edittitleLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 80, y: kScreenHeight - kBottomSafeHeight - 70 + 20, width: kScreenWidth - 160, height: 20)
        label.textColor = BlackColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.backgroundColor = .white
        label.text = "Sign"
        return label
    }()
    private var collectionView: UICollectionView?
    override func viewDidLoad() {
        
//        signImages.append(contentsOf: [UIImage(named: "IMG_0719"),UIImage(named: "IMG_0719"),UIImage(named: "IMG_0719")])
        super.viewDidLoad()
        view.backgroundColor = grayColor
        setupBottomButtons()
        setupCollectionView()
    }
    
    func setupBottomButtons() {
        
        
        buttonStack.backgroundColor = .white
        //        buttonStack.roundCorners(view: buttonStack, corners: [.topLeft,.topRight], radius: 14)
        view.addSubview(buttonStack)
        view.addSubview(edittitleLabel)
        
        
        let bHeight = 70 + kBottomSafeHeight
        buttonStack.frame = CGRect(x: 0, y: kScreenHeight - bHeight, width: kScreenWidth, height: bHeight)
        
        
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
        
        imageView.image = editImage
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        //        imageView.backgroundColor = .red
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight + 8)
            make.left.equalTo(view).offset(8)
            make.right.equalTo(view).offset(-8)
            make.bottom.equalToSuperview().inset(kBottomSafeHeight + 80 + 135)
        }
        let imageH = kScreenHeight - kNavBarHeight - kBottomSafeHeight - 80 - 135 - 8
        markView = UIImageView(frame: CGRect(x: 0, y: 0, width: 195, height: 195))
        markView.center = CGPoint(x: kScreenWidth / 2 - 8, y: imageH / 2)
        markView.isUserInteractionEnabled = true
    
        markView.isHidden = true
        
        imageView.addSubview(markView)
        let markpanGesture = UIPanGestureRecognizer(target: self, action: #selector(markPanMethod(_:)))
        markView.addGestureRecognizer(markpanGesture)
        
        // 添加图片A到左上角
        imageViewA = UIImageView(image: UIImage(named: "edit_sign_delete"))
        imageViewA.frame = CGRect(x: -15, y: -15, width: 40, height: 40) // 设置图片A的大小
        imageViewA.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapA))
        imageViewA.addGestureRecognizer(tapGesture)
        markView.addSubview(imageViewA)
        
        // 添加图片B到右下角
        imageViewB = UIImageView(image: UIImage(named: "edit_sign_tuo"))
        imageViewB.frame = CGRect(x: markView.frame.width - 25, y: markView.frame.height - 25, width: 40, height: 40) // 设置图片B的大小
        imageViewB.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanB))
        imageViewB.addGestureRecognizer(panGesture)
        markView.addSubview(imageViewB)
        
        borderView = UIView()
        borderView.backgroundColor = .clear
        borderView.isUserInteractionEnabled = false
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = MainColor.cgColor
        markView.addSubview(borderView)
        markView.sendSubviewToBack(borderView)
        borderView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(-1)
            make.bottom.right.equalToSuperview().offset(1)
        }
        
        
        let imageV = UIFastCreatTool.createImageView("shadow")
        view.addSubview(imageV)
        imageV.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(0)
            make.bottom.equalTo(buttonStack.snp.top)
            make.height.equalTo(36) // 图标 + 文字
        }
        
        
    }

    func setupCollectionView(){
        
        let addBtn = UIButton()
        view.addSubview(addBtn)
        addBtn.frame = CGRect(x: 14, y: kScreenHeight - kBottomSafeHeight - 80 - 80, width: 60, height: 60)
        addBtn.setImage(UIImage(named: "btn_add_sign"), for: .normal)
        addBtn.backgroundColor = .hex("#F3F3F3")
        addBtn.layer.cornerRadius = 14
        addBtn.layer.borderWidth = 1
        addBtn.layer.borderColor = UIColor.hex("#AAB1BC").cgColor
        addBtn.addClickAction(action: addSignTapA)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(signCollectionViewCell.self, forCellWithReuseIdentifier: signCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = grayColor
        view.addSubview(collectionView!)
        collectionView?.frame = CGRect(x: 85, y: kScreenHeight - kBottomSafeHeight - 80 - 80, width: kScreenWidth - 100, height: 60)
        collectionView?.showsHorizontalScrollIndicator = false
        view.sendSubviewToBack(collectionView!)
    }
   
    
    @objc func cancleButtonTapped() {
        print("Done 按钮点击")
        dismiss(animated: false)
        cancleblock?()
    }
    @objc func doneButtonTapped() {
        print("Done 按钮点击")
        dismiss(animated: false)
        doneblock?(self.imageView.image!)
        imageViewB.isHidden = true
        imageViewA.isHidden = true
        borderView.isHidden = true
        doneblock?(imageView.asImage(bounces: CGRect(x: 0, y: 0, width: kScreenWidth-16, height: Mainheight)))
    }
    @objc func addSignTapA(button : UIButton) {
        let vc = JNImageNewSignVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
        vc.doneblock = {[self] image in
            signImages.append(image)
            collectionView?.reloadData()
        }
    }
    // 处理图片A的点击事件
    @objc func handleTapA() {
        print("Image A clicked!")
        markView.isHidden = true
        selectindex = 10000
        collectionView?.reloadData()
    }
    
    // 处理图片B的拖动事件
    @objc func handlePanB(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: imageView)
        let translation = gesture.location(in: imageView)
        
//        print("----\(translation),,,,\(point)")
        
        // 获取拖动时新视图的宽高
        let newWidth =  translation.x - markView.x
        let newHeight =  translation.y - markView.y
        if newWidth > 20 , newHeight > 20{
            // 设置最小宽高，防止缩小到过小
  
            
            // 更新当前view的frame大小
            markView.frame = CGRect(x: self.markView.frame.origin.x , y: self.markView.frame.origin.y, width: newWidth, height: newHeight)
            
            // 更新图片B的位置到右下角
            imageViewB.frame.origin = CGPoint(x: markView.width - 25, y: markView.height - 25)
        }
        
   
        
        // 重置手势的 translation
        gesture.setTranslation(.zero, in: self.markView)
    }
    @objc func markPanMethod(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: imageView)

        switch gesture.state {
        case .began:
            isDraggingMarkView = isDraggingWaterMark(point: point)
        case .changed:
            guard isDraggingMarkView else { return }
            
            markView.center = point
            
            // 限制拖动范围，使水印不超出 imageView 边界
            if markView.frame.minX <= 0 {
                markView.frame.origin.x = 0
            }
            if markView.frame.maxX >= imageView.frame.width {
                markView.frame.origin.x = imageView.frame.width - markView.frame.width
            }
            if markView.frame.minY <= 0 {
                markView.frame.origin.y = 0
            }
            if markView.frame.maxY >= imageView.frame.height {
                markView.frame.origin.y = imageView.frame.height - markView.frame.height
            }
            
        case .ended:
            isDraggingMarkView = false
        default:
            break
        }
    }

    // 判断手指是否在拖拽水印图片
    func isDraggingWaterMark(point: CGPoint) -> Bool {
        let checkRect = CGRect(x: point.x, y: point.y, width: 1, height: 1)
        return markView.frame.intersects(checkRect)
    }
}
extension JNImageSignVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return signImages.count // Number of items
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: signCollectionViewCell.identifier, for: indexPath) as? signCollectionViewCell else {
                fatalError("Unable to dequeue CustomCollectionViewCell")
            }
            // Configure the cell
            if indexPath.row < signImages.count {
                let image = signImages[indexPath.row]!
                // 使用 image 变量
                cell.configure(with: image)
            }
            cell.setSelectAction(isselect: indexPath.row == selectindex)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectindex = indexPath.row
            if indexPath.row < signImages.count {
                let image = signImages[indexPath.row]!
                markView.isHidden = false
                markView.image = image
                let imageH = kScreenHeight - kNavBarHeight - kBottomSafeHeight - 80 - 135 - 8
                markView.frame.size = CGSize(width: 195, height: 195)
                markView.center = CGPoint(x: kScreenWidth / 2 - 8, y: imageH / 2)
                // 更新图片B的位置到右下角
                imageViewB.frame.origin = CGPoint(x: markView.width - 25, y: markView.height - 25)
            }
            collectionView.reloadData()
        }
}

class signCollectionViewCell: UICollectionViewCell {
    static let identifier = "signCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
  
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public func configure(with image: UIImage) {
        imageView.image = image
        
    }
    func setSelectAction(isselect : Bool){
        imageView.layer.borderWidth = isselect ? 2 : 1
        imageView.layer.borderColor = isselect ? UIColor.red.cgColor : UIColor.hex("#F3F3F3").cgColor
    }
    
}
