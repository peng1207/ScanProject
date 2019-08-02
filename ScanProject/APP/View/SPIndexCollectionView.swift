//
//  SPIndexCollectionView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/31.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPIndexCollectionView:  UIView{
    var dataList : [SPIndexModel]!
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "SPIndexCollectionCellID"
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
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = SPColorForHexString(hex: SPHexColor.color_666666.rawValue)
        self.collectionView.register(SPIndexCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.bounces = false
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
extension SPIndexCollectionView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array: self.dataList) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array: self.dataList)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPIndexCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPIndexCollectionCell
        if indexPath.row < sp_count(array: self.dataList) {
            let model = self.dataList[indexPath.row]
            cell.model = model
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array: self.dataList){
            sp_dealSelect(model: self.dataList[indexPath.row])
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w =  Int((collectionView.sp_width() - 20  - 10 - 10 ) / 3.0)
        return CGSize(width: w, height: w)
    }
}
extension SPIndexCollectionView {
    
    /// 处理选择
    ///
    /// - Parameter model: 选中的数据源
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
