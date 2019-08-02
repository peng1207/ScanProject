//
//  SPKeyboardView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/30.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPKeyboardView:  UIView{
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "finish"), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_fontSize(fontSize: 16)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "cance"), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_fontSize(fontSize: 16)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var doneBlock : (()->Void)?
    fileprivate var canceBlock : (()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 展示view
    ///
    /// - Parameters:
    ///   - done: 点击完成回调
    ///   - cance: 点击取消回调
    /// - Returns: 当前的view
    class func sp_show(done : @escaping ()->Void ,cance : @escaping ()->Void)->SPKeyboardView{
        let view = SPKeyboardView(frame: CGRect(x: 0, y: 0, width: sp_screenWidth(), height: 50))
        view.doneBlock = done
        view.canceBlock = cance
        view.backgroundColor = UIColor.white
        return view
    }
    @objc fileprivate func sp_clickDone(){
        sp_hideKeyboard()
        guard let block = self.doneBlock else {
            return
        }
        block()
    }
    @objc fileprivate func sp_clickCance(){
         sp_hideKeyboard()
        guard let block = self.canceBlock else {
            return
        }
        block()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.doneBtn)
        self.addSubview(self.canceBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(60)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.bottom.width.equalTo(self.canceBtn).offset(0)
        }
    }
    deinit {
        
    }
}
