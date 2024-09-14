//
//  BaseViewController.swift
//  LiaoLiao
//
//  Created by YAMYEE on 2019/7/15.
//  Copyright © 2019 . All rights reserved.
//

import UIKit



/// 子类实现 BaseViewControllerProtocol自动添加UI，加载数据，也可以分开两个协议
open class BaseViewController: BaseSimpleViewController {

    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

