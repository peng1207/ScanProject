//
//  SPVoiceVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/29.
//  Copyright © 2019 shupenghuang. All rights reserved.
//
// 语音识别

import Foundation
import SnapKit
import Speech
import SPCommonLibrary
class SPVoiceVC: SPBaseVC {
    
    fileprivate var speecjRecognizer : SFSpeechRecognizer!
    fileprivate var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recognitionTask: SFSpeechRecognitionTask?
    fileprivate let audioEngine = AVAudioEngine()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_fontSize(fontSize:18)
        label.textColor = SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font =  sp_fontSize(fontSize:24)
        label.textColor = SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sp_clickContent)))
        return label
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = sp_fontSize(fontSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var microphoneBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "record"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "record"), for: UIControl.State.highlighted)
        btn.sp_cornerRadius(radius: 30)
        btn.sp_border(color: SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue), width: 1)
        btn.addTarget(self, action: #selector(sp_microphoneTapped), for: UIControl.Event.touchUpInside)
        btn.backgroundColor = SPColorForHexString(hex: SPHexColor.color_eeeeee.rawValue)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "public_select"), for: UIControl.State.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(sp_clickContent), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var animationView : UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var shapeLayer :  CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.cornerRadius = 30
        layer.masksToBounds = true
        layer.backgroundColor = SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue, alpha: 0.5).cgColor
        layer.frame = CGRect(x: (sp_screenWidth() - 60) / 2.0, y: (100.0 - 60.0 ) / 2.0, width: 60, height: 60)
        return layer
    }()
    fileprivate lazy var groupAnimation : CAAnimationGroup = {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(integerLiteral: 1)
        opacityAnimation.toValue = NSNumber(integerLiteral: 0)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSNumber(floatLiteral: 1.0)
        scaleAnimation.toValue = NSNumber(floatLiteral: 2.0)
        
        let group = CAAnimationGroup()
        group.animations = [opacityAnimation,scaleAnimation]
        group.duration = 1.5
        group.repeatCount = HUGE
//        group.autoreverses = true
        return group
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_checkAuth()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sp_stopRecord()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "voice")
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.contentLabel)
        self.view.addSubview(self.animationView)
        self.view.addSubview(self.microphoneBtn)
        self.view.addSubview(self.tipsLabel)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.doneBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.view).offset(20)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(12)
            maker.right.equalTo(self.view).offset(-12)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.microphoneBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
            maker.width.equalTo(60)
            maker.height.equalTo(60)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-20)
            }
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.greaterThanOrEqualTo(10)
            maker.right.lessThanOrEqualTo(-10)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
            maker.bottom.equalTo(self.microphoneBtn.snp.top).offset(-40)
        }
        self.animationView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
            maker.top.equalTo(self.microphoneBtn.snp.top).offset(-20)
        }
    }
    deinit {
        
    }
}
extension SPVoiceVC : SFSpeechRecognizerDelegate {
    fileprivate func sp_checkAuth(){
        SPAuthorizatio.sp_isRecord {   [weak self](auth) in
            if auth {
                // 语音转文字权限
                SPAuthorizatio.sp_isSpeech(authorizedBlock: { (success) in
                    if success {
                        self?.sp_sendSpeech()
                        self?.sp_startRecording()
                    }else{
                          self?.sp_dealNoSpeech()
                    }
                })
            }else {
                self?.sp_dealNoRecord()
            }
        }
    }
    /// 处理没有麦克风的权限
    fileprivate func sp_dealNoRecord(){
        let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "tips"), message: SPLanguageChange.sp_getString(key: "no_record_auth"), preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "go_to"), style: UIAlertAction.Style.default
            , handler: { (action) in
                sp_sysOpen()
        }))
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "cance"), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        sp_mainQueue {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    /// 处理没有语音转换权限
    fileprivate func sp_dealNoSpeech(){
        let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "tips"), message: SPLanguageChange.sp_getString(key: "no_speech_auth"), preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "go_to"), style: UIAlertAction.Style.default
            , handler: { (action) in
                sp_sysOpen()
        }))
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "cance"), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        sp_mainQueue {
            self.present(alertController, animated: true, completion: nil)
        }
      
    }
    
    /// 初始化语音转换
    fileprivate func sp_sendSpeech(){
        speecjRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
        speecjRecognizer.delegate = self
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        sp_log(message: "语音转换")
    }
    /// 开始录制
    fileprivate func sp_startRecording(){
       
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
                    self?.contentLabel.text = sp_getString(string: result?.bestTranscription.formattedString)
                }
            }
            if error != nil || isFinal {
                self?.sp_stopRecord()
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
        sp_startAnimation()
        sp_mainQueue {
             self.titleLabel.text = SPLanguageChange.sp_getString(key: "recognition_in_progress")
             self.tipsLabel.text = SPLanguageChange.sp_getString(key: "want_create_qrcode")
        }
       
    }
    /// 停止录制
    fileprivate func sp_stopRecord(){
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        if self.recognitionTask != nil {
            self.recognitionTask?.cancel()
        }
        self.recognitionRequest = nil
        self.recognitionTask = nil
        sp_mainQueue {
            self.sp_stopAnimation()
            self.titleLabel.text = SPLanguageChange.sp_getString(key: "stop_recognition")
            self.tipsLabel.text = SPLanguageChange.sp_getString(key: "click_voice_btn")
        }
    }
    /// 开启动画
    fileprivate func sp_startAnimation(){
        self.shapeLayer.add(self.groupAnimation, forKey: "recordAnimation")
        sp_mainQueue {
            if self.shapeLayer.superlayer == nil {
                  self.animationView.layer.insertSublayer(self.shapeLayer, at: 0)
            }
        }
    }
    /// 停止动画
    fileprivate func sp_stopAnimation(){
        sp_mainQueue {
            self.shapeLayer.removeAllAnimations()
        }
    }
   /// 点击录音
   @objc fileprivate func sp_microphoneTapped(){
        if self.audioEngine.isRunning {
            self.sp_stopRecord()
        }else{
            self.sp_startRecording()
        }
    }
    @objc fileprivate func sp_clickContent(){
        sp_log(message: "点击内容 跳到生成二维码界面 " + sp_getString(string: self.contentLabel.text))
        sp_stopRecord()
        if sp_getString(string: self.contentLabel.text).count <= 0  {
            // 请您说出需要转换的词语
            let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "tips")
                , message:SPLanguageChange.sp_getString(key: "want_create_qrcode") , preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "know"), style: UIAlertAction.Style.default, handler: { [weak self](action) in
                self?.sp_stopRecord()
                self?.sp_startRecording()
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let qrCodeModel = SPQRCodeModel()
        qrCodeModel.content = sp_getString(string: self.contentLabel.text)
        qrCodeModel.sourceType = K_QRCODE_SOURCETYPE_ADD
        let qrCodeVC = SPQRCodeVC()
        qrCodeVC.qrCodeModel = SPQRCodeModel.sp_deserialize(from:  SPDataBase.sp_save(model: qrCodeModel)?.sp_toJson())
        self.navigationController?.pushViewController(qrCodeVC, animated: true)
        
    }
}

