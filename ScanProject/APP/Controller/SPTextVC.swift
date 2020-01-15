//
//  SPTextVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/1.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary

class SPTextVC: SPBaseVC {
    var qrCodeModel : SPQRCodeModel?
    fileprivate lazy var qrCodeView : SPQRCodeView = {
        let view = SPQRCodeView()
        view.isShow = true
        view.clickBlock = { [weak self] in
            self?.sp_dealClick()
        }
        return view
    }()
    fileprivate lazy var toolView : SPTextToolView = {
        let view = SPTextToolView()
        view.clickComplete = { [weak self] (type) in
            self?.sp_dealClick(type: type)
        }
        return view
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
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "text")
        self.view.addSubview(self.qrCodeView)
        self.view.addSubview(self.safeView)
        self.view.addSubview(self.toolView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.canceBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.selectBtn)
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
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
        }
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
            maker.height.greaterThanOrEqualTo(0)
        }
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.view).offset(0)
            maker.top.equalTo(self.toolView.snp.top).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPTextVC {
    /// 处理点击
    fileprivate func sp_dealClick(){
        let addTextVC = SPAddTextVC()
        addTextVC.qrCodeModel = self.qrCodeModel
        addTextVC.selectBlock = { [weak self] (model )in
            self?.sp_dealSelect(model: model)
        }
        addTextVC.modalPresentationStyle = .fullScreen
        self.present(addTextVC, animated: true, completion: nil)
    }
    fileprivate func sp_dealSelect(model : SPQRCodeModel?){
        self.qrCodeModel = model
        sp_setupData()
    }
    @objc fileprivate func sp_clickDone(){
        guard let block = self.selectBlock else {
            sp_clickBack()
            return
        }
        block( SPDataBase.sp_save(model: self.qrCodeModel))
        sp_clickBack()
       
    }
    fileprivate func sp_dealClick(type : SPBtnType){
        switch type {
        case .fontTop:
            self.qrCodeModel?.textAlignment = K_FONT_TO_TOP
            sp_setupData()
        case .fontBottom:
            self.qrCodeModel?.textAlignment = K_FONT_TO_BOTTOM
            sp_setupData()
        default:
            sp_log(message: "没有其他")
        }
    }
}
