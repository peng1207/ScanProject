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
        self.iconImgView.isHidden = true
        if let codeData = codeModel.iconData {
            if let img = UIImage(data: codeData){
                self.iconImgView.image = img
                self.iconImgView.isHidden = true
                self.iconImgView.sp_cornerRadius(radius:CGFloat( codeModel.iconRadius))
            }
        }
        sp_sync { [weak self] in
            var codeImg = SPQRCode.sp_create(qrCode: sp_getString(string: codeModel.content), size: CGSize(width: sp_screenWidth(), height: sp_screenWidth()))
            
            if let bgData = codeModel.bgImgData , let img = codeImg {
                
//                let mainColor : UIColor
//                if sp_getString(string: codeModel.mainColorHex).count > 0 {
//                    mainColor = SPColorForHexString(hex: sp_getString(string: codeModel.mainColorHex))
//                }else{
//                    mainColor = UIColor.black
//                }
//                var bgColor : UIColor
//                if sp_getString(string: codeModel.bgColorHex).count > 0 {
//                    bgColor = SPColorForHexString(hex: sp_getString(string: codeModel.bgColorHex), alpha: CGFloat(codeModel.bgColorAlpha))
//                }else {
//                    bgColor = UIColor.white.withAlphaComponent(0)
//                }
//                let image : UIImage
//                if let i = SPQRCode.sp_color(color1: mainColor, bgColor: bgColor, image: img) {
//                    image = i
//                }else{
//                    image = img
//                }
                if let bgImg = UIImage(data: bgData){
                     codeImg = SPQRCode.sp_add(bgImg: bgImg, image: img)
                }
            }
            if let img = codeImg {
                let mainColor : UIColor
                if sp_getString(string: codeModel.mainColorHex).count > 0 {
                    mainColor = SPColorForHexString(hex: sp_getString(string: codeModel.mainColorHex))
                }else {
                    mainColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
                }
                let bgColor : UIColor
                if sp_getString(string: codeModel.bgColorHex).count > 0 {
                    bgColor = SPColorForHexString(hex: sp_getString(string: codeModel.bgColorHex), alpha: CGFloat(codeModel.bgColorAlpha))
                }else{
                    bgColor = SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue, alpha: CGFloat(codeModel.bgColorAlpha))
                }
                codeImg = SPQRCode.sp_color(color1: mainColor, bgColor: bgColor, image: img)
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
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.backgroundColor = UIColor.white
        self.addSubview(self.titleLabel)
        self.addSubview(self.qrCodeImgView)
        self.qrCodeImgView.addSubview(self.iconImgView)
        self.sp_addConstraint()
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 50, height: 50))
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
