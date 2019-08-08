//
//  SPIndexVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/30.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
class SPIndexVC: SPBaseVC {
    fileprivate lazy var scanBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_scan"), for: UIControl.State.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.addTarget(self, action: #selector(sp_clickScan), for: UIControl.Event.touchUpInside)
        return btn
    }()
   
    fileprivate lazy var toolView : SPIndexToolView = {
        let view = SPIndexToolView()
        view.clickBlock = { [weak self] (type) in
            self?.sp_dealClick(type: type)
        }
        view.backgroundColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
        return view
    }()
    fileprivate lazy var indexView : SPIndexView = {
        let view = SPIndexView()
        return view
    }()
    fileprivate lazy var collectionView : SPIndexCollectionView = {
        let view = SPIndexCollectionView()
        view.selectBlock = { [weak self] (type) in 
            self?.sp_dealClick(type: type)
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        var list = [SPIndexModel]()
        list.append(SPIndexModel.sp_init(type: .text))
        list.append(SPIndexModel.sp_init(type: .url))
        list.append(SPIndexModel.sp_init(type: .businessCard))
        list.append(SPIndexModel.sp_init(type: .wifi))
        list.append(SPIndexModel.sp_init(type: .voice))
        self.collectionView.dataList = list
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "index_title")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.scanBtn)
        self.view.addSubview(self.safeView)
       
        self.view.addSubview(self.indexView)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.toolView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.indexView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(5)
            maker.top.equalTo(self.view).offset(5)
            maker.right.equalTo(self.view).offset(-5)
            maker.height.equalTo(200)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.indexView.snp.bottom).offset(10)
//            maker.height.equalTo(150)
            maker.bottom.equalTo(self.toolView.snp.top).offset(0)
        }
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.view).offset(0)
            maker.top.equalTo(self.toolView.snp.top).offset(0)
        }
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(49)
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
extension SPIndexVC {
    /// 点击扫描
    @objc fileprivate func sp_clickScan(){
        let scanVC = SPScanVC()
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    /// 点击历史记录
    @objc fileprivate func sp_clickHistory(){
        let historyVC = SPHistoryVC()
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    /// 点击生成二维码
    @objc fileprivate func sp_clickCreatQR(){
        let data = self.indexView.sp_getContent()
        if data.count > 0 {
            let codeModel = SPQRCodeModel()
            codeModel.content = data
            codeModel.sourceType = K_QRCODE_SOURCETYPE_ADD
 
            let qrCodeVC = SPQRCodeVC()
            qrCodeVC.qrCodeModel = SPQRCodeModel.sp_deserialize(from:  sp_getString(string: SPDataBase.sp_save(model:  codeModel)?.sp_toString()))
            self.navigationController?.pushViewController(qrCodeVC, animated: true)
            self.indexView.sp_clearData()
        }else{
            let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "tips"), message: SPLanguageChange.sp_getString(key: "no_msg_qrCode"), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "know"), style: UIAlertAction.Style.default, handler: { (action) in
                
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    fileprivate func sp_clickMore(){
        let moreVC = SPMoreVC()
        self.navigationController?.pushViewController(moreVC, animated: true)
    }
    fileprivate func sp_clickVoice(){
        let voiceVC = SPVoiceVC()
        self.navigationController?.pushViewController(voiceVC, animated: true)
    }
    /// 处理点击
    ///
    /// - Parameter type: 点击的类型
    fileprivate func sp_dealClick(type : SPBtnType){
        switch type {
        case .history:
            sp_clickHistory()
        case .more:
            sp_clickMore()
        case .createQRCode:
            sp_clickCreatQR()
        case .voice:
            sp_clickVoice()
        case .text , .wifi , .url , .businessCard:
            self.indexView.type = type
        default:
            sp_log(message: "点击到其他")
        }
    }
}
