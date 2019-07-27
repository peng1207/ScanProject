//
//  SPBaseVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/27.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
class SPBaseVC : UIViewController{
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
}

extension  SPBaseVC{
    
    fileprivate func setupBase(){
        // UI适配
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
//        self.view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
    }
    
}
