//
//  WRCustomNavigationBar.swift
//  WRNavigationBar_swift
//
//  Created by itwangrui on 2017/11/25.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit

fileprivate let WRDefaultTitleSize:CGFloat = 18
fileprivate let WRDefaultTitleColor = UIColor.white
fileprivate let WRDefaultBackgroundColor = UIColor.hexString("#1D152F") //UIColor.white
fileprivate let WRScreenWidth = UIScreen.main.bounds.size.width
///是否留海屏
public  var kIsIphoneXSeries : Bool {
    return statusBarHeight > 20
}
/// 是否iPad
public  let kIsiPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
////////////////////////////////////////////////////////////////////////////////////////////////////////////
open class WRCustomNavigationBar: UIView
{
    public var onClickLeftButton:(()->())?
    public var onClickRightButton:(()->())?
    public var title:String? {
        willSet {
            titleLabel.isHidden = false
            titleLabel.text = newValue
        }
    }
    public var attributedText:NSAttributedString? {
        willSet {
            titleLabel.isHidden = false
            titleLabel.attributedText = newValue
        }
    }
    public var titleLabelColor:UIColor? {
        willSet {
            titleLabel.textColor = newValue
        }
    }
    public var titleLabelFont:UIFont? {
        willSet {
            titleLabel.font = newValue
        }
    }
    public var barBackgroundColor:UIColor? {
        willSet {
            backgroundImageView.isHidden = true
            backgroundView.isHidden = false
            backgroundView.backgroundColor = newValue
        }
    }
    public var barBackgroundImage:UIImage? {
        willSet {
            backgroundView.isHidden = true
            backgroundImageView.isHidden = false
            backgroundImageView.image = newValue
        }
    }
    
    // fileprivate UI variable
    open lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = WRDefaultTitleColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.isHidden = true
        return label
    }()
    
    open lazy var leftButton:UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
        
    open lazy var rightButton:UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(clickRight), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    fileprivate lazy var bottomLine:UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.isHidden = true
        return view
    }()
    
    fileprivate lazy var backgroundView:UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var backgroundImageView:UIImageView = {
        let imgView = UIImageView()
        imgView.isHidden = true
        return imgView
    }()
    
    // fileprivate other variable
    fileprivate static var isIphoneXSeries:Bool {
        get {
            return kIsIphoneXSeries && kIsiPad == false
        }
    }
    fileprivate static var navBarBottom:Int {
        get {
            return isIphoneXSeries ? 88 : 64
        }
    }
    
    // init
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: WRScreenWidth, height: CGFloat(kScreenWidth)))
        setupView()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView()
    {
        addSubview(backgroundView)
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(bottomLine)
        updateFrame()
        backgroundColor = UIColor.clear
        backgroundView.backgroundColor = WRDefaultBackgroundColor

    }
    func updateFrame()
    { 
        let top:CGFloat = statusBarHeight
        let margin:CGFloat = 10
        let buttonHeight:CGFloat = 44
        let buttonWidth:CGFloat = 80
        let titleLabelHeight:CGFloat = 44
        let titleLabelWidth:CGFloat = kScreenWidth - 100//kScreenWidth*0.5
        
        backgroundView.frame = self.bounds
        backgroundImageView.frame = self.bounds
        leftButton.frame = CGRect(x: margin, y: top, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: kScreenWidth-buttonWidth-margin, y: top, width: buttonWidth, height: buttonHeight)
        titleLabel.frame = CGRect(x: (kScreenWidth-titleLabelWidth)/2.0, y: top, width: titleLabelWidth, height: titleLabelHeight)
        bottomLine.frame = CGRect(x: 0, y: kNavBarHeight-0.5, width: kScreenWidth, height: 0.5)
        
        leftButton.contentHorizontalAlignment = .left
        leftButton.titleEdgeInsets = UIEdgeInsets.zero
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

        
        rightButton.contentHorizontalAlignment = .right
        rightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        rightButton.titleLabel?.minimumScaleFactor = 0.5
        rightButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(titleLabelWidth)
            make.height.equalTo(titleLabelHeight)
        }
        self.leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin)
            make.bottom.equalTo(self.titleLabel)
            make.height.equalTo(buttonHeight)
            make.right.equalTo(titleLabel.snp.left).offset(-margin)
//            make.width.equalTo(buttonWidth)
        }
        self.rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-margin)
            make.size.bottom.equalTo(self.leftButton)
        }
    }
}


extension WRCustomNavigationBar
{
    public func wr_setBottomLineHidden(hidden:Bool) {
        bottomLine.isHidden = hidden
    }
    public func wr_setBackgroundAlpha(alpha:CGFloat) {
        backgroundView.alpha = alpha
        backgroundImageView.alpha = alpha
        bottomLine.alpha = alpha
    }
    public func wr_setTintColor(color:UIColor) {
        leftButton.setTitleColor(color, for: .normal)
        rightButton.setTitleColor(color, for: .normal)
        titleLabel.textColor = color
    }
    
    // 左右按钮共有方法
    public func wr_setLeftButton(normal:UIImage, highlighted:UIImage) {
        wr_setLeftButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }
    public func wr_setLeftButton(image:UIImage) {
        wr_setLeftButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }
    public func wr_setLeftButton(title:String, titleColor:UIColor) {
        wr_setLeftButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    public func wr_setRightButton(normal:UIImage, highlighted:UIImage) {
        wr_setRightButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }
    public func wr_setRightButton(image:UIImage) {
        wr_setRightButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }
    public func wr_setRightButton(title:String, titleColor:UIColor) {
        wr_setRightButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    
    // 左右按钮私有方法
    private func wr_setLeftButton(normal:UIImage?, highlighted:UIImage?, title:String?, titleColor:UIColor?) {
        leftButton.isHidden = false
        leftButton.setImage(normal, for: .normal)
        leftButton.setImage(highlighted, for: .highlighted)
        leftButton.setTitle(title, for: .normal)
        leftButton.setTitleColor(titleColor, for: .normal)
    }
    private func wr_setRightButton(normal:UIImage?, highlighted:UIImage?, title:String?, titleColor:UIColor?) {
        rightButton.isHidden = false
        rightButton.setImage(normal, for: .normal)
        rightButton.setImage(highlighted, for: .highlighted)
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(titleColor, for: .normal)
    }
}


// MARK: - 导航栏左右按钮事件
extension WRCustomNavigationBar
{
    @objc func clickBack() {
        if let onClickBack = onClickLeftButton {
            onClickBack()
        } else {
            AppUtil.getTopVC()?.popViewCon()
        }
    }
    @objc func clickRight() {
        if let onClickRight = onClickRightButton {
            onClickRight()
        }
    }
}
























