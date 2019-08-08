//
//  SPMoreVC.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/30.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SnapKit
import SPCommonLibrary
class SPMoreVC: SPBaseVC {
    fileprivate lazy var dataArray : [SPIndexModel] = {
        var list = [SPIndexModel]()
        list.append(SPIndexModel.sp_init(type: .share))
        list.append(SPIndexModel.sp_init(type: .score))
        return list
    }()
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellID = "moreCellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
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
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = SPLanguageChange.sp_getString(key: "more")
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.view.backgroundColor
//        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPIndexCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
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
extension SPMoreVC : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_count(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_count(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPIndexCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPIndexCollectionCell
        if indexPath.row < sp_count(array: self.dataArray) {
            let model = self.dataArray[indexPath.row]
            cell.model = model
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w =  Int((collectionView.sp_width() - 20  - 10 - 10 ) / 3.0)
        return CGSize(width: w, height: w)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_count(array: self.dataArray) {
             let model = self.dataArray[indexPath.row]
            sp_deal(type: model.type)
        }
    }
}
extension SPMoreVC{
    fileprivate func sp_deal(type : SPBtnType){
        switch type {
        case .share:
            sp_clickShare()
        case .score:
            sp_clickScore()
        default:
            sp_log(message: "没有其他")
        }
    }
    private func sp_clickShare(){
        let shareUrl = "https://apps.apple.com/cn/app/id1425477935"
        var list = [Any]()
        list.append(SPLanguageChange.sp_getString(key: "share"))
        
        if let logo = sp_appLogoImg(){
            list.append(logo)
        }
       list.append(shareUrl)
        SPShare.sp_share(shareData: list, vc: self)
    }
    private func sp_clickScore(){
        let urlString = "https://itunes.apple.com/cn/app/id1425477935?action=write-review";
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: nil)
            }
        }
        
    }
}
