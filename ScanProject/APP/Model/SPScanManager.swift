//
//  SPScanManager.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/27.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import AVFoundation
import SPCommonLibrary

/// 扫描成功的回调
typealias SPScanSuccess = (_ data : [String])->Void
/// 没有权限的回调
typealias SPNoAuthComplete = ()->Void

class SPScanManager : NSObject,AVCaptureMetadataOutputObjectsDelegate{
    let captureSession : AVCaptureSession = AVCaptureSession()
    fileprivate var videoCaptureDev : AVCaptureDevice?
    fileprivate var noAuthBlock : SPNoAuthComplete?
    fileprivate var scanSuccessBlock : SPScanSuccess?
    fileprivate var previewLayer : AVCaptureVideoPreviewLayer?
    func sp_init(layer : AVCaptureVideoPreviewLayer?,noAuth : SPNoAuthComplete?,success:SPScanSuccess?){
        self.previewLayer = layer
        self.noAuthBlock = noAuth
        self.scanSuccessBlock = success
        // 判断有没相机权限
        SPAuthorizatio.isRightCamera { [weak self](success) in
            if (success){
                self?.sp_setup()
            }else{
                self?.sp_dealNoAuth()
            }
        }
    }
    /// 处理没有权限
    fileprivate func sp_dealNoAuth(){
        guard let block = self.noAuthBlock else {
            return
        }
        block()
    }
    /// 处理扫描成功的
    ///
    /// - Parameter data: 扫描到的数据
    fileprivate func sp_dealSuccess(data :[String]){
         sp_log(message: data)
        guard let block = self.scanSuccessBlock else {
            return
        }
        block(data)
    }
    
    fileprivate func sp_setup(){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        self.videoCaptureDev = videoCaptureDevice
        let videoInput : AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch {
            return
        }
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }else{
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue:  DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr,.code128,.ean13,.ean8,.code39,.code93]
        }else{
            return
        }
        
        sp_changeDeviceProperty {

          // 自动白平衡
//            if videoCaptureDevice.isWhiteBalanceModeSupported(AVCaptureDevice.WhiteBalanceMode.autoWhiteBalance) {
//                videoCaptureDevice.whiteBalanceMode = .autoWhiteBalance
//            }
            //自动对焦
//            if videoCaptureDevice.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus) {
//                videoCaptureDevice.focusMode = .autoFocus
//            }
//         自动曝光
//            if videoCaptureDevice.isExposureModeSupported(AVCaptureDevice.ExposureMode.autoExpose) {
//                videoCaptureDevice.exposureMode = .autoExpose
//            }
        }
        if let layer = self.previewLayer {
            layer.videoGravity = .resizeAspectFill
            layer.session = self.captureSession
        }
        
    }
    fileprivate func sp_changeDeviceProperty(complete : ()->Void){
        if let device = self.videoCaptureDev {
            do {
                try device.lockForConfiguration()
                complete()
                device.unlockForConfiguration()
                
            }catch {
                
            }
        }
    }
    
    func sp_start(){
        if !self.captureSession.isRunning {
            sp_sync {
                self.captureSession.startRunning()
            }
        }
    }
    func sp_stop(){
        if self.captureSession.isRunning{
            self.captureSession.stopRunning()
        }
      
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0  {
            sp_stop()
            var list = [String]()
            for object in  metadataObjects {
                if  let resultObject : AVMetadataMachineReadableCodeObject = object as? AVMetadataMachineReadableCodeObject {
                    let string = sp_getString(string: resultObject.stringValue)
                    if string.count > 0 {
                        list.append(string)
                    }
                }
            }
            self.sp_dealSuccess(data: list)
        }
        
    }
}

