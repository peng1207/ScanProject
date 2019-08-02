//
//  SPSelectImgVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/1.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary

class SPSelectImgVC: SPBaseVC {
    var qrCodeModel : SPQRCodeModel?
    fileprivate lazy var qrCodeView : SPQRCodeView = {
        let view = SPQRCodeView()
        return view
    }()
    fileprivate lazy var toolView : SPSelectImgToolView = {
        let view = SPSelectImgToolView()
        view.selectBlock = { [weak self] (type)in
            self?.sp_dealSelect(type: type)
        }
        view.sliderView.valueBlock = { [weak self] (radius) in
            self?.sp_deal(radius: radius)
        }
        return view
    }()
    fileprivate lazy var selectBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_select"), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.setImage(UIImage(named: "public_close"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickBack), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var isBg : Bool = false
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.canceBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.selectBtn)
        self.view.addSubview(self.qrCodeView)
        self.view.addSubview(self.safeView)
        self.view.addSubview(self.toolView)
        
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
            maker.height.equalTo(self.qrCodeView.snp.width).offset(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
        }
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.view).offset(0)
            maker.top.equalTo(self.toolView.snp.top).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPSelectImgVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
    
}
extension SPSelectImgVC {
    /// 处理选择的类型
    ///
    /// - Parameter type: 类型
    fileprivate func sp_dealSelect(type : SPBtnType){
        switch type {
        case .photo:
            sp_clickPhoto()
        case .camera:
            sp_clickCamera()
        default:
            sp_log(message: "没有其他")
        }
    }
    
    /// 点击相机
    fileprivate func sp_clickCamera(){
        let imgPickerVC = UIImagePickerController()
        imgPickerVC.sourceType = .camera
        imgPickerVC.allowsEditing = true
        imgPickerVC.delegate = self
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    /// 点击相册
    fileprivate func sp_clickPhoto(){
        let imgPickerVC = UIImagePickerController()
        imgPickerVC.sourceType = .photoLibrary
        imgPickerVC.allowsEditing = true
        imgPickerVC.delegate = self
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    @objc fileprivate func sp_clickDone(){
        guard let block = self.selectBlock else {
            sp_clickBack()
            return
        }
        block(self.qrCodeModel)
        sp_clickBack()
    }
    /// 处理获取到半径
    ///
    /// - Parameter radius: 半径
    fileprivate func sp_deal(radius : Float){
        self.qrCodeModel?.iconRadius = radius
        sp_setupData()
    }
}

