//
//  SPEnum.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/29.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation

/// 颜色的枚举
enum SPHexColor : String {
    case color_2a96fd   = "#2a96fd"
    case color_eeeeee = "#eeeeee"
    case color_333333 = "#333333"
    case color_666666 = "#666666"
    case color_999999 = "#999999"
    case color_000000 = "#000000"
    case color_ffffff = "#ffffff"
}

// 按钮类型
enum SPBtnType {
    /// 历史记录
    case history
    /// 创建二维码
    case createQRCode
    /// 更多
    case more
    /// 文本
    case text
    /// wifi
    case wifi
    /// 语音
    case voice
    /// 名片
    case businessCard
    /// 链接
    case url
    /// 颜色
    case color
    /// 底图
    case baseMap
    /// 图标
    case icon
    /// 字体大小 
    case fontSize
    /// 字体样式
    case fontName
    /// 相册
    case photo
    /// 相机
    case camera
}

