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
//        view.showsHorizontalScrollIndicator = false
//        view.isScrollEnabled = false
        return view
    }()
    fileprivate lazy var nameView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "wifi_name"))
        return view
    }()
    fileprivate lazy var securityView : UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var securityTitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = sp_fontSize(fontSize: 14)
        label.text = SPLanguageChange.sp_getString(key: "security")
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return view
    }()
    fileprivate lazy var securityScrollView : UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    fileprivate lazy var noPassBtn : UIButton = {
        let btn = sp_setupBtn(title: SPLanguageChange.sp_getString(key: "no_pass"), action: #selector(sp_noPass))
        btn.isSelected = true
        return btn
    }()
    fileprivate lazy var wepBtn : UIButton = {
        return sp_setupBtn(title: SPLanguageChange.sp_getString(key: "wep"), action: #selector(sp_wep))
    }()
    fileprivate lazy var wpaBtn : UIButton = {
        return sp_setupBtn(title: SPLanguageChange.sp_getString(key: "wpa"), action: #selector(sp_wpa))
    }()
    fileprivate lazy var wpa2Btn : UIButton = {
        return sp_setupBtn(title: SPLanguageChange.sp_getString(key: "wpa2"), action: #selector(sp_wpa2))
    }()
    fileprivate func sp_setupBtn(title : String, action: Selector)->UIButton {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_unselect"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "public_select_white"), for: UIControl.State.selected)
        btn.setTitle(title, for: UIControl.State.normal)
        btn.titleLabel?.font = sp_fontSize(fontSize: 14)
        btn.addTarget(self, action: action, for: UIControl.Event.touchUpInside)
        return btn
    }
    fileprivate lazy var pwdView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "pwd"), keyboardType: UIKeyboardType.asciiCapable)
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_getData()->String{
        if sp_getString(string: self.nameView.textField.text).count > 0 {
            var content = "WIFI:"
            content.append("S:"+sp_getString(string: self.nameView.textField.text) + ";")
            if self.noPassBtn.isSelected {
                content.append("T:nopass;")
            }else{
                if self.wepBtn.isSelected {
                    content.append("T:WEP;")
                }else if self.wpaBtn.isSelected {
                      content.append("T:WPA;")
                }else if self.wpa2Btn.isSelected {
                      content.append("T:WPA2;")
                }
                content.append("P:" + sp_getString(string: self.pwdView.textField.text) + ";")
            }
            
            return content
        }else{
            return ""
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.nameView)
        self.scrollView.addSubview(self.securityView)
        self.securityView.addSubview(self.securityTitleLabel)
        self.securityView.addSubview(self.securityScrollView)
        self.securityScrollView.addSubview(self.noPassBtn)
        self.securityScrollView.addSubview(self.wepBtn)
        self.securityScrollView.addSubview(self.wpaBtn)
        self.securityScrollView.addSubview(self.wpa2Btn)
        self.securityView.addSubview(self.lineView)
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
        self.securityView.snp.makeConstraints { (maker) in
            maker.left.height.equalTo(self.nameView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
        }
        securityTitleLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self.securityView).offset(0)
            maker.width.equalTo(SPLanguageChange.sp_chinese() ? 80 : 120)
            maker.left.equalTo(self.securityView).offset(10)
        }
        self.securityScrollView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.securityTitleLabel.snp.right).offset(5)
            maker.top.bottom.equalTo(self.securityView).offset(0)
            maker.right.equalTo(self.securityView).offset(-10)
        }
        self.noPassBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.securityScrollView).offset(0)
            maker.height.equalTo(self.securityScrollView).offset(0)
            maker.top.equalTo(self.securityScrollView).offset(0)
//            maker.bottom.equalTo(self.securityScrollView).offset(0)
            maker.centerY.equalTo(self.securityScrollView).offset(0)
        }
        self.wepBtn.snp.makeConstraints { (maker) in
            maker.top.height.equalTo(self.noPassBtn).offset(0)
            maker.left.equalTo(self.noPassBtn.snp.right).offset(10)
        }
        self.wpaBtn.snp.makeConstraints { (maker) in
            maker.top.height.equalTo(self.noPassBtn).offset(0)
            maker.left.equalTo(self.wepBtn.snp.right).offset(10)
        }
        self.wpa2Btn.snp.makeConstraints { (maker) in
            maker.top.height.equalTo(self.noPassBtn).offset(0)
            maker.left.equalTo(self.wpaBtn.snp.right).offset(10)
            maker.right.equalTo(self.securityScrollView.snp.right).offset(-10)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.securityTitleLabel).offset(0)
            maker.right.equalTo(self.securityView.snp.right).offset(-10)
            maker.bottom.equalTo(self.securityView.snp.bottom).offset(0)
            maker.height.equalTo(1)
        }
        self.pwdView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.securityView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPWifiView {
    @objc fileprivate func sp_noPass(){
        sp_dealDefault()
        self.noPassBtn.isSelected = true
        sp_dealPassView()
    }
    @objc fileprivate func sp_wep(){
        sp_dealDefault()
        self.wepBtn.isSelected = true
        sp_dealPassView()
    }
    @objc fileprivate func sp_wpa(){
        sp_dealDefault()
        self.wpaBtn.isSelected = true
        sp_dealPassView()
    }
    @objc fileprivate func sp_wpa2(){
        sp_dealDefault()
        self.wpa2Btn.isSelected = true
        sp_dealPassView()
    }
    fileprivate func sp_dealDefault(){
        sp_hideKeyboard()
        self.noPassBtn.isSelected = false
        self.wepBtn.isSelected = false
        self.wpaBtn.isSelected = false
        self.wpa2Btn.isSelected = false
    }
    fileprivate func sp_dealPassView(){
        if self.noPassBtn.isSelected {
            self.pwdView.isHidden = true
        }else{
            self.pwdView.isHidden = false
        }
    }
}
