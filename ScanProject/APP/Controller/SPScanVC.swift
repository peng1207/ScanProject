//
//  SPScanVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/27.
//  Copyright © 2019 shupenghuang. All rights reserved.
//
// 扫描

import Foundation
import SnapKit
import AVFoundation
import SPCommonLibrary
class SPScanVC: SPBaseVC {
    fileprivate lazy var manager : SPScanManager = {
        return SPScanManager()
    }()
    fileprivate lazy var previewLayer : SPVideoPreviewLayerView = {
        return SPVideoPreviewLayerView()
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_back"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickBack), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var albumBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_album"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickAlbum), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var flashBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_flashOn"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "public_flashOff"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(sp_clickFlash), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate var isPush : Bool = false
    fileprivate var needShow : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: isPush ? false : true)
        self.isPush = false
        self.needShow = true
        sp_start()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.needShow {
             self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        sp_stop()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.backgroundColor = UIColor.black
        self.previewLayer.backgroundColor = UIColor.black
        self.view.addSubview(self.previewLayer)
        self.view.addSubview(self.backBtn)
        self.view.addSubview(self.albumBtn)
        self.view.addSubview(self.flashBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.previewLayer.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.top.equalTo(self.view).offset(sp_statusBarHeight() + 6)
        }
        self.albumBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(30)
            maker.right.equalTo(self.view).offset(-20)
            maker.centerY.equalTo(self.backBtn.snp.centerY).offset(0)
        }
        self.flashBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(30)
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-20)
            }
        }
    }
    deinit {
        
    }
}
extension SPScanVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    /// 设置摄像头
    fileprivate func sp_setupManager(){
        self.manager.sp_init(layer: self.previewLayer.layer as? AVCaptureVideoPreviewLayer , noAuth: { [weak self] in
            self?.sp_dealNoAuth()
        }) { [weak self](data) in
            self?.sp_dealScanData(data: data)
        }
    }
    /// 处理没有权限
    fileprivate func sp_dealNoAuth(){
        let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "tips"), message: SPLanguageChange.sp_getString(key: "no_camera_auth") , preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "go_to"), style: UIAlertAction.Style.default, handler: { (action) in
            sp_sysOpen()
        }))
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "know"), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        sp_mainQueue { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    /// 处理获取扫描的数据
    ///
    /// - Parameter data: 扫描得到的数据
    fileprivate func sp_dealScanData(data : [String]){
//        sp_ring()
        sp_shake()
        sp_log(message: data)
       let qrCodeModel = SPQRCodeModel()
        qrCodeModel.content =  data.joined(separator: " ")
        qrCodeModel.sourceType = K_QRCODE_SOURCETYPE_SCAN
        let resultVC = SPScanResultVC()
        resultVC.codeModel = SPDataBase.sp_save(model: qrCodeModel)
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    /// 开启
    func sp_start(){
        self.manager.sp_start()
        self.previewLayer.sp_startAnimation()
    }
    /// 停止
    func sp_stop(){
        self.manager.sp_stop()
        self.manager.sp_flashOff()
        self.previewLayer.sp_stopAnimation()
    }
    @objc fileprivate func sp_clickFlash(){
        self.flashBtn.isSelected = self.manager.sp_flash()
    }
    /// 点击相册
    @objc fileprivate func sp_clickAlbum(){
        SPAuthorizatio.sp_isPhoto { [weak self](auth) in
            if auth {
                self?.isPush = true
                self?.needShow = false
                sp_mainQueue {
                    let imgPickerVC = UIImagePickerController()
                    imgPickerVC.sourceType = .photoLibrary
                    imgPickerVC.delegate = self
                    self?.present(imgPickerVC, animated: true, completion: nil)
                }
            }else{
                sp_mainQueue {
                    let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "tips"), message: SPLanguageChange.sp_getString(key: "no_photo_auth"), preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "go_to"), style: UIAlertAction.Style.default, handler: { (action) in
                        
                    }))
                    alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "cance"), style: UIAlertAction.Style.cancel, handler: { (action) in
                        
                    }))
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
   
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if  let resultList = SPQRCode.sp_recognizeQRCode(codeImg: img) , sp_count(array: resultList) > 0{
            sp_dealScanData(data: resultList)
        }else {
            // 没有识别到数据
            sp_stop()
            let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "tips"), message: SPLanguageChange.sp_getString(key: "no_data_identified"), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "done"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
                self?.sp_start()
            }))
            sp_mainQueue {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
  
}



