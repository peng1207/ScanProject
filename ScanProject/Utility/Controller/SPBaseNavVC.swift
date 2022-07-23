//
//  SPBaseNavVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/27.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SPCommonLibrary
import UIKit

class SPBaseNavVC: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.setImage(UIImage(named: "public_back"), for: UIControl.State.normal)
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            if viewController.responds(to: NSSelectorFromString("sp_clickBack")) {
                btn.addTarget(viewController, action: NSSelectorFromString("sp_clickBack"), for: .touchUpInside)
            }else{
                btn.addTarget(self, action: #selector(sp_clickBackAction), for: .touchUpInside)
            }
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        }
        super.pushViewController(viewController, animated: animated)
    }
    @objc fileprivate func sp_clickBackAction(){
        self.popViewController(animated: true)
    }
    /// UINavigationController
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }

    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            let navBar = UINavigationBarAppearance()
            navBar.backgroundImage = UIImage.sp_image(color: SPColorForHexString(hex: SPHexColor.color_000000.rawValue))
            navBar.backgroundColor = SPColorForHexString(hex: SPHexColor.color_333333.rawValue)
            navBar.shadowImage = UIImage()
            self.navigationBar.standardAppearance = navBar
            self.navigationBar.scrollEdgeAppearance = navBar
        } else {
 
        }
      
    }
}

extension UINavigationController{
    
    class func sp_initialize(){
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = SPColorForHexString(hex: SPHexColor.color_333333.rawValue)
        navBar.setBackgroundImage( UIImage.sp_image(color: SPColorForHexString(hex: SPHexColor.color_000000.rawValue)), for: UIBarMetrics.default)
        //        navBar.barTintColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        navBar.backgroundColor = SPColorForHexString(hex: SPHexColor.color_333333.rawValue)
        navBar.shadowImage = UIImage()

        navBar.titleTextAttributes = [NSAttributedString.Key.font :  sp_fontSize(fontSize: 18),NSAttributedString.Key.foregroundColor : UIColor.white]
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}
