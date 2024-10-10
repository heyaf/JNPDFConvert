import UIKit

class JNSplashViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController!
    let pageImages = ["bg_1", "bg_2", "bg_3", "bg_3"] // 背景图
    let gifs = ["splash1", "splash2", "splash3", "splash4"] // 动图
    let pageTitles = ["Enjoy the PDF\n Convert", "Convert Images to PDF", "More Features", "Edit Conversion Results"]
    let pageSubtitles = ["", "Convert photos or receipts to PDF with one-click", "Multiple ways to easily convert PDF", "Crop, sign, filter, merge PDF, compress PDF"]

    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        UIPageControl.appearance().isHidden = true
        // 初始化 PageViewController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // 设置第一页
        if let startingViewController = viewControllerAtIndex(index: 0) {
            pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
            
            // 将 PageViewController 添加为子视图
            pageViewController.view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight + 100)
            addChild(pageViewController)
            self.view.addSubview(pageViewController.view)
            pageViewController.didMove(toParent: self)
        }
        
//        // 禁用手势
//        if let gestureRecognizers = pageViewController.view.gestureRecognizers {
//            for gesture in gestureRecognizers {
//                gesture.isEnabled = false
//            }
//        }
    }

    // MARK: - 页面控制器数据源方法
    func viewControllerAtIndex(index: Int) -> JNSplashDetailViewController? {
        if index < 0 || index >= pageTitles.count {
            return nil
        }
        
        let contentVC = JNSplashDetailViewController()
        contentVC.imageName = pageImages[index]
        contentVC.animationName = gifs[index]
        contentVC.titleText = pageTitles[index]
        contentVC.subtitleText = pageSubtitles[index]
        contentVC.pageIndex = index
        contentVC.nextBlock = {
            self.goToNextPage()
        }
        return contentVC
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }

    // 只在动画完成后更新 currentIndex
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first as? JNSplashDetailViewController {
            currentIndex = visibleViewController.pageIndex
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousIndex = currentIndex - 1
        if previousIndex < 0 {
            return nil
        }
        return viewControllerAtIndex(index: previousIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = currentIndex + 1
        if nextIndex >= pageTitles.count {
            return nil
        }
        return viewControllerAtIndex(index: nextIndex)
    }

    // MARK: - 切换到下一页
    func goToNextPage() {
        currentIndex += 1
        let nextIndex = currentIndex
        if nextIndex < pageTitles.count {
            if let nextViewController = viewControllerAtIndex(index: nextIndex) {
                pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            }
        } else {
            let tbBarControllerConfig = TabBarControllerConfig()
            let tab =  tbBarControllerConfig.tabBarController
            
            AppUtil.getWindow()?.rootViewController = tab
            
        }
    }
}
