//
//  SPWifiView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/30.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary

class SPWifiView:  UIView{
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var nameView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "wifi_name"))
        return view
    }()
    fileprivate lazy var pwdView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "pwd"), keyboardType: UIKeyboardType.asciiCapable)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.nameView)
        self.scrollView.addSubview(self.pwdView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.height.equalTo(40)
        }
        self.pwdView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
