//
//  JNSplashDetailViewController.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/10/9.
//

import UIKit
import Lottie

class JNSplashDetailViewController: UIViewController {
    var imageName: String?
    var animationName: String? // Lottie 动画文件名
    var titleText: String?
    var subtitleText: String?
    var pageIndex: Int = 0
    
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var imageView: UIImageView!
    private var animationView: LottieAnimationView!
    private var nextButton: UIButton! // 下一页按钮
    var nextBlock:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景图
        imageView = UIImageView(frame: self.view.bounds)
        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)
        }
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        
        // 设置背景图
        //            let imageViewb = UIImageView(image: UIImage(named: "jianbian"))
        //            imageViewb.frame = CGRect(x: 0, y: kScreenHeight - kScreenWidth + 30, width: kScreenWidth, height: kScreenHeight - 30)
        //            imageViewb.contentMode = .scaleAspectFill
        //            imageView.layer.masksToBounds = true
        //            self.view.addSubview(imageViewb)
        let frame =  CGRect(x: 0, y: kScreenHeight - kScreenWidth + 30, width: kScreenWidth, height: kScreenHeight - 30)
        let gradientView = UIView(frame: frame) // 设置视图的大小
        self.view.addSubview(gradientView)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0).cgColor,UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.red.cgColor] // 渐变颜色
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        // 设置 Lottie 动画
        if let animationName = animationName {
            animationView = LottieAnimationView(name: animationName)
            animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height:kWidthScale*520 )
            animationView.contentMode = .scaleAspectFill
            animationView.loopMode = .playOnce
            animationView.play()
            animationView.backgroundColor = .clear
            self.view.addSubview(animationView)
        }
        
        // 设置主标题
        titleLabel = UILabel(frame: CGRect(x: 20, y: kHeightScale*470 - 30, width: self.view.bounds.width - 40, height: 40))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.text = titleText
        titleLabel.textColor = .white
        titleLabel.alpha = 0
        titleLabel.numberOfLines = 2
        self.view.addSubview(titleLabel)
        if pageIndex == 0 {
            titleLabel.font = UIFont.boldSystemFont(ofSize: 37)
            titleLabel.height = 90
        }
        
        // 设置副标题
        subtitleLabel = UILabel(frame: CGRect(x: 20, y: titleLabel.bottom + 10, width: self.view.bounds.width - 40, height: 46))
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = middleFont(ofSize: 18)
        subtitleLabel.text = subtitleText
        subtitleLabel.alpha = 0
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textColor = .white
        self.view.addSubview(subtitleLabel)
        if pageIndex == 0 {
            // 创建并配置UILabel
            let label = UILabel()
            label.numberOfLines = 2 // 设置为多行
            label.backgroundColor = .clear // 背景透明
            label.isUserInteractionEnabled = true // 允许用户交互
            label.textAlignment = .center
            label.textColor = .white.withAlphaComponent(0.8)
            label.font = middleFont(ofSize: 13)
            // 设置富文本
            let fullText = "By tapping \"Continue\", you indicate that you have read our Privacy Policy."
            let attributedString = NSMutableAttributedString(string: fullText)
            
            // 定义需要下划线和点击的文本范围
            let privacyPolicyRange = (fullText as NSString).range(of: "Privacy Policy")
            
            // 添加下划线样式
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyPolicyRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.white.withAlphaComponent(0.8), range: privacyPolicyRange) // 设置文本颜色
            
            // 将富文本设置到UILabel
            label.attributedText = attributedString
            
            // 添加点击手势
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
            label.addGestureRecognizer(tapGesture)
            
            // 添加布局
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.frame = CGRectMake(20, kScreenHeight - kBottomSafeHeight - 50, kScreenWidth - 40, 50)
        }
        
        // 添加动画效果
        addAnimations()
        setupNextButton()
    }
    @objc func labelTapped(gesture: UITapGestureRecognizer) {
        openUrl("https://sites.google.com/view/imageconvert-ios/privacy-policy")
        }
    public func openUrl(_ urlStr: String) {
        guard let url = URL(string: urlStr) else {
            print("无法创建URL: \(urlStr)")
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                print("成功打开 \(urlStr)")
            } else {
                print("无法打开 URL: \(urlStr)。请确保应用已正确安装。")
            }
        }
    }
    // MARK: - 设置"下一页"按钮
    func setupNextButton() {
        nextButton = UIButton(type: .system)
        nextButton.frame = CGRect(x: 20, y: kScreenHeight - kBottomSafeHeight - 60 - 58, width: kScreenWidth - 40, height: 58)
        nextButton.setTitle("Continue", for: .normal)
        if pageIndex == 0 {
            nextButton.setTitle("Start", for: .normal)
        }
        nextButton.backgroundColor = MainColor
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 16
        nextButton.layer.masksToBounds = true
        nextButton.titleLabel?.font = boldSystemFont(ofSize: 18)
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        
        
        let imageV = UIImageView(image: UIImage(named: "ic_create"))
        imageV.frame = CGRect(x: kScreenWidth - 40 - 16 - 20, y: 19, width: 20, height: 20)
        nextButton.addSubview(imageV)
        self.view.addSubview(nextButton)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
        
        addAnimations()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.alpha = 0
        titleLabel.top = kHeightScale*470 - 30
        subtitleLabel.alpha = 0
        subtitleLabel.top = titleLabel.bottom + 10
    }
    
    // MARK: - 点击"下一页"按钮的响应方法
    @objc func nextButtonTapped(_ sender:UIButton) {
        // 判断是否是最后一页，如果是最后一页则不再执行切换
        sender.buttonaddAnimation()
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        AfterGCD(timeInval: 0.5) {
            self.nextBlock?()
        }
    }
    // 动画效果：标题延迟1秒下移，副标题随后下移
    public func addAnimations() {
        if pageIndex == 0 {
            // 第一页，主标题延迟1秒出现并下移10像素
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.titleLabel.alpha = 1.0
                    self.titleLabel.frame.origin.y += 10
                })
            }
        } else {
            // 其他页，主标题和副标题依次下移
            UIView.animate(withDuration: 0.5, animations: {
                self.titleLabel.alpha = 1.0
                self.titleLabel.frame.origin.y += 10
            }, completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    self.subtitleLabel.alpha = 1.0
                    self.subtitleLabel.frame.origin.y += 10
                }
            })
        }
    }
    func addBreathingEffect(to view: UIView) {
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [.autoreverse, .repeat, .allowUserInteraction],
                       animations: {
            view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           options: [.autoreverse, .repeat, .allowUserInteraction],
                           animations: {
                view.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }
    
}
class GradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        // 设置颜色从下到上的渐变，#030303颜色，透明度从 0.8 到 0
        gradientLayer.colors = [
            UIColor.hex("#030303").withAlphaComponent(0.0).cgColor,  // #030303 with 0.8 opacity
            UIColor.red.cgColor   // #030303 with 0 opacity
        ]
        
        // 设置渐变方向，从下到上
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.2)  // 底部中心
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)    // 顶部中心
        
        // 将渐变层添加到视图的层中
        self.layer.addSublayer(gradientLayer)
    }
    
    
}
