//
//  SPScanResultVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/1.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
import WebKit

class SPScanResultVC: SPBaseVC {
    var codeModel : SPQRCodeModel?
    fileprivate lazy var webConfiguration : WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        
        return configuration
    }()
    fileprivate var webView : WKWebView?
    
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
        guard let model = self.codeModel else {
            return
        }
        let type = model.sp_getType()
        if type == .url {
            sp_setupWebView()
        }else if type == .businessCard {
            sp_setupBusinessCard()
        }else if type == .wifi {
            sp_setupWifi()
        }else {
            sp_setupOther()
        }
    }
    override func sp_clickBack() {
        if let model = self.codeModel {
            if model.sp_getType() == .url{
                if let web = self.webView {
                    if web.canGoBack {
                        web.goBack()
                        return
                    }
                }
            }
        }
        super.sp_clickBack()
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "result")
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        if let web = self.webView {
            web.stopLoading()
            web.uiDelegate = nil
            web.navigationDelegate = nil
            web.scrollView.delegate = nil
            self.webView = nil
        }
    }
}
//MARK: - webview 处理
extension SPScanResultVC: WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler {
    
    fileprivate func sp_setupWebView(){
        self.webView = WKWebView(frame: CGRect.zero, configuration: self.webConfiguration)
        self.webView?.uiDelegate = self
        self.webView?.navigationDelegate = self
        self.webView?.scrollView.delegate = self
        self.webView?.allowsBackForwardNavigationGestures = true
        if #available(iOS 11.0, *) {
            self.webView?.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        if let web = self.webView {
            self.view.addSubview(web)
            web.snp.makeConstraints({ (maker) in
                maker.left.right.top.equalTo(self.view).offset(0)
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
                } else {
                    maker.bottom.equalTo(self.view.snp.bottom).offset(0)
                }
            })
        }
        if let u = URL(string: sp_getString(string: self.codeModel?.content)){
            self.webView?.load(URLRequest(url: u))
        }
    }
    //MARK: - WKNavigationDelegate
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    //接收到服务器跳转请求之后调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    //在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(WKNavigationActionPolicy.allow)
            return
        }
        sp_log(message: url)
        let urlscheme = sp_getString(string: url.scheme)
        let app = UIApplication.shared
        if urlscheme == "tel"{
            // 拨打电话
            app.open(url, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: nil)
            decisionHandler(.cancel)
        }else if urlscheme == "sms"{
            // 短信处理
            app.open(url, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: nil)
            decisionHandler(.cancel)
        }else if urlscheme == "mailto"{
            // 邮件
            app.open(url, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: nil)
            decisionHandler(.cancel)
        }else if urlscheme == "alipays" || urlscheme == "weixin" || urlscheme == "alipay" || sp_getString(string: url.absoluteString).hasSuffix("wechat_pay") {
            // 微信和支付宝
            app.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false], completionHandler: nil)
            decisionHandler(.allow)
        }else if sp_getString(string:
            navigationAction.request.url?.absoluteString).contains("itunes.apple.com") || sp_getString(string: navigationAction.request.url?.absoluteString).contains("apps.apple.com"){
            // 跳到appstore
            app.open(url, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: nil)
            decisionHandler(.cancel)
        }else{
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    //MARK: - WKUIDelegate
    // 输入框
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: prompt, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textFiled : UITextField) in
            textFiled.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "finish"), style: UIAlertAction.Style.default, handler: { (action : UIAlertAction) in
            var text = ""
            
            if  sp_count(array: alertController.textFields) > 0 {
                let textFiled : UITextField = alertController.textFields![0]
                text = textFiled.text!
            }
            completionHandler(text)
        }))
        sp_mainQueue { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
        
    }
    //确认框
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "cance"), style: UIAlertAction.Style.cancel, handler: { (action : UIAlertAction) in
            completionHandler(false)
        }))
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "done"), style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            completionHandler(true)
        }))
        sp_mainQueue { [weak self]in
            self?.present(alertController, animated: true, completion: nil)
        }
        
    }
    // 警告框
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: SPLanguageChange.sp_getString(key: "tips"), message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: SPLanguageChange.sp_getString(key: "done"), style: UIAlertAction.Style.default, handler: { (action:UIAlertAction) in
            completionHandler()
        }))
        sp_mainQueue { [weak self]in
            self?.present(alertController, animated: true, completion: nil)
        }
        
    }
    // 接收到html的回调
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
//MARK: - 名片
extension SPScanResultVC {
    fileprivate func sp_setupBusinessCard(){
        sp_setupOther()
    }
}
//MARK: - wifi
extension SPScanResultVC {
    fileprivate func sp_setupWifi(){
        sp_setupOther()
    }
}
//MARK: - 其他
extension SPScanResultVC {
    fileprivate func sp_setupOther(){
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        let label = UILabel()
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let attributedString = NSMutableAttributedString(string: sp_getString(string: self.codeModel?.sp_showContent()))
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle,NSAttributedString.Key.font : sp_fontSize(fontSize: 16),NSAttributedString.Key.foregroundColor : SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue)], range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        scrollView.addSubview(label)
        scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        label.snp.makeConstraints { (maker) in
            maker.left.equalTo(scrollView.snp.left).offset(10)
            maker.width.equalTo(scrollView.snp.width).offset(-20)
            maker.top.equalTo(scrollView).offset(10)
            maker.centerX.equalTo(scrollView.snp.centerX).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(scrollView.snp.bottom).offset(0)
        }
    }
}


