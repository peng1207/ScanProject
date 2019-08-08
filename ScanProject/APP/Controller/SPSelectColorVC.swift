//
//  SPSelectColorVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/1.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary

class SPSelectColorVC: SPBaseVC {
    var qrCodeModel : SPQRCodeModel?
    fileprivate lazy var qrCodeView : SPQRCodeView = {
        let view = SPQRCodeView()
        return view
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var colorList : [String] = {
        var list = [String]()
        return list
    }()
    fileprivate lazy var colorView : SPColorView = {
        let view = SPColorView()
        view.selectBlock = { [weak self] (colorHex) in
            self?.sp_dealSelect(colorHex: colorHex)
        }
        return view
    }()
    fileprivate lazy var bgColorBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "background_color"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue), for: UIControl.State.selected)
        btn.titleLabel?.font = sp_fontSize(fontSize: 16)
        btn.backgroundColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
        btn.addTarget(self, action: #selector(sp_clickBg), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var colorCodeBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle(SPLanguageChange.sp_getString(key: "color_code"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.setTitleColor(SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue), for: UIControl.State.selected)
        btn.titleLabel?.font = sp_fontSize(fontSize: 16)
        btn.isSelected = true
        btn.backgroundColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
        btn.addTarget(self, action: #selector(sp_clickColorCode), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var selectBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_select"), for: UIControl.State.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.setImage(UIImage(named: "public_close"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickBack), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var selectBlock : SPQRCodeComplete?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.qrCodeView.model = self.qrCodeModel
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "color")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.canceBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.selectBtn)
        self.view.addSubview(self.qrCodeView)
        self.view.addSubview(self.colorCodeBtn)
        self.view.addSubview(self.bgColorBtn)
        self.view.addSubview(self.safeView)
        self.view.addSubview(self.colorView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.qrCodeView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.view).offset(10)
        }
        self.colorCodeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(0)
            maker.top.equalTo(self.qrCodeView.snp.bottom).offset(10)
            maker.width.equalTo(self.bgColorBtn.snp.width).offset(0)
            maker.height.equalTo(40)
        }
        self.bgColorBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.colorCodeBtn.snp.right).offset(0)
            maker.right.equalTo(self.view).offset(0)
            maker.height.top.equalTo(self.colorCodeBtn).offset(0)
        }
        self.colorView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
            maker.top.equalTo(self.colorCodeBtn.snp.bottom).offset(0)
        }
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.view).offset(0)
            maker.top.equalTo(self.colorView.snp.top).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPSelectColorVC {
    
    fileprivate func sp_dealSelect(colorHex : String){
        if self.colorCodeBtn.isSelected {
             self.qrCodeModel?.mainColorHex = colorHex
        }else{
            self.qrCodeModel?.bgColorHex = colorHex
        }
        sp_setupData()
    }
    @objc fileprivate func sp_clickBg(){
        self.bgColorBtn.isSelected = true
        self.colorCodeBtn.isSelected = false
    }
    @objc fileprivate func sp_clickColorCode(){
        self.colorCodeBtn.isSelected = true
        self.bgColorBtn.isSelected = false
    }
    @objc fileprivate func sp_clickDone(){
        guard let block = self.selectBlock else {
            sp_clickBack()
            return
        }
        block(SPDataBase.sp_save(model: self.qrCodeModel))
        sp_clickBack()
      
    }
}
