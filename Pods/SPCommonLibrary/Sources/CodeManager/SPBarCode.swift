//
//  SPBarCode.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/9/28.
//  Copyright © 2019 huangshupeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
/// 条形码管理
public class SPBarCode {
    /// 创建条形码图片
    /// - Parameters:
    ///   - barCode: 条形码内容
    ///   - size: 条形码大小
    public class func sp_create(barCode : String , size : CGSize)->UIImage?{
        if let data = barCode.data(using: String.Encoding.ascii, allowLossyConversion: false), let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue(NSNumber(value: 0), forKey: "inputQuietSpace")
            if let outputImg = filter.outputImage, let colorFilter = CIFilter(name: "CIFalseColor"){
                colorFilter.setDefaults()
                colorFilter.setValue(outputImg, forKey: "inputImage")
                colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
                colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1, alpha: 0), forKey: "inputColor1")
                if let colorOutputImg = colorFilter.outputImage {
                   return UIImage.sp_highImg(image: colorOutputImg, size: size)
                }
            }
        }
        return nil
    }
    
}
