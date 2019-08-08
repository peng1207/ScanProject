//
//  SPHistoryVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/27.
//  Copyright © 2019 shupenghuang. All rights reserved.
//
// 历史记录

import Foundation
import SnapKit
import SPCommonLibrary

class SPHistoryVC: SPBaseVC {
    fileprivate lazy var segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: [SPLanguageChange.sp_getString(key: "establish"),SPLanguageChange.sp_getString(key: "scan")])
        view.frame = CGRect(x: 0, y: 0, width: 160, height: 30)
        view.tintColor = UIColor.white
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(sp_clickSegment), for: UIControl.Event.valueChanged)
        return view
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var establishVC : SPHistoryListVC = {
        let vc = SPHistoryListVC()
        return vc
    }()
    fileprivate lazy var scanVC : SPHistoryListVC = {
        let vc = SPHistoryListVC()
        vc.isAdd = false
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_dealSelect(index: self.segmentedControl.selectedSegmentIndex)
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
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.titleView = self.segmentedControl
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.safeView)
        self.scrollView.addSubview(self.establishVC.view)
        self.scrollView.addSubview(self.scanVC.view)
        self.addChild(self.establishVC)
        self.addChild(self.scanVC)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.safeView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.scrollView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.view).offset(0)
            maker.left.right.equalTo(self.view).offset(0)
        }
        self.establishVC.view.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.scrollView).offset(0)
            maker.width.height.equalTo(self.scrollView).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.scanVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.establishVC.view.snp.right).offset(0)
            maker.top.width.height.equalTo(self.establishVC.view).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPHistoryVC {
    
    fileprivate func sp_dealSelect(index : Int){
        self.scrollView.contentOffset = CGPoint(x: self.scrollView.sp_width() * CGFloat(index), y: 0)
    }
    @objc fileprivate func sp_clickSegment(){
        self.sp_dealSelect(index: self.segmentedControl.selectedSegmentIndex)
    }
    
}
