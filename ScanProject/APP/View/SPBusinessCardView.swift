//
//  SPBusinessCardView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/30.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPBusinessCardView:  UIView{
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    /// 姓名
    lazy var nameView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "name"))
        return view
    }()
    /// 职位
    lazy var positionView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "position"))
        return view;
    }()
    /// 公司
    lazy var companyView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "company"))
        return view;
    }()
    /// 移动电话
    lazy var phoneView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "phone"), keyboardType: UIKeyboardType.numberPad)
        return view
    }()
    /// 电话号码
    lazy var telView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "tel"), keyboardType: UIKeyboardType.numberPad)
        return view
    }()
    /// 邮箱
    lazy var emailView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "email"), keyboardType: UIKeyboardType.emailAddress)
        return view
    }()
    /// 公司地址
    lazy var companyAddressView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "company_address"))
        return view
    }()
    /// 备注
    lazy var remarksView : SPIndexContentView = {
        let view = SPIndexContentView()
        view.sp_setData(title: SPLanguageChange.sp_getString(key: "remarks"))
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
        self.scrollView.addSubview(self.positionView)
        self.scrollView.addSubview(self.companyView)
        self.scrollView.addSubview(self.phoneView)
        self.scrollView.addSubview(self.telView)
        self.scrollView.addSubview(self.emailView)
        self.scrollView.addSubview(self.companyAddressView)
        self.scrollView.addSubview(self.remarksView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.top.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(40)
        }
        self.positionView.snp.makeConstraints { (maker) in
            maker.left.height.right.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
        }
        self.companyView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(self.positionView.snp.bottom).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.height.equalTo(self.positionView.snp.height).offset(0)
        }
        self.phoneView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.companyView).offset(0)
            maker.top.equalTo(self.companyView.snp.bottom).offset(0)
        }
        self.telView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.phoneView).offset(0)
            maker.top.equalTo(self.phoneView.snp.bottom).offset(0)
        }
        self.emailView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.telView).offset(0)
            maker.top.equalTo(self.telView.snp.bottom).offset(0)
        }
        self.companyAddressView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.emailView).offset(0)
            maker.top.equalTo(self.emailView.snp.bottom).offset(0)
        }
        self.remarksView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.companyAddressView).offset(0)
            maker.top.equalTo(self.companyAddressView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-1)
        }
    }
    deinit {
        
    }
}

class SPIndexContentView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = sp_fontSize(fontSize: 14)
        return label
    }()
    lazy var textField : UITextField = {
        let view = UITextField()
        view.textColor = UIColor.white
        view.font = sp_fontSize(fontSize: 14)
        view.clearButtonMode = UITextField.ViewMode.whileEditing
        view.inputAccessoryView = SPKeyboardView.sp_show(done: {
            
        }, cance: {
            
        })
        view.tintColor = UIColor.white
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_setData(title : String?,placeholder : String? = nil,keyboardType : UIKeyboardType = .default){
        self.titleLabel.text = title
        self.textField.placeholder = placeholder
        self.textField.keyboardType = keyboardType
    }
    func sp_clearData(){
        self.textField.text = ""
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.textField)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(SPLanguageChange.sp_chinese() ? 80 : 120)
            maker.left.equalTo(self).offset(10)
        }
        self.textField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(5)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.bottom.equalTo(self).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel).offset(0)
            maker.right.equalTo(self.textField.snp.right).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
            maker.height.equalTo(1)
        }
    }
    deinit {
        
    }
}

