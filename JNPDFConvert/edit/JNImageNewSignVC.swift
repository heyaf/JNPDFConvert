//
//  JNImageNewSignVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/27.
//

import UIKit

class JNImageNewSignVC: UIViewController {
    
    
    var selectindex = 0
    var editImage:UIImage!
    var doneblock :((UIImage) -> ())?
    var cancleblock :(() -> ())?
    let buttonStack = UIView()
    let imageView = UIImageView()
    var sighHereImageV = UIImageView(image: UIImage(named: "sign_here"))
    var buttonArr : [UIButton] = []
    let Drawingheight = kScreenHeight - kNavBarHeight - kBottomSafeHeight - 88 - 135
    private let drawingBoard = JNDrawingBoardView()
    private let clearButton = UIButton()
    private let undoButton = UIButton()
    private let redoButton = UIButton()
    private var collectionView: UICollectionView?
    private var colorButtons: [UIButton] = []
    private let colors: [UIColor] = [.black, .white, .red, .green, .blue, .magenta, .hex("#6CDDF0"),.hex("#F5CA46")
                                     ,.hex("#615C5A")
                                     ,.hex("#97DC9B")
                                     ,.hex("#11F3C6")
                                     ,.hex("#BD1EEE")
                                     ,.hex("#87E4AE")
                                     ,.hex("#DB8ACE")
                                     ,.hex("#D1BB93")
                                     ,.hex("#D1BB93")]
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = grayColor
        setupBottomButtons()
        setupUI()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        // Drawing Board
        view.addSubview(drawingBoard)
        drawingBoard.backgroundColor = .white
        drawingBoard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavBarHeight + 8)
            make.left.equalTo(view).offset(8)
            make.right.equalTo(view).offset(-8)
            make.bottom.equalToSuperview().inset(kBottomSafeHeight + 80 + 135)
        }
        
        // Clear Button
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.layer.cornerRadius = 10
        clearButton.layer.masksToBounds = true
        clearButton.backgroundColor = .hex("#090909").withAlphaComponent(0.3)
        clearButton.titleLabel?.font = middleFont(ofSize: 16)
        clearButton.isHidden = true
        view.addSubview(clearButton)
        clearButton.snp.makeConstraints { make in
            make.top.equalTo(drawingBoard.snp.top).offset(-20)
            make.right.equalTo(drawingBoard.snp.right).offset(-3)
            make.size.equalTo(CGSize(width: 64, height: 30))
        }
        
        drawingBoard.addSubview(sighHereImageV)
        sighHereImageV.frame = CGRect(x: 0, y: 0, width: 174, height: 71)
        sighHereImageV.center = CGPoint(x: kScreenWidth/2 - 8, y: Drawingheight/2)
        
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 33, height: 33)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(signNewCollectionViewCell.self, forCellWithReuseIdentifier: signNewCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = .white
        view.addSubview(collectionView!)
        
        collectionView?.showsHorizontalScrollIndicator = false
        view.sendSubviewToBack(collectionView!)
        
        // Color Scroll View
        collectionView?.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStack.snp.top).offset(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        // Undo Button
        undoButton.setImage(UIImage(named: "sign_left_sec"), for: .normal)
        undoButton.setImage(UIImage(named: "sign_left_nor"), for: .disabled)
        undoButton.setTitleColor(.lightGray, for: .disabled)
        undoButton.isEnabled = false
        view.addSubview(undoButton)
        undoButton.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView!.snp.top).offset(0)
            make.centerX.equalTo(view.snp.centerX).offset(-30)
            make.size.equalTo(28)
        }
        
        // Redo Button
        
        redoButton.setImage(UIImage(named: "sign_right_sec"), for: .normal)
        redoButton.setImage(UIImage(named: "sign_right_nor"), for: .disabled)
        redoButton.isEnabled = false
        view.addSubview(redoButton)
        redoButton.snp.makeConstraints { make in
            make.centerY.equalTo(undoButton)
            make.centerX.equalTo(view.snp.centerX).offset(30)
            make.size.equalTo(28)
            
        }
        let layerView = UIView()
        layerView.backgroundColor = .white
        layerView.layer.cornerRadius = 15
        layerView.layer.masksToBounds = true
        view.addSubview(layerView)
        layerView.frame = CGRect(x: 0, y: kScreenHeight - kBottomSafeHeight - 70 - 60 - 56, width: kScreenWidth, height: 56)
        view.sendSubviewToBack(layerView)
        
        let imageV = UIFastCreatTool.createImageView("shadow")
        view.addSubview(imageV)
        imageV.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(0)
            make.bottom.equalTo(layerView.snp.top)
            make.height.equalTo(36) // 图标 + 文字
        }
    }
    
    
    
    // MARK: - Actions Setup
    private func setupActions() {
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(undoTapped), for: .touchUpInside)
        redoButton.addTarget(self, action: #selector(redoTapped), for: .touchUpInside)
        
        drawingBoard.undoAction = { [weak self] in
            self?.updateUndoRedoButtons()
        }
        
        drawingBoard.redoAction = { [weak self] in
            self?.updateUndoRedoButtons()
            self?.clearButton.isHidden = false
            self?.sighHereImageV.isHidden = true
        }
    }
    
    @objc private func clearTapped() {
        drawingBoard.drawingClean()
        updateUndoRedoButtons()
    }
    
    @objc private func undoTapped() {
        drawingBoard.drawingUndo()
        updateUndoRedoButtons()
    }
    
    @objc private func redoTapped() {
        drawingBoard.drawingRedo()
        updateUndoRedoButtons()
    }
    
    
    // MARK: - Helpers
    private func updateUndoRedoButtons() {
        undoButton.isEnabled = drawingBoard.canUndo
        redoButton.isEnabled = drawingBoard.canRedo
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
        
        
        imageView.backgroundColor = .white
        //        view.addSubview(imageView)
        //        imageView.snp.makeConstraints { make in
        //            make.top.equalToSuperview().offset(kNavBarHeight + 8)
        //            make.left.equalTo(view).offset(8)
        //            make.right.equalTo(view).offset(-8)
        //            make.bottom.equalToSuperview().inset(kBottomSafeHeight + 80 + 135)
        //        }
        
    }
    
    
    @objc func cancleButtonTapped() {
        print("Done 按钮点击")
        dismiss(animated: false)
        cancleblock?()
    }
    @objc func doneButtonTapped() {
        print("Done 按钮点击")
        dismiss(animated: false)
        drawingBoard.backgroundColor = .clear
        doneblock?(drawingBoard.asImage(bounces: CGRect(x: 0, y: 0, width: kScreenWidth-16, height: Drawingheight)))
    }
    
}
extension JNImageNewSignVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count // Number of items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: signNewCollectionViewCell.identifier, for: indexPath) as? signNewCollectionViewCell else {
            fatalError("Unable to dequeue CustomCollectionViewCell")
        }
        // Configure the cell
        if indexPath.row < colors.count {
            let color = colors[indexPath.row]
            // 使用 image 变量
            cell.imageView.backgroundColor = color
        }
        cell.setSelectAction(isselect: indexPath.row == selectindex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectindex = indexPath.row
        scrollToCenter(at: indexPath)
        
        if indexPath.row < colors.count {
            let selectedColor = colors[indexPath.row]
            drawingBoard.changeAllPathsColor(to: selectedColor)
            // 更新涂鸦颜色
            drawingBoard.lineColor = selectedColor
        }
        collectionView.reloadData()
    }
    // MARK: - 滚动 Cell 到中间
    func scrollToCenter(at indexPath: IndexPath) {
        // 获取 Cell 的 Frame
        guard let cellFrame = collectionView?.layoutAttributesForItem(at: indexPath)?.frame else { return }
        
        // CollectionView 的中心点
        let collectionViewCenterX = kScreenWidth/2
        
        // Cell 的中心点
        let cellCenterX = cellFrame.origin.x + cellFrame.size.width / 2
        
        // 计算需要滑动的偏移量
        let offsetX = cellCenterX - collectionViewCenterX
        
        // 获取当前的 ContentOffset
        var contentOffset = collectionView?.contentOffset
        
        // 限制 ContentOffset 的范围，确保不超出 ContentSize
        contentOffset?.x += offsetX
        let maxContentOffsetX = collectionView!.contentSize.width - collectionView!.frame.size.width
        contentOffset!.x = max(0, min(contentOffset!.x, maxContentOffsetX))
        
        // 滑动到指定的偏移量
        collectionView!.setContentOffset(contentOffset ?? CGPoint(x: 0,y: 0), animated: true)
    }
}

class signNewCollectionViewCell: UICollectionViewCell {
    static let identifier = "signNewCollectionViewCell"
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15.5
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setSelectAction(isselect : Bool){
        imageView.layer.borderWidth = isselect ? 2 : 1
        imageView.layer.borderColor = isselect ? MainColor.cgColor : UIColor.hex("#D3D3D3").cgColor
    }
    
}
