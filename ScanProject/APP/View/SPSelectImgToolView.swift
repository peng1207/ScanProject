//
//  SPSelectImgToolView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/2.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary

class SPSelectImgToolView:  UIView{
    fileprivate lazy var toolView : UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var sliderView : SPSliderView = {
        let view = SPSliderView()
        view.title = SPLanguageChange.sp_getString(key: "radius_size")
        view.isHidden = true
        view.slider.minimumValue = 0
        view.slider.maximumValue = 100
        view.value = 0
        return view
    }()
    fileprivate lazy var photoBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_photo"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "public_photo_select"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(sp_clickPhoto), for: UIControl.Event.touchUpInside)
        btn.isSelected = true
        return btn
    }()
    lazy var radiusBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_raduis"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "public_raduis_select"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(sp_clickRadius), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var cameraBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_camera"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickCamear), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var albumBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_album"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickAlbum), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var btnView : UIView = {
        let view = UIView()
        return view
    }()
    var selectBlock : SPBtnTypeComplete?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.toolView)
        self.toolView.addSubview(self.photoBtn)
        self.toolView.addSubview(self.radiusBtn)
        self.toolView.addSubview(self.lineView)
        self.addSubview(self.sliderView)
        self.addSubview(self.btnView)
        self.btnView.addSubview(self.albumBtn)
        self.btnView.addSubview(self.cameraBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(40)
        }
        self.photoBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.toolView).offset(10)
            maker.top.bottom.equalTo(self.toolView).offset(0)
            maker.width.equalTo(self.photoBtn.snp.height).offset(0)
        }
        self.radiusBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.photoBtn.snp.right).offset(10)
            maker.width.height.top.equalTo(self.photoBtn).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.toolView).offset(0)
            maker.height.equalTo(sp_scale(value: 1))
        }
        self.btnView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(70)
            maker.top.equalTo(self.toolView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.albumBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.btnView.snp.left).offset(10)
            maker.top.equalTo(self.btnView).offset(15)
            maker.width.height.equalTo(40)
        }
        self.cameraBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.albumBtn.snp.right).offset(10)
            maker.top.width.height.equalTo(self.albumBtn).offset(0)
        }
        self.sliderView.snp.makeConstraints { (maker) in
            maker.left.right.top.height.equalTo(self.btnView).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPSelectImgToolView {
    @objc fileprivate func sp_clickPhoto(){
        self.btnView.isHidden = false
        self.sliderView.isHidden = true
        self.photoBtn.isSelected = true
        self.radiusBtn.isSelected = false
    }
    @objc fileprivate func sp_clickRadius(){
        self.btnView.isHidden = true
        self.sliderView.isHidden = false
        self.photoBtn.isSelected = false
        self.radiusBtn.isSelected = true
    }
    @objc fileprivate func sp_clickCamear(){
        sp_dealClick(type: .camera)
    }
    @objc fileprivate func sp_clickAlbum(){
        sp_dealClick(type: .photo)
    }
    fileprivate func sp_dealClick(type : SPBtnType){
        guard let block = self.selectBlock else {
            return
        }
        block(type)
    }
}
