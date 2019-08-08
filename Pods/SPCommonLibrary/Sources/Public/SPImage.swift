//
//  SPImage.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/4/4.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// 颜色转图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 转换的图片大小
    /// - Returns: 图片
    class func sp_image(color:UIColor,size : CGSize = CGSize(width: 1, height: 1)) ->UIImage?{
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /// view转图片
    ///
    /// - Parameter view: 需要转换的view
    /// - Returns: 图片
    class func sp_image(view : UIView)->UIImage?{
        let saveFrame = view.frame
        var saveContentOffset : CGPoint = CGPoint.zero
        var isScroll = false
        if view is UIScrollView {
            isScroll = true
        }
        /// 若view 是scrollview 则生成图片为 contentSize
        if isScroll , let scrollView = view as? UIScrollView {
            UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, true, UIScreen.main.scale)
            saveContentOffset = scrollView.contentOffset
            scrollView.contentOffset = CGPoint.zero
            scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        }else{
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        }
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        if isScroll {
            view.frame = saveFrame
            (view as! UIScrollView).contentOffset = saveContentOffset
        }
        UIGraphicsEndImageContext()
        return img
    }
    /// 对视频图片或拍照图片进行处理 防止旋转不对
    ///
    /// - Parameter imgae: 需要处理的图片
    /// - Returns: 处理后的图片
    class func sp_picRotating(imgae:CIImage?) -> CIImage? {
        guard let outputImage = imgae else {
            return nil
        }
        let orientation = UIDevice.current.orientation
        var t: CGAffineTransform!
        if orientation == UIDeviceOrientation.portrait {
            t = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2.0))
        } else if orientation == UIDeviceOrientation.portraitUpsideDown {
            t = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2.0))
        } else if (orientation == UIDeviceOrientation.landscapeRight) {
            t = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        } else {
            t = CGAffineTransform(rotationAngle: 0)
        }
        return  outputImage.transformed(by: t)
    }
    /// 给图片添加文字
    ///
    /// - Parameters:
    ///   - inputImg: 输入图片
    ///   - text: 文字
    ///   - font: 文字大小
    ///   - textColor: 文字颜色
    ///   - point: 添加文字的位置
    /// - Returns:  添加文字之后的图片
    class func sp_drawText(inputImg:UIImage,text : String, font : UIFont = UIFont.systemFont(ofSize: 14),textColor : UIColor = UIColor.white,point:CGPoint = CGPoint(x: 0, y: 0))->UIImage?{
        
        if text.count > 0 {
            let size = inputImg.size
            UIGraphicsBeginImageContext(size)
            inputImg.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let textAttributes = [ NSAttributedString.Key.foregroundColor: textColor ,NSAttributedString.Key.font : font]
            
            let textSize = NSString(string: text).size(withAttributes: textAttributes)
            let textFrame = CGRect(x: point.x, y: point.y, width: textSize.width, height: textSize.height)
            NSString(string: text).draw(in: textFrame, withAttributes: textAttributes)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }else{
            return inputImg
        }
    }
    /// 给图片添加文字
    ///
    /// - Parameters:
    ///   - inputImg: 输入图片
    ///   - text: 文字
    ///   - font: 文字大小
    ///   - textColor: 文字颜色
    ///   - point: 添加文字的位置
    /// - Returns:  添加文字之后的图片
    class func sp_drawText(inputImg : CIImage,text : String, font : UIFont = UIFont.systemFont(ofSize: 14),textColor : UIColor = UIColor.white,point:CGPoint = CGPoint(x: 0, y: 0))->CIImage?{
        let image = UIImage(ciImage: inputImg)
        let outputImg = sp_drawText(inputImg: image, text: text, font: font, textColor: textColor,point: point)
        if let outImg = outputImg, let outCIImg = CIImage(image: outImg) {
            return outCIImg
        }
        return  inputImg
    }
    /// 给图片添加文字
    ///
    /// - Parameters:
    ///   - inputImg: 输入图片
    ///   - text: 文字
    ///   - font: 文字大小
    ///   - textColor: 文字颜色
    ///   - point: 添加文字的位置
    /// - Returns:  添加文字之后的图片
    class func sp_drawText(inputImg : CGImage,text : String, font : UIFont = UIFont.systemFont(ofSize: 14),textColor : UIColor = UIColor.white,point:CGPoint = CGPoint(x: 0, y: 0))->CGImage?{
        let image = UIImage(cgImage: inputImg)
        let outputImg = sp_drawText(inputImg: image, text: text, font: font, textColor: textColor,point:point)
        if let outImg = outputImg, let outCGImg = outImg.cgImage {
            return outCGImg
        }
        return  inputImg
    }
    /// 生成高清图片
    ///
    /// - Parameters:
    ///   - image: 需要生成的图片
    ///   - size: 需要生成的大小
    /// - Returns: 图片 转换不成功则返回传进来的图片
    class func sp_highImg(image : CIImage,size : CGSize) ->UIImage?{
        let integral : CGRect = image.extent.integral
        let proportion : CGFloat = min(size.width / integral.width, size.height / integral.height)
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceGray()
        if let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0) {
            let context = CIContext(options: nil)
            if  let bitmapImage : CGImage = context.createCGImage(image, from: integral) {
                bitmapRef.interpolationQuality = .none
                bitmapRef.scaleBy(x: proportion, y: proportion)
                bitmapRef.draw(bitmapImage, in: integral)
                if  let img : CGImage = bitmapRef.makeImage() {
                    return UIImage(cgImage: img)
                }
            }
        }
        return UIImage(ciImage: image)
    }
    /// 图片切圆角
    ///
    /// - Parameters:
    ///   - size: 图片大小
    ///   - fillColor: 裁切区填充颜色
    /// - Returns: 圆角图片
    func sp_cornetImg(size : CGSize ,fillColor : UIColor = UIColor.white)->UIImage{
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        fillColor.setFill()
        UIRectFill(rect)
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        self.draw(in: rect)
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = resultImg {
            return img
        }
        return self
    }
    /// 更改图片的颜色
    ///
    /// - Parameters:
    ///   - tintColor: 颜色
    ///   - blendMode: 类型
    /// - Returns: 更改后的图片
    func sp_image(tintColor : UIColor,blendMode:CGBlendMode)->UIImage{
        UIGraphicsBeginImageContext(self.size)
        tintColor.setFill()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(rect)
        self.draw(in: rect, blendMode: blendMode, alpha: 1.0)
        if blendMode != .destinationIn {
            self.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        }
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = resultImg {
            return img
        }
        return self
    }
    /// 给图片添加中间icon图片
    ///
    /// - Parameters:
    ///   - centerImg: 中间icon图片
    ///   - iconSize: 展示在中间icon的大小
    /// - Returns: 转换后的图片
    func sp_image(centerImg : UIImage?,iconSize:CGSize)->UIImage{
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        if let icon = centerImg {
            let x = (self.size.width - iconSize.width) * 0.5
            let y = (self.size.height - iconSize.height) * 0.5
            icon.draw(in: CGRect(x: x, y: y, width: iconSize.width, height: iconSize.height))
        }
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = newImg {
              return img
        }
        return self
    }
    /// 获取指定size的图片
    ///
    /// - Parameter size: 指定的size
    /// - Returns: 转换后的图片
    func sp_resizeImg(size : CGSize)->UIImage?{
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    /// 压缩图片
    ///
    /// - Parameters:
    ///   - maxImageLenght: 最大的尺寸
    ///   - maxSizeKB: 最大的大小
    /// - Returns: 转换后的图片
    func sp_resizeImg(maxImageLenght : CGFloat, maxSizeKB : CGFloat = 1024)->UIImage{
        var maxSize = maxSizeKB
        var maxImgSize = maxImageLenght
        if maxSize <= 0.0 {
            maxSize = 1024.0
        }
        if maxImgSize <= 0.0 {
            maxImgSize = 1024.0
        }
        var newSize = CGSize(width: self.size.width, height: self.size.height)
        let tempHeight = newSize.height / maxImgSize
        let tempWidth = newSize.width / maxImgSize
        if tempWidth > 1.0 && tempWidth > tempHeight{
            newSize = CGSize(width: self.size.width / tempWidth, height: self.size.height / tempWidth)
        }else{
             newSize = CGSize(width: self.size.width / tempHeight, height: self.size.height / tempHeight)
        }
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = newImg {
            var  imageData =  img.jpegData(compressionQuality: 1.0)
            var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
            //调整大小
            var resizeRate = 0.9;
            
            while (sizeOriginKB > maxSize && resizeRate > 0.1) {
              
                imageData = img.jpegData(compressionQuality: CGFloat(resizeRate))
                
                sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
                
                resizeRate -= 0.1;
                
            }
            if let data = imageData {
                if let newImage = UIImage(data: data){
                    return newImage
                }
            }
        }
        
        return self
    }
    /// 获取jpeg的data
    ///
    /// - Returns: data
    func sp_jpegData()-> Data?{
        return  self.jpegData(compressionQuality: 1.0)
    }
    /// 图片逆时针旋转90
    ///
    /// - Returns: 新的图片
    func sp_roate()->UIImage?{
        if let cgImg = self.cgImage {
            var newOrientation  = UIImage.Orientation.up
            if self.imageOrientation == .up {
                newOrientation = .left
            }else if self.imageOrientation == .left {
                newOrientation = .down
            }else if self.imageOrientation == .down {
                newOrientation = .rightMirrored
            }
            
            return UIImage(cgImage: cgImg, scale: self.scale, orientation: newOrientation)
        }
        return self
    }
    /// 裁剪图片
    ///
    /// - Parameter newFrame: 需要裁剪图片在当前图片的位置
    /// - Returns: 裁剪后的图片
    func sp_scaled(newFrame : CGRect)-> UIImage{
        if let cgImg = self.cgImage {
            if let newCgImg = cgImg.cropping(to: newFrame) {
                 let newImg = UIImage(cgImage: newCgImg)
                    return newImg
            }
        }
        return self
    }
}
