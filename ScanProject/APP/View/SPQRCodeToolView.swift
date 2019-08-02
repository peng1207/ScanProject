//
//  SPQRCodeToolView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/31.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPQRCodeToolView:  UIView{
    
    fileprivate var collectionView : UICollectionView!
    fileprivate lazy var dataArray : [SPIndexModel] = {
        var list = [SPIndexModel]()
        list.append(SPIndexModel.sp_init(type: .icon))
        list.append(SPIndexModel.sp_init(type: .text))
        list.append(SPIndexModel.sp_init(type: .color))
        list.append(SPIndexModel.sp_init(type: .baseMap))
        return list
    }()
    fileprivate let cellID = "QRCodeToolCellID"
    var selectBlock : SPBtnTypeComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
//        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPQRCodeToolCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.collectionView)

        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPQRCodeToolView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPQRCodeToolCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPQRCodeToolCollectionCell
        if indexPath.row < sp_count(array: self.dataArray) {
            let model = self.dataArray[indexPath.row]
            cell.model = model
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.sp_width() - 20 - 15 ) / 4.0
        return CGSize(width: w, height: collectionView.sp_height())
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array: self.dataArray) {
            sp_dealSelect(model: self.dataArray[indexPath.row])
        }
    }
    fileprivate func sp_dealSelect(model : SPIndexModel?){
        guard let indexModel = model else {
            return
        }
        guard let block = self.selectBlock else {
            return
        }
        block(indexModel.type)
    }
}
class SPQRCodeToolCollectionCell: UICollectionViewCell {
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = sp_fontSize(fontSize: 13)
        return label
    }()
    var model : SPIndexModel? {
        didSet{
            self.sp_setupData()
        }
    }
    var isSelect : Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        if  self.isSelect , let img = self.model?.selectImg {
            self.iconImgView.image = img
            self.titleLabel.textColor = SPColorForHexString(hex: SPHexColor.color_2a96fd.rawValue)
        }else{
             self.iconImgView.image = self.model?.img
            self.titleLabel.textColor = SPColorForHexString(hex: SPHexColor.color_ffffff.rawValue)
        }
       
        self.titleLabel.text = sp_getString(string: self.model?.title)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.iconImgView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(25)
            maker.height.equalTo(25)
            maker.top.equalTo(self.contentView).offset(5)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(5)
            maker.right.equalTo(self.contentView).offset(-5)
            maker.top.equalTo(self.iconImgView.snp.bottom).offset(5)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
