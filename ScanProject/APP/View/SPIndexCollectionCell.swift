//
//  SPIndexCollectionCell.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/31.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPIndexCollectionCell: UICollectionViewCell {
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    var model : SPIndexModel? {
        didSet{
            self.sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.iconImgView.image = self.model?.img
        self.titleLabel.text = self.model?.title
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.backgroundColor = UIColor.black
        self.sp_cornerRadius(radius: 10)
        self.contentView.addSubview(self.iconImgView)
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.contentView).offset(0)
            maker.centerY.equalTo(self.contentView).offset(-10)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(5)
            maker.right.equalTo(self.contentView).offset(-5)
            maker.top.equalTo(self.iconImgView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
//            maker.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).offset(-5)
        }
    }
    deinit {
        
    }
}
