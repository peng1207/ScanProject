//
//  SPQRCodeModel.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/29.
//  Copyright © 2019 shupenghuang. All rights reserved.
//
/// 字体在顶部
let K_FONT_TO_TOP = 0
/// 字体在底部
let K_FONT_TO_BOTTOM = 1

import Foundation
import SPCommonLibrary

public let K_QRCODE_SOURCETYPE_SCAN = "scan"
public let K_QRCODE_SOURCETYPE_ADD = "add"

class SPQRCodeModel: SPBaseModel {
    /// 二维码内容
    @objc dynamic var content : String?
    /// 二维码ID
    @objc dynamic var id : String?
    /// 二维码来源 扫描、生成
    @objc dynamic var sourceType : String?
    /// 二维码图片的二进制
    @objc dynamic var codeImgData : Data?
    /// 中间icon的二进制
    @objc dynamic var iconData : Data?
    /// icon的半径 默认0
    @objc dynamic var iconRadius: Float = 0
    /// 背景图片的二进制
    @objc dynamic var bgImgData : Data?
    /// 文本内容
    @objc dynamic var text : String?
    /// 文本的位置 默认1  (0 顶部 1 底部 )
    @objc dynamic var textAlignment : Int = 1
    /// 字体大小 默认为15
    @objc dynamic var fontSize : Float = 15
    /// 字体颜色
    @objc dynamic var textColorHex : String?
    /// 字体样式
    @objc dynamic var fontName : String?
    /// 二维码图片颜色值 彩码
    @objc dynamic var mainColorHex : String?
    /// 二维码背景颜色
    @objc dynamic var bgColorHex : String?
    /// 二维码背景颜色的Alpha 默认1 
    @objc dynamic var bgColorAlpha : Float = 1
    /// 创建的时间
    @objc dynamic var createTime : Date?
    /// 更新时间
    @objc dynamic var updateTime : Date?
    /// 展示的时间格式
    @objc dynamic var showTime : String?
    //重写 Object.primaryKey() 可以设置模型的主键。
    //声明主键之后，对象将被允许查询，更新速度更加高效，并且要求每个对象保持唯一性。
    //一旦带有主键的对象被添加到 Realm 之后，该对象的主键将不可修改。
    override static func primaryKey() -> String? {
        return "id"
    }
 
    
    class func sp_init(model : SPQRCodeModel?)->SPQRCodeModel?{
        if let m = model {
            let qrCodeModel = SPQRCodeModel.sp_deserialize(from: m.sp_toJson())
            qrCodeModel?.iconData = m.iconData
            qrCodeModel?.bgImgData = m.bgImgData
            qrCodeModel?.createTime = m.createTime
            qrCodeModel?.updateTime = m.updateTime
            return qrCodeModel
        }
        return  nil
    }
    
    /// 获取二维码类型
    ///
    /// - Returns: 类型
    func sp_getType()->SPBtnType{
        if sp_getString(string: self.content).hasPrefix("WIFI:") {
            // wifi名称
            return .wifi
        }else if sp_getString(string: self.content).hasPrefix("BEGIN:VCARD") , sp_getString(string: self.content).hasSuffix("END:VCARD"){
            // 名片
            return .businessCard
        }else if sp_getString(string: self.content).hasPrefix("http://") || sp_getString(string: self.content).hasPrefix("https://") {
            // 链接
            return .url
        }
        return .text
    }
    
    func sp_showContent()->String{
        var string = ""
        sp_log(message: self.content)
        switch sp_getType() {
        case .wifi:
            // 是wifi
            string = sp_getString(string: self.content)
            let list = string.components(separatedBy: ";")
            if list.count > 0 {
                string = ""
                for s in list {
                    if s.hasPrefix("WIFI:S:"){
                        // 名称
                        string.append(SPLanguageChange.sp_getString(key: "wifi_name") + ":" + sp_getString(string: s.components(separatedBy: ":").last))
                    }else if s.hasPrefix("T:"){
                        // 安全性
                        var value = sp_getString(string: s.components(separatedBy: ":").last)
                        if value == "nopass"{
                            value = SPLanguageChange.sp_getString(key: "no_pass")
                        }
                        string.append("\n" + SPLanguageChange.sp_getString(key: "security") + ":" + value)
                    }else if s.hasPrefix("P:"){
                        // 密码
                        string.append("\n" + SPLanguageChange.sp_getString(key: "pwd") + ":" + sp_getString(string: s.components(separatedBy: ":").last))
                    }
                }
            }
        case .businessCard:
            // 是名片
            string = sp_getString(string: self.content)
            let list =  string.components(separatedBy: "\n")
            var resultData = [String]()
            if sp_count(array: list) > 0 {
                for s in list {
                    string = ""
                    sp_log(message: s)
                    if s.hasPrefix("N:"){
                        // 名称
                        resultData.append(SPLanguageChange.sp_getString(key: "name") + ":" + sp_getString(string: s.components(separatedBy: ":").last))
                    }else if s.hasPrefix("EMAIL:"){
                        // 邮箱
                         resultData.append(SPLanguageChange.sp_getString(key: "email") + ":" + sp_getString(string: s.components(separatedBy: ":").last))
                    }else if s.hasPrefix("TEL;CELL:"){
                        // 手机号码
                         resultData.append(SPLanguageChange.sp_getString(key: "phone") + ":" + sp_getString(string: s.components(separatedBy: ":").last))
                    }else if s.hasPrefix("TEL:"){
                        // 电话号码
                         resultData.append(SPLanguageChange.sp_getString(key: "tel") + ":" + sp_getString(string: s.components(separatedBy: ":").last))
                    }else if s.hasPrefix("ADR;TYPE=WORK:"){
                        // 公司地址
                         resultData.append(SPLanguageChange.sp_getString(key: "company_address") + ":" + sp_getString(string: s.components(separatedBy: ":").last))
                    }else if s.hasPrefix("ORG:"){
                        // 公司名称
                         resultData.append(SPLanguageChange.sp_getString(key: "company") + ":" + sp_getString(string: s.components(separatedBy: ":").last))
                    }else if s.hasPrefix("TITLE:"){
                        // 职位
                        if resultData.count > 0 {
                             resultData.insert(SPLanguageChange.sp_getString(key: "position") + ":" + sp_getString(string: s.components(separatedBy: ":").last), at: 1)
                        }else{
                            resultData.append(SPLanguageChange.sp_getString(key: "position") + ":" + sp_getString(string: s.components(separatedBy: ":").last))
                        }
                       
                    }else if s.hasPrefix("NOTE:"){
                        // 备注
                         resultData.append(SPLanguageChange.sp_getString(key: "remarks") + ":" + sp_getString(string: s.components(separatedBy: ":").last))
                    }
                    
                }
                if resultData.count > 0 {
                    string = resultData.joined(separator: "\n")
                }
                
            }
           
        default:
            string = sp_getString(string: self.content)
        }
        
        return string
    }
    
}
