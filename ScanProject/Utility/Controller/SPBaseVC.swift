//
//  SPBaseVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/27.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary
class SPBaseVC : UIViewController,UIGestureRecognizerDelegate{
    lazy var safeView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
        return view
    }()
    var backEnabled : Bool = true
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBase()
    }
    func sp_setupUI() {

    }
    func sp_dealNoData(){
        
    }
    @objc func sp_clickBack(){
        self.navigationController?.popViewController(animated: true)
    }
    deinit {
        sp_log(message: "销毁当前的对象")
    }
}

extension  SPBaseVC{
    
    fileprivate func setupBase(){
        // UI适配
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.view.backgroundColor = SPColorForHexString(hex: SPHexColor.color_333333.rawValue)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = self.backEnabled
    }
    
}
