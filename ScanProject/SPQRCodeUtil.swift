
//
//  SPQRCodeUtil.swift
//  SwiftDemo
//
//  Created by chengzong liang on 2018/12/14.
//  Copyright © 2018年 mediawin. All rights reserved.
//

import Foundation
import UIKit
class SPQRCodeUtil {
    
    class func sp_setQRCode(qrCode : String)->UIImage{
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        // 设置滤镜输入数据
        let data = qrCode.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        // 设置二维码的纠错率
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        
        // 从二维码滤镜里面, 获取结果图片
        var image = filter?.outputImage
        
        // 生成一个高清图片
        let transform = CGAffineTransform.init(scaleX: 20, y: 20)
        image = image?.transformed(by: transform)
            
        // 图片处理
        let resultImage = UIImage(ciImage: image!)
        return resultImage
    }
    // 使图片放大也可以清晰
    class func getClearImage(sourceImage: UIImage, center: UIImage) -> UIImage {
        
        let size = sourceImage.size
        // 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        // 绘制大图片
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 绘制二维码中心小图片
        let width: CGFloat = 80
        let height: CGFloat = 80
        let x: CGFloat = (size.width - width) * 0.5
        let y: CGFloat = (size.height - height) * 0.5
        center.draw(in: CGRect(x: x, y: y, width: width, height: height))
        
        // 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
 
}
