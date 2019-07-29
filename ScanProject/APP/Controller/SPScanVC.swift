//
//  SPScanVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/27.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_start()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    }
    deinit {
        
    }
}
extension SPScanVC {
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
        let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "tips"), message: SPLanguageChange.sp_getString(key: "no_camera_auth") , preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "go_to"), style: UIAlertActionStyle.default, handler: { (action) in
            sp_sysOpen()
        }))
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "know"), style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        sp_mainQueue { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    /// 处理获取扫描的数据
    ///
    /// - Parameter data: 扫描得到的数据
    fileprivate func sp_dealScanData(data : [String]){
        
    }
    /// 开启
    func sp_start(){
        self.manager.sp_start()
        self.previewLayer.sp_startAnimation()
    }
    /// 停止
    func sp_stop(){
        self.manager.sp_stop()
        self.previewLayer.sp_stopAnimation()
    }
}

