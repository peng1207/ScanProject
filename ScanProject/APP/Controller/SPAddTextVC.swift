//
//  SPAddTextVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/2.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
class SPAddTextVC: SPBaseVC {
    
    var qrCodeModel : SPQRCodeModel?
    
    fileprivate lazy var textView : UITextView = {
        let view = UITextView()
        view.becomeFirstResponder()
        view.font = sp_fontSize(fontSize: 15)
        view.textColor = SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue)
        return view
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_close"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_select"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var toolView : SPAddTextToolView = {
        let view = SPAddTextToolView()
        view.backgroundColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
        view.selectBlock = { [weak self]  (type)in
            self?.sp_dealSelect(type: type)
        }
        return view
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var colorView : SPColorView = {
        let view = SPColorView()
        view.selectBlock = { [weak self] (colorHex) in
            self?.sp_deal(colorHex: colorHex)
        }
        return view
    }()
    fileprivate lazy var fontNameView : SPFontNameView = {
        let view = SPFontNameView()
        view.clickBlock = { [weak self] (name) in
            self?.sp_deal(fontName: name)
        }
        return view
    }()
    fileprivate lazy var fontSizeView : SPSliderView = {
        let view = SPSliderView()
        view.title = SPLanguageChange.sp_getString(key: "fontSize")
        view.valueBlock = { [weak self] (value) in
            self?.sp_deal(fontSize: value)
        }
        return view
    }()
    var selectBlock : SPQRCodeComplete?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
        sp_addNotification()
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
        if sp_getString(string: self.textView.text).count == 0 {
             self.textView.text = sp_getString(string: self.qrCodeModel?.text)
        }
        if let model = self.qrCodeModel {
            self.fontSizeView.value = model.fontSize
        }
        sp_setupAtt()
    }
    /// 设置属性
    fileprivate func sp_setupAtt(){
        if sp_getString(string: self.qrCodeModel?.textColorHex).count > 0 {
            self.textView.textColor = SPColorForHexString(hex: sp_getString(string: self.qrCodeModel?.textColorHex))
        }
        if let model = self.qrCodeModel {
            if sp_getString(string: model.fontName).count > 0 {
                self.textView.font = UIFont(name: sp_getString(string: model.fontName), size: CGFloat(model.fontSize))
            }else{
                self.textView.font = sp_fontSize(fontSize: CGFloat(model.fontSize))
            }
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.backgroundColor = SPColorForHexString(hex: SPHexColor.color_000000.rawValue)
        self.view.addSubview(self.canceBtn)
        self.view.addSubview(self.doneBtn)
        self.view.addSubview(self.textView)
        self.view.addSubview(self.toolView)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.colorView)
        self.scrollView.addSubview(self.fontNameView)
        self.scrollView.addSubview(self.fontSizeView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(0)
            maker.top.equalTo(self.view).offset(sp_statusBarHeight())
            maker.width.equalTo(80)
            maker.height.equalTo(44)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.view).offset(0)
            maker.width.height.top.equalTo(self.canceBtn).offset(0)
        }
        self.textView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.top.equalTo(self.canceBtn.snp.bottom).offset(0)
            maker.bottom.equalTo(self.toolView.snp.top).offset(-10)
        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.toolView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.colorView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.scrollView).offset(0)
            maker.width.height.equalTo(self.scrollView).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.fontNameView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.colorView.snp.right).offset(0)
            maker.top.width.height.equalTo(self.colorView).offset(0)
        }
        self.fontSizeView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.fontNameView.snp.right).offset(0)
            maker.top.width.height.equalTo(self.fontNameView).offset(0)
        }
    }
    fileprivate func sp_updateTool(height : CGFloat){
        self.toolView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(55)
            maker.bottom.equalTo(self.view.snp.bottom).offset(-height)
        }
    }
    deinit {
        
    }
}
extension SPAddTextVC {
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardShow(obj:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    @objc fileprivate func sp_keyboardShow(obj : Notification){
       let height = sp_getKeyBoardheight(notification: obj)
        sp_updateTool(height: height)
        self.toolView.selectModel = nil
    }
    
}
extension SPAddTextVC {
    @objc fileprivate func sp_clickCance(){
        sp_hideKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func sp_clickDone(){
        sp_clickCance()
        guard let block = self.selectBlock else {
            return
        }
        self.qrCodeModel?.text = sp_getString(string: self.textView.text)
        block(self.qrCodeModel)
    }
    /// 处理选择的tool
    ///
    /// - Parameter type: 点击类型
    fileprivate func sp_dealSelect(type : SPBtnType){
        switch type {
        case .color:
            sp_dealScrollView(index: 0)
        case .fontName:
            sp_dealScrollView(index: 1)
        case .fontSize:
            sp_dealScrollView(index: 2)
        default:
            sp_log(message: "没有其他")
        }
        sp_hideKeyboard()
    }
    /// 处理scrollview 的偏转
    ///
    /// - Parameter index: 点击的位置
    fileprivate func sp_dealScrollView(index : Int){
        self.scrollView.contentOffset = CGPoint(x: self.scrollView.sp_width() * CGFloat(index), y: 0)
    }
    /// 处理选择的颜色值
    ///
    /// - Parameter colorHex: 十六进制的颜色
    fileprivate func sp_deal(colorHex : String){
        self.qrCodeModel?.textColorHex = colorHex
        sp_setupAtt()
    }
    /// 处理字体样式
    ///
    /// - Parameter fontName: 样式名称
    fileprivate func sp_deal(fontName : String?){
        self.qrCodeModel?.fontName = fontName
        sp_setupAtt()
    }
    /// 处理选择的字体大小
    ///
    /// - Parameter fontSize: 大小
    fileprivate func sp_deal(fontSize : Float){
        self.qrCodeModel?.fontSize = fontSize
        sp_setupAtt()
    }
}
