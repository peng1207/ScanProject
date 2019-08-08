//
//  SPQRCodeDataModel.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/5.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary
class SPQRCodeDataModel {

    /// 二维码背景图片的处理
    ///
    /// - Parameters:
    ///   - codeModel: 二维码数据模型
    ///   - originalImg: 原图
    /// - Returns: 加背景图片后的二维码 若返回nil则为生成二维码背景图片失败
    class func sp_codeOfBgImg(codeModel :SPQRCodeModel?,originalImg : UIImage?)->UIImage?{
        if let qrCodeModel = codeModel,let img = originalImg {
            if let bgData = qrCodeModel.bgImgData {
                if let bgImg = UIImage(data: bgData){
                    let mainColor : UIColor
                    if sp_getString(string: qrCodeModel.mainColorHex).count > 0 {
                        mainColor = SPColorForHexString(hex: sp_getString(string: qrCodeModel.mainColorHex))
                    }else {
                        mainColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
                    }
                   
                    let colorS = ["006600","009900", "00CC00","00FF00","336633","339933","33CC33","33FF33","99CC99","CCFFCC","003300"]
                    if colorS.contains(sp_getString(string: qrCodeModel.mainColorHex)){
                        if let newImg = SPQRCode.sp_color(color1:mainColor, bgColor: UIColor.blue, image: img) {
                            return SPQRCode.sp_add(bgImg: bgImg, image: newImg, minHueAngle: 239, maxHueAngle: 241)
                        }
                    }else{
                        if let newImg = SPQRCode.sp_color(color1:mainColor, bgColor: UIColor.green, image: img) {
                            return SPQRCode.sp_add(bgImg: bgImg, image: newImg, minHueAngle: 119, maxHueAngle: 121)
                        }
                    }
                }
            }
        }
        return nil
    }
    /// 更改二维码颜色
    ///
    /// - Parameters:
    ///   - codeModel: 二维码数据模型
    ///   - originalImg: 原图
    /// - Returns: 更改颜色后的二维码 若返回为nil则更改颜色不成功
    class func sp_codeOfColor(codeModel :SPQRCodeModel?,originalImg : UIImage?) -> UIImage?{
        if let qrCodeModel = codeModel,let img = originalImg {
            let mainColor : UIColor
            if sp_getString(string: qrCodeModel.mainColorHex).count > 0 {
                mainColor = SPColorForHexString(hex: sp_getString(string: qrCodeModel.mainColorHex))
            }else {
                mainColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
            }
            var bgColor : UIColor? = nil
            if sp_getString(string: qrCodeModel.bgColorHex).count > 0 {
                bgColor = SPColorForHexString(hex: sp_getString(string: qrCodeModel.bgColorHex), alpha: CGFloat(qrCodeModel.bgColorAlpha))
            }else{
                bgColor = SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue, alpha: CGFloat(qrCodeModel.bgColorAlpha))
            }
            return SPQRCode.sp_color(color1: mainColor, bgColor: bgColor, image: img)
        }
        return nil
    }
}
