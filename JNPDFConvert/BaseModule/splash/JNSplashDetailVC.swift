//
//  JNSplashDetailVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/10/9.
//

import UIKit
import Lottie

class JNSplashDetailVC: UIViewController {
//    public var imageName: String
//    public var titleStr: String
//    public var desStr: String
//    public let button: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Continue ", for: .normal)
//        button.titleLabel?.font = UIFont(name: "Nunito-Bold", size:  20)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .hex("#5B78FF")
//        button.layer.cornerRadius = 12
//        return button
//    }()
//    private var animationView: LottieAnimationView!
//    private var titleLabel: UILabel!
//    private var subtitleLabel: UILabel!
//    private var imageView: UIImageView!
//    init(imageName: String,title:String,des:String) {
//        self.imageName = imageName
//        self.titleStr = title
//        self.desStr = des
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//    }
//
//    private func setupViews() {
//        view.backgroundColor = .black
//
//        // 设置背景图
//        imageView = UIImageView(frame: self.view.bounds)
//        if let imageName = imageName {
//            imageView.image = UIImage(named: imageName)
//        }
//        imageView.contentMode = .scaleAspectFill
//        self.view.addSubview(imageView)
//        
//        // 设置背景图
//        let imageViewb = UIImageView(image: UIImage(named: "jianbian"))
//        imageViewb.frame = CGRect(x: 0, y: kScreenHeight - kScreenWidth + 30, width: kScreenWidth, height: kScreenHeight - 30)
//        imageViewb.contentMode = .scaleAspectFill
//        self.view.addSubview(imageViewb)
//
//        // 设置 Lottie 动画
//        if let animationName = animationName {
//            animationView = LottieAnimationView(name: animationName)
//            animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height:kHeightScale*520 )
//            animationView.contentMode = .scaleAspectFit
//            animationView.loopMode = .playOnce
//            animationView.play()
//            self.view.addSubview(animationView)
//        }
//
//        // 设置主标题
//        titleLabel = UILabel(frame: CGRect(x: 20, y: kHeightScale*520 - 20, width: self.view.bounds.width - 40, height: 40))
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
//        titleLabel.text = titleText
//        titleLabel.textColor = .white
//        titleLabel.alpha = 0
//        titleLabel.numberOfLines = 2
//        self.view.addSubview(titleLabel)
//        if pageIndex == 0 {
//            titleLabel.font = UIFont.boldSystemFont(ofSize: 37)
//            titleLabel.height = 80
//        }
//
//        // 设置副标题
//        subtitleLabel = UILabel(frame: CGRect(x: 20, y: titleLabel.bottom + 12, width: self.view.bounds.width - 40, height: 46))
//        subtitleLabel.textAlignment = .center
//        subtitleLabel.font = middleFont(ofSize: 18)
//        subtitleLabel.text = subtitleText
//        subtitleLabel.alpha = 0
//        subtitleLabel.numberOfLines = 2
//        subtitleLabel.textColor = .white
//        self.view.addSubview(subtitleLabel)
//
//        // 添加动画效果
//        addAnimations()
//    }
}
