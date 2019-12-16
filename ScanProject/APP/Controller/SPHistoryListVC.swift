//
//  SPHistoryListVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/30.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary

class SPHistoryListVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate var dataList : [SPQRCodeModel]?
    var isAdd : Bool = true
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
         let queue = DispatchQueue(label: "historyQueue")
        queue.sync {  [weak self] in
            if let isA = self?.isAdd , isA == true {
                self?.dataList = SPDataBase.sp_getAddData()
            }else{
                self?.dataList = SPDataBase.sp_getScanData()
            }
            sp_mainQueue {
                self?.tableView.reloadData()
            }
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        self.tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.rowHeight = 60
        self.view.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        
    }
}
extension SPHistoryListVC : UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_count(array: self.dataList) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_count(array: self.dataList)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historyListCellID = "historyListCellID"
        var cell : SPHistoryListTableCell? = tableView.dequeueReusableCell(withIdentifier: historyListCellID) as? SPHistoryListTableCell
        if cell == nil {
            cell = SPHistoryListTableCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: historyListCellID)
            cell?.contentView.backgroundColor = self.view.backgroundColor
        }
        if indexPath.row < sp_count(array: self.dataList) {
            let model = self.dataList?[indexPath.row]
            cell?.qrCodeModel = model
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.row < sp_count(array: self.dataList) {
            let model = self.dataList?[indexPath.row]
            let qrCodeVC = SPQRCodeVC()
            qrCodeVC.qrCodeModel = SPQRCodeModel.sp_init(model: model)
            self.navigationController?.pushViewController(qrCodeVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete {
            if indexPath.row < sp_count(array: self.dataList) {
                if let model = self.dataList?[indexPath.row]{
                    SPDataBase.sp_delete(model: model)
                    self.dataList?.remove(object: model)
                    self.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

