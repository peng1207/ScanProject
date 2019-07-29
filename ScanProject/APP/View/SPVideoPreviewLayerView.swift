//
//  SPVideoPreviewLayerView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/27.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SnapKit
import SPCommonLibrary
class SPVideoPreviewLayerView: UIView {
    fileprivate var timer : Timer?
    
    fileprivate lazy var lineView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue)
        return view
    }()
    fileprivate lazy var scanView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ScanBox")
        return view
    }()
    fileprivate lazy var leftView : UIView = {
        return sp_setupMaskView()
    }()
    fileprivate lazy var rightView : UIView = {
        return sp_setupMaskView()
    }()
    fileprivate lazy var topView : UIView = {
        return sp_setupMaskView()
    }()
    fileprivate lazy var bottomView : UIView = {
        return sp_setupMaskView()
    }()
    fileprivate let lineHeight = 1.5
    
    fileprivate func sp_setupMaskView()->UIView{
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }
    
    
    override class var layerClass: Swift.AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        sp_setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setup(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(self.leftView)
        self.addSubview(self.topView)
        self.addSubview(self.rightView)
        self.addSubview(self.bottomView)
        self.addSubview(self.lineView)
        self.addSubview(self.scanView)
       
        sp_addConstraint()
    }
    fileprivate func sp_addConstraint(){
        self.leftView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.right.equalTo(self.scanView.snp.left).offset(0)
            maker.top.equalTo(self).offset(0)
            maker.bottom.equalTo(self).offset(0)
        }
        self.rightView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scanView.snp.right).offset(0)
            maker.right.equalTo(self).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
        }
        self.topView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(0)
            maker.bottom.equalTo(self.scanView.snp.top).offset(0)
            maker.left.equalTo(self.leftView.snp.right).offset(0)
            maker.right.equalTo(self.rightView.snp.left).offset(0)
        }
        self.bottomView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.topView).offset(0)
            maker.top.equalTo(self.scanView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        
        self.scanView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(50)
            maker.right.equalTo(self).offset(-50)
            maker.height.equalTo(self.scanView.snp.width).offset(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scanView).offset(0)
            maker.top.equalTo(self.scanView).offset(0)
            maker.height.equalTo(lineHeight)
        }
    }
    
    
}
extension SPVideoPreviewLayerView {
    
    func sp_startAnimation(){
        sp_startTimer()
    }
    func sp_stopAnimation(){
        sp_stopTimer()
    }
    
    fileprivate func sp_startTimer(){
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(sp_run), userInfo: nil, repeats: true)
        }
    }
    fileprivate func sp_stopTimer(){
        if let time = self.timer {
            if time.isValid {
                time.invalidate()
            }
            self.timer = nil
        }
    }
    @objc fileprivate func sp_run(){
        sp_lineAnimation()
    }
    fileprivate func sp_lineAnimation(){
 
        var y = self.lineView.sp_y()
        
        y = y + 5
        
        if y > self.scanView.sp_maxY() {
            y = self.scanView.sp_y()
        }else if y < self.scanView.sp_y() {
            y = self.scanView.sp_y()
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.lineView.frame = CGRect(x: self.lineView.sp_x(), y: y, width: self.lineView.sp_width(), height: self.lineView.sp_height())
        }) { (finish) in
          
        }
    }
    
}
