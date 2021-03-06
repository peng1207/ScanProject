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

class SPScanManager : NSObject,AVCaptureMetadataOutputObjectsDelegate,AVCapturePhotoCaptureDelegate,AVCaptureVideoDataOutputSampleBufferDelegate{
    let captureSession : AVCaptureSession = AVCaptureSession()
    fileprivate var videoCaptureDev : AVCaptureDevice?
    fileprivate var noAuthBlock : SPNoAuthComplete?
    fileprivate var scanSuccessBlock : SPScanSuccess?
    fileprivate var previewLayer : AVCaptureVideoPreviewLayer?
    ///  外部传入的数据
    ///
    /// - Parameters:
    ///   - layer: 展示的数据的layer
    ///   - noAuth: 没有权限的回调
    ///   - success: 扫描数据成功的回调
    func sp_init(layer : AVCaptureVideoPreviewLayer?,noAuth : SPNoAuthComplete?,success:SPScanSuccess?){
        self.previewLayer = layer
        self.noAuthBlock = noAuth
        self.scanSuccessBlock = success
        // 判断有没相机权限
        SPAuthorizatio.sp_isCamera { [weak self](success)in
            if (success){
                self?.sp_setup()
            }else{
                self?.sp_dealNoAuth()
            }
        }
    }
    /// 处理没有权限回调
    fileprivate func sp_dealNoAuth(){
        guard let block = self.noAuthBlock else {
            return
        }
        block()
    }
    /// 处理扫描成功的回调
    ///
    /// - Parameter data: 扫描到的数据
    fileprivate func sp_dealSuccess(data :[String]){
         sp_log(message: data)
        guard let block = self.scanSuccessBlock else {
            return
        }
        block(data)
    }
    /// 初始化输入端和输出端
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
              metadataOutput.metadataObjectTypes = [.qr]
        }else{
            return
        }
       let videoDataOutput = AVCaptureVideoDataOutput()
        if captureSession.canAddOutput(videoDataOutput) {
         
            videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(videoDataOutput)
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
    /// 开启扫描
    func sp_start(){
        if !self.captureSession.isRunning {
            sp_sync {
                self.captureSession.startRunning()
            }
        }
    }
    /// 停止扫描
    func sp_stop(){
        if self.captureSession.isRunning{
            self.captureSession.stopRunning()
        }
    }
    ///   闪光灯设置
    ///
    /// - Returns: 闪光灯 打开或失败 true 打开 false 关闭
      func sp_flash()->Bool{
        guard let currentDevice = self.videoCaptureDev else {
            return false
        }
        if currentDevice.position == AVCaptureDevice.Position.front {
            return false
        }
        if currentDevice.torchMode == AVCaptureDevice.TorchMode.off {
            return sp_flashOn()
        }else{
            return sp_flashOff()
        }
    }
    ///   打开闪光灯
    ///
    /// - Returns: 打开闪光灯
    func sp_flashOn()->Bool{
        guard let currentDevice = self.videoCaptureDev else {
            return false
        }
        if !currentDevice.hasTorch {
            return false
        }
        sp_changeDeviceProperty(device: currentDevice) {
            if currentDevice.torchMode ==  AVCaptureDevice.TorchMode.off {
                currentDevice.torchMode =  AVCaptureDevice.TorchMode.on
            }
        }
        return true
    }
    /// 关闭闪关灯
    ///
    /// - Returns: false 关闭闪关灯
    @discardableResult func sp_flashOff()->Bool{
        guard let currentDevice = self.videoCaptureDev else {
            return false
        }
        
        if !currentDevice.hasTorch {
            return false
        }
        
        sp_changeDeviceProperty(device: currentDevice) {
            if currentDevice.torchMode ==  AVCaptureDevice.TorchMode.on {
                currentDevice.torchMode =  AVCaptureDevice.TorchMode.off
            }
            
        }
        return false
    }
    private func sp_changeDeviceProperty(device : AVCaptureDevice,complete : ()->Void){
        do{
            try device.lockForConfiguration()
            complete()
            device.unlockForConfiguration()
        }catch _ {
            
        }
    }
    
    /// 扫描到数据的代理
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
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        let brightnessValue = SPSampleBuffer.sp_brightness(sampleBuffer: sampleBuffer)
//        if brightnessValue <= 0  {
//            // 光线太暗
//        }else{
//
//        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        sp_log(message: resolvedSettings)
    }
}

