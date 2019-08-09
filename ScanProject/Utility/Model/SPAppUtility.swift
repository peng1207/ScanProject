//
//  SPAppUtility.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/30.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import AudioToolbox

/// 按钮点击回调 返回按钮的类型
typealias SPBtnTypeComplete = (_ type : SPBtnType)->Void
/// 点击回调 返回位置
typealias SPIndexComplete = (_ index : Int)->Void
/// 点击回调 不带参数
typealias SPClickComplete = ()->Void


/// 震动
func sp_shake(){
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
}
/// 增加震动效果，如果手机处于静音状态，提醒音将自动触发震动
func sp_ring(){
     AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
}
