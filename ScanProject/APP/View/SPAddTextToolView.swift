//
//  SPAddTextToolView.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/2.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SPCommonLibrary
class SPAddTextToolView:  UIView{
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "addTextCellID"
    fileprivate lazy var dataList : [SPIndexModel] = {
        var list = [SPIndexModel]()
        list.append(SPIndexModel.sp_init(type: .color))
        list.append(SPIndexModel.sp_init(type: .fontName))
        list.append(SPIndexModel.sp_init(type: .fontSize))
        return list
    }()
    var selectModel : SPIndexModel?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var selectBlock : SPBtnTypeComplete?
    fileprivate lazy var topLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return view
    }()
    fileprivate lazy var bottomLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return view
    }()
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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(SPQRCodeToolCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.collectionView)
        self.addSubview(self.topLineView)
        self.addSubview(self.bottomLineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.topLineView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(sp_scale(value: 1))
        }
        self.bottomLineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_scale(value: 1))
        }
    }
    deinit {
        
    }
}
extension SPAddTextToolView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array: self.dataList) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array: self.dataList)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPQRCodeToolCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPQRCodeToolCollectionCell
        if indexPath.row < sp_count(array: self.dataList) {
            let model = self.dataList[indexPath.row]
            if let select = self.selectModel {
                if select.type == model.type {
                    cell.isSelect = true
                }else{
                    cell.isSelect = false
                }
            }else{
                cell.isSelect = false
            }
            
            cell.model = model
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.sp_width() / 3.0
        return CGSize(width: w, height: collectionView.sp_height())
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array: self.dataList) {
            let model = self.dataList[indexPath.row]
            self.selectModel = model
            sp_dealSelect(type: model.type)
        }
    }
    fileprivate func sp_dealSelect(type : SPBtnType){
        guard let block = self.selectBlock else {
            return
        }
        block(type)
    }
}
