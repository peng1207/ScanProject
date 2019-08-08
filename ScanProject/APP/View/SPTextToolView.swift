//
//  SPTextToolView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/2.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPTextToolView:  UIView{
    fileprivate lazy var topBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_text_top"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "public_text_top"), for: UIControl.State.highlighted)
        btn.addTarget(self, action: #selector(sp_clickTop), for: UIControl.Event.touchUpInside)
        btn.backgroundColor = UIColor.white
        return btn
    }()
    fileprivate lazy var bottomBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_text_bottom"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "public_text_bottom"), for: UIControl.State.highlighted)
        btn.addTarget(self, action: #selector(sp_clickBottom), for: UIControl.Event.touchUpInside)
        btn.backgroundColor = UIColor.white
        return btn
    }()
    
    var clickComplete : SPBtnTypeComplete?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.topBtn)
        self.addSubview(self.bottomBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.topBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self).offset(10)
            maker.width.equalTo(40)
            maker.height.equalTo(self.topBtn.snp.width).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        self.bottomBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.topBtn.snp.right).offset(10)
            maker.top.width.height.equalTo(self.topBtn).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPTextToolView {
    @objc fileprivate func sp_clickTop(){
            sp_dealClick(type: .fontTop)
    }
    @objc fileprivate func sp_clickBottom(){
        sp_dealClick(type: .fontBottom)
    }
    fileprivate func sp_dealClick(type : SPBtnType){
        guard let block = self.clickComplete else{
            return
        }
        block(type)
    }
}
