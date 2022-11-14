//
//  SPSelectImgVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/1.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary

class SPSelectImgVC: SPBaseVC {
    var qrCodeModel : SPQRCodeModel?
    fileprivate lazy var qrCodeView : SPQRCodeView = {
        let view = SPQRCodeView()
        return view
    }()
    fileprivate lazy var toolView : SPSelectImgToolView = {
        let view = SPSelectImgToolView()
        view.selectBlock = { [weak self] (type)in
            self?.sp_dealSelect(type: type)
        }
        view.sliderView.valueBlock = { [weak self] (radius) in
            self?.sp_deal(radius: radius)
        }
        view.radiusBtn.isHidden = self.isBg ? true : false
        return view
    }()
    fileprivate lazy var selectBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_select"), for: UIControl.State.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.setImage(UIImage(named: "public_close"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(sp_clickBack), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var isBg : Bool = false
    var selectBlock : SPQRCodeComplete?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 赋值
    fileprivate func sp_setupData(){

        self.qrCodeView.model = self.qrCodeModel
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.canceBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.selectBtn)
        self.view.addSubview(self.qrCodeView)
        self.view.addSubview(self.safeView)
        self.view.addSubview(self.toolView)
        
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.qrCodeView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.equalTo(self.qrCodeView.snp.width).offset(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
        }
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.safeView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.view).offset(0)
            maker.top.equalTo(self.toolView.snp.top).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPSelectImgVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//         sp_log(message: info)
        picker.dismiss(animated: true) { [weak self] in
            let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            self?.sp_dealSelect(img: img)
        }
    }
    
 
    
}
extension SPSelectImgVC {
    /// 处理选择的类型
    ///
    /// - Parameter type: 类型
    fileprivate func sp_dealSelect(type : SPBtnType){
        switch type {
        case .photo:
            sp_clickPhoto()
        case .camera:
            sp_clickCamera()
        default:
            sp_log(message: "没有其他")
        }
    }
    
    /// 点击相机
    fileprivate func sp_clickCamera(){
        let imgPickerVC = UIImagePickerController()
        imgPickerVC.sourceType = .camera
        imgPickerVC.delegate = self
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    /// 点击相册
    fileprivate func sp_clickPhoto(){
        let imgPickerVC = UIImagePickerController()
        imgPickerVC.sourceType = .photoLibrary
        imgPickerVC.delegate = self
        imgPickerVC.modalPresentationStyle = .fullScreen
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    /// 裁剪图片
    ///
    /// - Parameter img: 图片
    fileprivate func sp_clip(img : UIImage?){
        let clipVC = SPClipImgVC()
        clipVC.originalImg = img?.fixOrientation()
        clipVC.clipBlock = { [weak self] (img , isCance) in
            self?.sp_dealClip(img: img, isCance: isCance)
        }
        clipVC.modalPresentationStyle = .fullScreen
        self.present(clipVC, animated: true, completion: nil)
    }
    @objc fileprivate func sp_clickDone(){
        guard let block = self.selectBlock else {
            sp_clickBack()
            return
        }
        block( SPDataBase.sp_save(model: self.qrCodeModel))
        sp_clickBack()
       
    }
    /// 处理获取到半径
    ///
    /// - Parameter radius: 半径
    fileprivate func sp_deal(radius : Float){
        self.qrCodeModel?.iconRadius = radius
        sp_setupData()
    }
    /// 处理选择图片之后的回调
    ///
    /// - Parameter img: 图片
    fileprivate func sp_dealSelect(img : UIImage?){
          sp_clip(img: img)
    }
    /// 处理裁剪回调
    ///
    /// - Parameters:
    ///   - img: 图片
    ///   - isCance: 是否点击取消
    fileprivate func sp_dealClip(img : UIImage?,isCance : Bool){
        if !isCance {
            if let image = img {
                if self.isBg {
                    if let newImg = image.sp_resizeImg(size: CGSize(width: sp_screenWidth(), height: sp_screenWidth())){
                        self.qrCodeModel?.bgImgData = newImg.sp_jpegData()
                    }
                }else{
                    self.qrCodeModel?.iconData = image.sp_jpegData()
                }
                sp_setupData()
            }
        }
    }
}


extension UIImage {
   // 修复图片旋转
   func fixOrientation() -> UIImage {
       if self.imageOrientation == .up {
           return self
       }
        
       var transform = CGAffineTransform.identity
        
       switch self.imageOrientation {
       case .down, .downMirrored:
           transform = transform.translatedBy(x: self.size.width, y: self.size.height)
           transform = transform.rotated(by: .pi)
           break
            
       case .left, .leftMirrored:
           transform = transform.translatedBy(x: self.size.width, y: 0)
           transform = transform.rotated(by: .pi / 2)
           break
            
       case .right, .rightMirrored:
           transform = transform.translatedBy(x: 0, y: self.size.height)
           transform = transform.rotated(by: -.pi / 2)
           break
            
       default:
           break
       }
        
       switch self.imageOrientation {
       case .upMirrored, .downMirrored:
           transform = transform.translatedBy(x: self.size.width, y: 0)
           transform = transform.scaledBy(x: -1, y: 1)
           break
            
       case .leftMirrored, .rightMirrored:
           transform = transform.translatedBy(x: self.size.height, y: 0);
           transform = transform.scaledBy(x: -1, y: 1)
           break
            
       default:
           break
       }
        
       let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
       ctx?.concatenate(transform)
        
       switch self.imageOrientation {
       case .left, .leftMirrored, .right, .rightMirrored:
           ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
           break
            
       default:
           ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
           break
       }
        
       let cgimg: CGImage = (ctx?.makeImage())!
       let img = UIImage(cgImage: cgimg)
        
       return img
   }
}
