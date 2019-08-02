//
//  SPIndexModel.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/31.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SPCommonLibrary
class SPIndexModel : SPBaseModel{
 
    var type : SPBtnType = .text
    var title : String?
    var img : UIImage?
    var selectImg : UIImage?
    class func sp_init(type : SPBtnType) -> SPIndexModel {
        let model = SPIndexModel()
        model.type = type
        switch model.type {
        case .text:
            model.title = SPLanguageChange.sp_getString(key: "text")
            model.img = UIImage(named: "public_text")
        case .businessCard:
            model.title = SPLanguageChange.sp_getString(key: "visiting_card")
            model.img = UIImage(named: "public_card")
        case .url :
            model.title = SPLanguageChange.sp_getString(key: "website")
            model.img = UIImage(named: "public_http")
        case .wifi:
            model.title = SPLanguageChange.sp_getString(key: "wifi")
            model.img = UIImage(named: "public_wifi")
        case .voice:
            model.title = SPLanguageChange.sp_getString(key: "voice")
            model.img = UIImage(named: "public_voice")
        case .color:
            model.title = SPLanguageChange.sp_getString(key: "color")
            model.img = UIImage(named: "public_color")
            model.selectImg = UIImage(named: "public_color_select")
        case .baseMap:
            model.title = SPLanguageChange.sp_getString(key: "base_map")
            model.img = UIImage(named: "public_baseMap")
        case .icon:
            model.title = SPLanguageChange.sp_getString(key: "icon")
            model.img = UIImage(named: "public_baseMap")
        case .fontSize :
            model.title = SPLanguageChange.sp_getString(key: "font_size")
            model.img = UIImage(named: "public_fontsize")
            model.selectImg = UIImage(named: "public_fontsize_select")
        case .fontName:
            model.title = SPLanguageChange.sp_getString(key: "font_name")
            model.img = UIImage(named: "public_fontname")
            model.selectImg = UIImage(named: "public_fontname_select")
        case .photo:
            model.title = SPLanguageChange.sp_getString(key: "album")
            model.img = UIImage(named: "public_album")
        case .camera:
            model.title = SPLanguageChange.sp_getString(key: "camera")
            model.img = UIImage(named: "public_camera")
        default:
            sp_log(message: "没有其他")
        }
        return model
    }
    
}
