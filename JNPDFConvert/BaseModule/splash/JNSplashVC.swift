//
//  JNSplashVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/10/9.
//

import UIKit

//class JNSplashVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    private let imageNames = ["guider1", "guider2", "guider3","guider4"]
//    private let titleNames = ["Smart Auto Clicker".local,
//                              "Customize Your Multiclick".local,
//                              "Automatic Swipe & Click".local,
//                              "Access all features".local]
//    private let desNames = ["Easy to use, freeing your fingers for more efficient work and gaming.".local,
//                            "Multi-click function  help you complete complex tasks better.".local,
//                            "Use swipes and clicks at the same time, ensures a seamless experience.".local,
//                            "Unlock full access to all features.Free trial for X days, then $4.99/week.".local]
//    public var desL : UILabel!
//
//    private var pageControl = UIPageControl()
//
//    lazy var priView = UIView().then{view in
//        view.isHidden = true
//        
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        dataSource = self
//        delegate = self
//
//        setupPageControl()
//        setViewControllers([viewControllerForPage(0)], direction: .forward, animated: true, completion: nil)
//        creatBottomView()
//        view.addSubviews([priView])
//        priView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            make.width.equalTo(kScreenWidth - 58)
//            make.height.equalTo(16)
//        }
//    }
//    @objc func dismissAction(){
////        getWindow()!.rootViewController = XTKMainTabBarController.init();
////        requestAppReview()
//    }
//    private func setupPageControl() {
//        pageControl.numberOfPages = imageNames.count
//        pageControl.currentPage = 0
//        pageControl.pageIndicatorTintColor = .lightGray
//        pageControl.currentPageIndicatorTintColor = .white
//        pageControl.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(pageControl)
//        var pageH = statusBarHeight + 480
//        if UIScreen.main.bounds.height < 800 {
//            pageH = statusBarHeight + 400
//        }
//        pageControl.snp.makeConstraints { make in
//            make.left.equalToSuperview()
//            make.top.equalToSuperview().offset(pageH)
//        }
//    }
//
//    private func viewControllerForPage(_ index: Int) -> UIViewController {
//        let vc = JNSplashDetailVC(imageName: imageNames[index],title: titleNames[index],des: desNames[index])
//        vc.button.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
//        if index == 3 {
//            
//            
//
//        }
//        return vc
//    }
//
//    @objc private func handleNextButtonTapped(sender: UIButton) {
//        guard let currentViewController = viewControllers?.first,
//              let currentIndex = imageNames.firstIndex(of: (currentViewController as! JNSplashDetailVC).imageName) else {
//            return
//        }
//        
//        let nextIndex = currentIndex + 1
//        if nextIndex < imageNames.count {
//            let nextViewController = viewControllerForPage(nextIndex)
//            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
//            pageControl.currentPage = nextIndex
//            
//            
//        } else {
//            
//        }
//    }
//    func creatBottomView(){
//        let bClabel = UILabel()
//        // 设置带下划线的文本
//        let text = "pricacy policy".local
//        let underlineAttriString = NSMutableAttributedString(string: text)
//        underlineAttriString.addAttribute(
//            NSAttributedString.Key.underlineStyle,
//            value: NSUnderlineStyle.single.rawValue,
//            range: NSRange(location: 0, length: 0)
//        )
//        bClabel.attributedText = underlineAttriString
//        
//        // 添加点击手势
//        bClabel.isUserInteractionEnabled = true
//        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(bclabelTapped))
//        bClabel.addGestureRecognizer(labelTapGesture)
//        
//        bClabel.font = UIFont(name: "Nunito-Regular", size:  10)
//        bClabel.textColor = .white.withAlphaComponent(0.6)
//        bClabel.sizeToFit()
//        
//        let bClabel1 = UILabel()
//        // 设置带下划线的文本
//        let text1 = "Terms of Use".local
//        let underlineAttriString1 = NSMutableAttributedString(string: text1)
//        underlineAttriString1.addAttribute(
//            NSAttributedString.Key.underlineStyle,
//            value: NSUnderlineStyle.single.rawValue,
//            range: NSRange(location: 0, length: 0)
//        )
//        bClabel1.attributedText = underlineAttriString1
//        
//        // 添加点击手势
//        bClabel1.isUserInteractionEnabled = true
//        let labelTapGesture1 = UITapGestureRecognizer(target: self, action: #selector(bllabelTapped))
//        bClabel1.addGestureRecognizer(labelTapGesture1)
//        bClabel1.font = UIFont(name: "Nunito-Regular", size:  10)
//        bClabel1.textColor = .white.withAlphaComponent(0.6)
//        bClabel1.sizeToFit()
//        
//        priView.addSubview(bClabel)
//        priView.addSubview(bClabel1)
//        
//        let l = UILabel()
//        
//        l.backgroundColor = .hex("#FFFFFF",alpha: 0.6)
//        l.textAlignment = .center
//        priView.addSubview(l)
//        l.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().offset(-1)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(13)
//            make.width.equalTo(1)
//        }
//        bClabel.snp.makeConstraints { make in
//            make.centerY.equalTo(l)
//            make.left.equalTo(l.snp.right).offset(6)
//            make.height.equalTo(14)
//        }
//        bClabel1.snp.makeConstraints { make in
//            make.centerY.equalTo(l)
//            make.right.equalTo(l.snp.left).offset(-6)
//            make.height.equalTo(14)
//        }
//    }
//    @objc func bclabelTapped() {
//        openUrl("https://www.notion.so/Privacy-Policy-12e1fb8957eb498eb7bbac31334876df")
//        
//        
//    }
//    @objc func bllabelTapped() {
//        openUrl("https://www.notion.so/Terms-of-Use-f5a04b9fca9f493dafa8d49952b425ca")
//        
//    }
//    @objc func restoreAction(){
//        
//    }
//    public func openUrl(_ urlStr: String) {
//        guard let url = URL(string: urlStr) else {
//            print("无法创建URL")
//            return
//        }
//        
//        let application = UIApplication.shared
//        if !application.canOpenURL(url) {
//            print("无法打开\"\(url)\", 请确保此应用已经正确安装.")
//            return
//        }
//        
//        application.open(url, options: [:], completionHandler: { success in
//            // 这里可以处理URL打开之后的回调
//        })
//    }
//    // MARK: UIPageViewControllerDataSource
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let currentIndex = imageNames.firstIndex(of: (viewController as! JNSplashDetailVC).imageName) else {
//            return nil
//        }
//        let previousIndex = currentIndex - 1
//       
//        return previousIndex >= 0 ? viewControllerForPage(previousIndex) : nil
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let currentIndex = imageNames.firstIndex(of: (viewController as! JNSplashDetailVC).imageName) else {
//            return nil
//        }
//        let nextIndex = currentIndex + 1
//        return nextIndex < imageNames.count ? viewControllerForPage(nextIndex) : nil
//    }
//
//    // MARK: UIPageViewControllerDelegate
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if completed, let currentViewController = viewControllers?.first as? JNSplashDetailVC, let currentIndex = imageNames.firstIndex(of: currentViewController.imageName) {
//            pageControl.currentPage = currentIndex
//            
//        }
//    }
//    
   
//}
