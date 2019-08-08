//
//  SPHistoryListTableCell.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/8.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPHistoryListTableCell: UITableViewCell {
    fileprivate lazy var cellView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SPHexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.font = sp_fontSize(fontSize: 14)
        return label
    }()
    fileprivate lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SPHexColor.color_999999.rawValue)
        label.textAlignment = NSTextAlignment.right
        label.font = sp_fontSize(fontSize: 14)
        return label
    }()
    var qrCodeModel : SPQRCodeModel?{
        didSet{
            self.sp_setupData()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.titleLabel.text = sp_getString(string: self.qrCodeModel?.sp_showContent())
        self.timeLabel.text = sp_getString(string: self.qrCodeModel?.showTime)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.cellView)
        self.cellView.addSubview(self.titleLabel)
        self.cellView.addSubview(self.timeLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.cellView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(5)
            maker.top.equalTo(self.contentView).offset(5)
            maker.right.equalTo(self.contentView).offset(-5)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.cellView).offset(5)
            maker.right.equalTo(self.cellView).offset(-5)
            maker.top.equalTo(self.cellView).offset(5)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.bottom.equalTo(self.cellView.snp.bottom).offset(-5)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
