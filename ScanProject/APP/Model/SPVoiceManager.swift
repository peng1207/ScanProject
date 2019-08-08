//
//  SPVoiceManager.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/1.
//  Copyright © 2019 shupenghuang. All rights reserved.
//
// 录音识别类

import Foundation
import Speech
import SPCommonLibrary

class SPVoiceManager : NSObject ,SFSpeechRecognizerDelegate {
    fileprivate var speecjRecognizer : SFSpeechRecognizer!
    fileprivate var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recognitionTask: SFSpeechRecognitionTask?
    fileprivate let audioEngine = AVAudioEngine()
    fileprivate var  isAuth : Bool = false
    fileprivate func sp_checkAuth(){
        SPAuthorizatio.sp_isRecord {   [weak self](auth) in
            self?.isAuth = auth
            if auth {
                // 语音转文字权限
                SPAuthorizatio.sp_isSpeech(authorizedBlock: { (success) in
                    self?.isAuth = success
                    if success {
                        self?.sp_sendSpeech()
                    }else{
                        
                    }
                })
            }else {
                
            }
        }
    }
    
    /// 初始化语音转换
    fileprivate func sp_sendSpeech(){
        speecjRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
        speecjRecognizer.delegate = self
    }
    
    /// 开启录制识别
    func sp_start(){
        guard self.isAuth else {
            sp_log(message: "没有权限")
            return
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        }catch {
            sp_log(message: "audioSession properties weren't set because of an error.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let rRequest = recognitionRequest else {
            sp_log(message: "Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        rRequest.shouldReportPartialResults = true
        recognitionTask = speecjRecognizer.recognitionTask(with: rRequest, resultHandler: { [weak self](result, error) in
            var isFinal = false
            if result != nil {
                sp_log(message: result?.bestTranscription.formattedString)
                sp_log(message: sp_getString(string: result?.isFinal))
                isFinal = result!.isFinal
                sp_mainQueue {
                    
                }
            }
            if error != nil || isFinal {
                self?.sp_stop()
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self](buffer, when) in
            self?.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        }catch {
            sp_log(message: "audioEngine couldn't start because of an error.")
        }
    }
    /// 停止录制识别
    func sp_stop(){
        guard self.isAuth else {
            sp_log(message: "没有权限")
            return
        }
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        if self.recognitionTask != nil {
            self.recognitionTask?.cancel()
        }
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        sp_log(message: "语音转换")
    }
}
