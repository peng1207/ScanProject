//
//  SPIndexView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/30.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPIndexView:  UIView{
    fileprivate lazy var textView : SPIndexTextView = {
        let view = SPIndexTextView()
        return view
    }()
    fileprivate lazy var cardView : SPBusinessCardView = {
        let view = SPBusinessCardView()
        view.isHidden = true
        return view
    }()
    fileprivate lazy var wifiView : SPWifiView = {
        let view = SPWifiView()
        view.isHidden = true
        return view
    }()
    var type : SPBtnType = .text {
        didSet{
            self.sp_dealSelect()
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_getContent()->String{
        if !self.textView.isHidden {
            return self.textView.textView.text
        }else if !self.wifiView.isHidden {
            return self.wifiView.sp_getData()
        }else if !self.cardView.isHidden {
            var content = "BEGIN:VCARD \nVERSION:3.0 "
            var isValue = false
            if sp_getString(string: self.cardView.nameView.textField.text).count > 0 {
                content = content + "\nN:\(sp_getString(string: self.cardView.nameView.textField.text))"
                isValue = true
            }
            if sp_getString(string: self.cardView.emailView.textField.text).count > 0 {
                content.append("\nEMAIL:\(sp_getString(string: self.cardView.emailView.textField.text))")
                 isValue = true
            }
            if sp_getString(string: self.cardView.phoneView.textField.text).count > 0 {
                content.append("\nTEL;CELL:\(sp_getString(string: self.cardView.phoneView.textField.text))")
                 isValue = true
            }
            if sp_getString(string: self.cardView.telView.textField.text).count > 0 {
                content.append("\nTEL:\(sp_getString(string: self.cardView.telView.textField.text))")
                 isValue = true
            }
            if sp_getString(string: self.cardView.companyAddressView.textField.text).count > 0 {
                content.append("\nADR;TYPE=WORK:\(sp_getString(string: self.cardView.companyAddressView.textField.text))")
                 isValue = true
            }
            if sp_getString(string: self.cardView.companyView.textField.text).count > 0 {
                content.append("\nORG:\(sp_getString(string: self.cardView.companyView.textField.text))")
                 isValue = true
            }
            if sp_getString(string: self.cardView.positionView.textField.text).count > 0 {
                content.append("\nTITLE:\(sp_getString(string: self.cardView.positionView.textField.text))")
                 isValue = true
            }
            if sp_getString(string: self.cardView.remarksView.textField.text).count > 0 {
                content.append("\nNOTE:\(sp_getString(string: self.cardView.remarksView.textField.text))")
                 isValue = true
            }
            content.append("\nEND:VCARD")
            if isValue {
                return content
            }
            return ""
        }
        return ""
    }
    /// 清除数据
    func sp_clearData(){
//        self.textView.textView.text = ""
//        self.cardView.nameView.sp_clearData()
//        self.cardView.emailView.sp_clearData()
//        self.cardView.phoneView.sp_clearData()
//        self.cardView.telView.sp_clearData()
//        self.cardView.companyAddressView.sp_clearData()
//        self.cardView.companyView.sp_clearData()
//        self.cardView.positionView.sp_clearData()
//        self.cardView.remarksView.sp_clearData()
    }
    /// 处理选择的
    fileprivate func sp_dealSelect(){
        sp_allHidden()
        switch self.type {
        case .text :
            self.textView.isHidden = false
            self.textView.textView.text = ""
        case .url:
            self.textView.isHidden = false
            self.textView.textView.text = "http://"
        case .wifi:
            self.wifiView.isHidden = false
        case .businessCard :
            self.cardView.isHidden = false
        default:
            sp_allHidden()
        }
    }
    fileprivate func sp_allHidden(){
        self.textView.isHidden = true
        self.cardView.isHidden = true
        self.wifiView.isHidden = true
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.textView)
        self.addSubview(self.cardView)
        self.addSubview(self.wifiView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.textView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self).offset(0)
        }
        self.cardView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.wifiView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
