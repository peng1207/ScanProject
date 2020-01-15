//
//  SPQRCodeVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/27.
//  Copyright © 2019 shupenghuang. All rights reserved.
//
// 生成二维码

import Foundation
import SnapKit
import SPCommonLibrary

typealias SPQRCodeComplete = (_ model : SPQRCodeModel?)->Void

class SPQRCodeVC: SPBaseVC {
    var qrCodeModel : SPQRCodeModel?
    fileprivate lazy var toolView : SPQRCodeToolView = {
        let view = SPQRCodeToolView()
        view.backgroundColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
        view.selectBlock = { [weak self] (type) in
            self?.sp_dealSelect(type: type)
        }
        return view
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.numberOfLines = 0
      
        
        return label
    }()
    fileprivate lazy var moreBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_more_spot"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickMore), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var qrCodeView : SPQRCodeView = {
        let view = SPQRCodeView()
        return view
    }()
   
    fileprivate lazy var shareBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_share"), for: UIControl.State.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(sp_clickShare), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate var codeMainColor : UIColor?
    fileprivate var codeBgColor : UIColor?
    fileprivate var bgImg : UIImage?
    fileprivate var iconImg : UIImage?
    fileprivate var selectTyep : SPBtnType = .icon
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
        
        // 文本 网址 名片 wifi 语音识别  位置 活码(暂时不做)
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
        if sp_getString(string: self.contentLabel.text).count == 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            let attributedString = NSMutableAttributedString(string: sp_getString(string: self.qrCodeModel?.sp_showContent()))
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attributedString.length))
            self.contentLabel.attributedText = attributedString
        }
        self.qrCodeView.model = self.qrCodeModel
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "QRCode")
        self.view.addSubview(self.contentLabel)
        self.view.addSubview(self.moreBtn)
        self.view.addSubview(self.lineView)
        self.view.addSubview(self.qrCodeView)
        self.view.addSubview(self.safeView)
        self.view.addSubview(self.toolView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.shareBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(5)
            maker.right.equalTo(self.moreBtn.snp.left).offset(-5)
            maker.top.equalTo(self.view).offset(5)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.lessThanOrEqualTo(self.lineView.snp.top).offset(-5)
        }
        self.moreBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(30)
            maker.right.equalTo(self.view).offset(-10)
            maker.centerY.equalTo(self.lineView.snp.top).multipliedBy(0.5)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentLabel).offset(0)
            maker.right.equalTo(self.moreBtn.snp.right).offset(0)
            maker.bottom.equalTo(self.qrCodeView.snp.top).offset(-30)
            maker.height.equalTo(sp_scale(value: 1))
        }
        self.qrCodeView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.view).offset(0)
        }
        
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.toolView).offset(0)
            maker.bottom.equalTo(self.view).offset(0)
        }
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(50)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        
    }
}
extension SPQRCodeVC {
    /// 点击分享
    @objc fileprivate func sp_clickShare(){
       
        if let shareImg =  self.qrCodeView.sp_image(){
            SPShare.sp_share(imgs: [shareImg], vc: self)
        }
    }

    fileprivate func sp_dealSelect(type : SPBtnType){
        self.selectTyep = type
        switch type {
        case .color:
            sp_color()
        case .baseMap:
            sp_baseMap()
        case .icon:
            sp_icon()
        case .text:
            sp_text()
        default:
            sp_log(message: "没有了")
        }
    }
    /// 点击文本
    fileprivate func sp_text(){
        let textVC = SPTextVC()
        textVC.qrCodeModel = SPQRCodeModel.sp_init(model: self.qrCodeModel)
        textVC.selectBlock = { [weak self] (model) in
            self?.sp_dealSelect(model: model)
        }
        self.navigationController?.pushViewController(textVC, animated: true)
    }
    /// 点击底图
    fileprivate func sp_baseMap(){
        let selectImg = SPSelectImgVC()
        selectImg.qrCodeModel = SPQRCodeModel.sp_init(model: self.qrCodeModel)
        selectImg.isBg = true
        selectImg.selectBlock = { [weak self] (model) in
            self?.sp_dealSelect(model: model)
        }
        self.navigationController?.pushViewController(selectImg, animated: true)
    }
    ///  点击icon
    fileprivate func sp_icon(){
        let selectImg = SPSelectImgVC()
        selectImg.qrCodeModel = SPQRCodeModel.sp_init(model: self.qrCodeModel)
        selectImg.isBg = false
        selectImg.selectBlock = { [weak self] (model) in
            self?.sp_dealSelect(model: model)
        }
        self.navigationController?.pushViewController(selectImg, animated: true)
    }
    /// 点击颜色
    fileprivate func sp_color(){
        let colorVC = SPSelectColorVC()
        colorVC.qrCodeModel = SPQRCodeModel.sp_init(model: self.qrCodeModel)
        colorVC.selectBlock = { [weak self] (model) in
            self?.sp_dealSelect(model: model)
        }
        self.navigationController?.pushViewController(colorVC, animated: true)
    }
    /// 处理添加数据之后 更新数据
    ///
    /// - Parameter model: 数据源
    fileprivate func sp_dealSelect(model : SPQRCodeModel?){
        guard let qrModel = model else {
            return
        }
        self.qrCodeModel = qrModel
        sp_setupData()
    }
    /// 点击更多
    @objc fileprivate func sp_clickMore(){
        let resultVC = SPScanResultVC()
        resultVC.codeModel = self.qrCodeModel
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
}

