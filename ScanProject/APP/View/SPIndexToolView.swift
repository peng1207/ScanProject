//
//  SPIndexToolView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/30.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPIndexToolView:  UIView{
    fileprivate lazy var historyBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_history"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickHistory), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var moreBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_more"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickMore), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var createBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_create"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickCreate), for: UIControl.Event.touchUpInside)
        btn.sp_cornerRadius(radius: 32)
        btn.backgroundColor = SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue)
        return btn
    }()
    var clickBlock : SPBtnTypeComplete?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.historyBtn)
        self.addSubview(self.moreBtn)
        self.addSubview(self.createBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.historyBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.left.equalTo(self).offset(20)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.moreBtn.snp.makeConstraints { (maker) in
            maker.width.height.top.equalTo(self.historyBtn).offset(0)
            maker.right.equalTo(self.snp.right).offset(-20)
        }
        self.createBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.top.equalTo(self.snp.top).offset(-15)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
            maker.width.equalTo(self.createBtn.snp.height).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPIndexToolView {
    /// 点击历史记录
    @objc fileprivate func sp_clickHistory(){
        sp_dealComplete(type: .history)
    }
    /// 点击更多
    @objc fileprivate func sp_clickMore(){
        sp_dealComplete(type: .more)
    }
    /// 点击创建
    @objc fileprivate func sp_clickCreate(){
        sp_dealComplete(type: .createQRCode)
    }
    fileprivate func sp_dealComplete(type : SPBtnType){
        guard let block = self.clickBlock else {
            return
        }
        block(type)
    }
}

