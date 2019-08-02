//
//  SPQRCodeModel.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/29.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation

class SPQRCodeModel: SPBaseModel {
    /// 二维码内容
    var content : String?
    /// 二维码ID
    var id : String?
    /// 二维码来源 扫描、生成
    var sourceType : String?
    /// 二维码图片的二进制
    var codeImgData : Data?
    /// 中间icon的二进制
    var iconData : Data?
    /// icon的半径 默认0
    var iconRadius: Float = 0
    /// 背景图片的二进制
    var bgImgData : Data?
    /// 文本内容
    var text : String?
    /// 文本的位置 默认1  (0 顶部 1 底部 )
    var textAlignment : Int = 1
    /// 字体大小 默认为15
    var fontSize : Float = 15
    /// 字体颜色
    var textColorHex : String?
    /// 字体样式
    var fontName : String?
    /// 二维码图片颜色值 彩码
    var mainColorHex : String?
    /// 二维码背景颜色
    var bgColorHex : String?
    /// 二维码背景颜色的Alpha 默认1 
    var bgColorAlpha : Float = 1
}
