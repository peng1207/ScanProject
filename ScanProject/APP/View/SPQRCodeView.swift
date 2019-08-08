//
//  SPQRCodeView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/1.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPQRCodeView:  UIView{
    
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.sp_border(color: SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue), width: sp_scale(value: 1))
        label.sp_cornerRadius(radius: 5)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sp_clickLabel)))
        return label
    }()
    fileprivate lazy var qrCodeImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    var isShow : Bool = false
    var model : SPQRCodeModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var clickBlock : SPClickComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        guard let codeModel = self.model else {
            return
        }
        
        sp_sync { [weak self] in
            if let codeData = codeModel.iconData {
                if let img = UIImage(data: codeData){
                    sp_mainQueue {
                        if img.size.width != img.size.height {
                            if img.size.width > img.size.height{
                                self?.iconImgView.snp.updateConstraints({ (maker) in
                                    maker.width.equalTo(50)
                                    maker.height.equalTo(50.0 * img.size.height / img.size.width)
                                })
                            }else{
                                self?.iconImgView.snp.updateConstraints({ (maker) in
                                    maker.height.equalTo(50)
                                    maker.width.equalTo(50.0 * img.size.width / img.size.height)
                                })
                            }
                        }else{
                            self?.iconImgView.snp.updateConstraints({ (maker) in
                                maker.width.equalTo(50)
                                maker.height.equalTo(50)
                            })
                        }
                        self?.iconImgView.image = img
                        self?.iconImgView.isHidden = false
                        self?.iconImgView.sp_cornerRadius(radius:CGFloat( codeModel.iconRadius / 4.0))
                    }
                }else{
                    sp_mainQueue {
                        self?.iconImgView.isHidden = true
                    }
                }
            }else{
                sp_mainQueue {
                    self?.iconImgView.isHidden = true
                }
            }
        }
        
        sp_sync { [weak self] in
            // 处理二维码
            var codeImg = SPQRCode.sp_create(qrCode: sp_getString(string: codeModel.content), size: CGSize(width: sp_screenWidth(), height: sp_screenWidth()))
            if let img = SPQRCodeDataModel.sp_codeOfBgImg(codeModel: codeModel, originalImg: codeImg){
                codeImg = img
            }else{
                if let img = SPQRCodeDataModel.sp_codeOfColor(codeModel: codeModel, originalImg: codeImg){
                    codeImg = img
                }
            }
            sp_mainQueue {
                self?.qrCodeImgView.image = codeImg
            }
        }
        
        if sp_getString(string: codeModel.text).count > 0 || self.isShow {
            self.titleLabel.isHidden = false
            sp_addConstraint(isTop: codeModel.textAlignment == 0 ? true : false , isValue: true)
            self.titleLabel.text = sp_getString(string: codeModel.text)
            if self.isShow && sp_getString(string: codeModel.text).count == 0 {
                self.titleLabel.text = SPLanguageChange.sp_getString(key: "click_to_enter_text")
            }
            if sp_getString(string: codeModel.textColorHex).count > 0 {
                self.titleLabel.textColor = SPColorForHexString(hex: sp_getString(string: codeModel.textColorHex))
            }else{
                self.titleLabel.textColor = SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue)
            }
            if sp_getString(string: codeModel.fontName).count > 0 {
                self.titleLabel.font = UIFont(name: sp_getString(string: codeModel.fontName), size: CGFloat(codeModel.fontSize))
            }else{
                self.titleLabel.font = sp_fontSize(fontSize: CGFloat(codeModel.fontSize))
            }
            
        }else{
            self.titleLabel.isHidden = true
            sp_addConstraint(isTop: true, isValue: false)
        }
        if self.isShow {
            self.titleLabel.sp_border(color: SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue), width: sp_scale(value: 1))
            self.titleLabel.sp_cornerRadius(radius: 5)
        }else{
            self.titleLabel.sp_border(color: nil, width: sp_scale(value: 0))
            self.titleLabel.sp_cornerRadius(radius: 0)
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.backgroundColor = UIColor.white
        self.addSubview(self.titleLabel)
        self.addSubview(self.qrCodeImgView)
        self.qrCodeImgView.addSubview(self.iconImgView)
        self.sp_addConstraint()
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(50)
            maker.height.equalTo(50)
            maker.centerX.equalTo(self.qrCodeImgView.snp.centerX).offset(0)
            maker.centerY.equalTo(self.qrCodeImgView.snp.centerY).offset(0)
        }
    }
    /// 添加约束
    fileprivate func sp_addConstraint(isTop : Bool = false,isValue : Bool = false){
        self.titleLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self).offset(5)
            maker.right.equalTo(self).offset(-5)
            maker.height.equalTo(isValue ? 80 : 0)
            if isTop{
                maker.top.equalTo(self).offset(isValue  ? 5 : 0)
            }else{
                maker.top.equalTo(self.qrCodeImgView.snp.bottom).offset(isValue ? 5 : 0)
                maker.bottom.equalTo(self.snp.bottom).offset(isValue ? -5 : 0)
            }
        }
        self.qrCodeImgView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(self.qrCodeImgView.snp.width).offset(0)
            if isTop {
                maker.top.equalTo(self.titleLabel.snp.bottom).offset(isValue ? 5 : 0)
                maker.bottom.equalTo(self.snp.bottom).offset(0)
            }else{
                maker.top.equalTo(self).offset(0)
            }
        }
    }
    deinit {
        
    }
}
extension SPQRCodeView {
    
    @objc fileprivate func sp_clickLabel(){
        guard self.isShow else {
            return
        }
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    
}
