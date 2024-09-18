//
//  AllToolsVC.swift
//  JNPDFConvert
//
//  Created by hebert on 2024/9/14.
//

import UIKit

class AllToolsVC: BaseViewController {
    lazy var button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("点击", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        btn.addTarget(self, action: #selector(event), for: .touchUpInside)
        return btn
    }()
    let menuBubble = BTBubble()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(300)
            make.size.equalTo(CGSize(width: 60, height: 40))
        }
        menuBubble.shouldShowMask = true
        menuBubble.maskColor = .black.withAlphaComponent(0.2)
    }
    @objc func event() {
       
        
        
        let item1 = BTBubble.Menu.Item(text: "Rename", identifier: "Rename", image: UIImage(named: "edit_edit"))
        let item2 = BTBubble.Menu.Item(text: "Delete", identifier: "Delete", image: UIImage(named: "edit_del"))
        let item3 = BTBubble.Menu.Item(text: "Share", identifier: "Share", image: UIImage(named: "edit_share"))
  

        
        var config = BTBubble.Menu.Config()
        config.width = .fixed(220)
        let menuView = BTBubbleMenu(items: [item1, item2, item3], config: config)
        menuView.selectItemBlock = { item in
           
            switch item.identifier {
            case "Delete":
                break
            case "Share":
                break
           
            default:
                break
            }
            
        }
        
        menuBubble.show(customView: menuView, direction: .auto, from:button , duration: nil)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
