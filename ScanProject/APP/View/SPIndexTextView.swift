//
//  SPIndexTextView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/30.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPIndexTextView:  UIView{
    lazy var textView : UITextView = {
        let view = UITextView()
        view.font = sp_fontSize(fontSize: 16)
        view.textColor = SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue)
        view.sp_border(color: SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue), width: sp_scale(value: 1))
        view.sp_cornerRadius(radius: 5)
        view.backgroundColor = SPColorForHexString(hex: SPHexColor.color_666666.rawValue)
        view.inputAccessoryView = SPKeyboardView.sp_show(done: {
            
        }, cance: {
            
        })
        view.tintColor = UIColor.white
        return view
    }()
    fileprivate lazy var placeholderLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SPHexColor.color_999999.rawValue)
        label.textAlignment = .left
        label.font = sp_fontSize(fontSize: 15)
        return label
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
        self.addSubview(self.placeholderLabel)
        self.addSubview(self.textView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.textView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.placeholderLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.textView.snp.left).offset(10)
            maker.right.equalTo(self.textView.snp.right).offset(-10)
            maker.top.equalTo(self.textView.snp.top).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
