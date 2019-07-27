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
    /// 创建UI
    override func sp_setupUI() {
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
    
    fileprivate func sp_setupManager(){
        self.manager.sp_init(layer: self.previewLayer.layer as? AVCaptureVideoPreviewLayer , noAuth: {
            
        }) { (data) in
            
        }
        self.manager.sp_start()
        self.previewLayer.sp_startAnimation()
    }
    
}

