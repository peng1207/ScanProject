//
//  SPDataBase.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/8/7.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import SPCommonLibrary
import RealmSwift

class SPDataBase : Object {
    
    /// 配置数据库
    class func sp_configRealm(){
        /// 如果要存储的数据模型属性发生变化,需要配置当前版本号比之前大
        let dbVersion : UInt64 = 5
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/scanDB.realm")
        sp_log(message: "数据库地址:\(dbPath)")
//        let key = "3e3317892f2fe2600f4843f162addd903e3317892f2fe2600f4843f162addd90".data(using: String.Encoding.utf8)
        
        let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey:nil , readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
      
        Realm.asyncOpen { (realm, error) in
            if let _ = realm {
                sp_log(message: "Realm 服务器配置成功!")
            }else if let error = error {
                sp_log(message: "Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
    
    /// 保存数据
    ///
    /// - Parameter model: 二维码model
    class func sp_save(model : SPQRCodeModel?) ->SPQRCodeModel?{
        guard let qrCodeModel = model else {
            return nil
        }
        var isExist = true
        if sp_getString(string: qrCodeModel.id).count == 0 {
            qrCodeModel.id = "\( Date().timeIntervalSince1970)".sp_md5()
            isExist = false
        }
        if qrCodeModel.createTime == nil {
            qrCodeModel.createTime = Date()
            qrCodeModel.updateTime = qrCodeModel.createTime
            qrCodeModel.showTime = sp_timeString(date: qrCodeModel.createTime)
        }else{
            qrCodeModel.updateTime = Date()
        }
 
        let real = try! Realm()
        try! real.write {
            if isExist {
                real.add(qrCodeModel, update: Realm.UpdatePolicy.all)
            }else{
                real.add(qrCodeModel)
            }
        }
        return qrCodeModel
    }
    fileprivate class func sp_timeString(date:Date?)->String{
        guard let d = date else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: d)
    }
    
    
    /// 获取添加的数据
    ///
    /// - Returns: 添加数据
    class func sp_getAddData()->[SPQRCodeModel]{
        let real = try! Realm()
        let resultList = real.objects(SPQRCodeModel.self).filter("sourceType == %@",K_QRCODE_SOURCETYPE_ADD).sorted(byKeyPath: "createTime", ascending: false)
        var list = [SPQRCodeModel]()
        for model in resultList {
            if sp_getString(string: model.showTime).count == 0 {
                try! real.write {
                    model.showTime = sp_timeString(date: model.createTime)
                }
            }
            list.append(model)
        }
        return list
    }
    /// 获取扫描的数据
    ///
    /// - Returns: 扫描数据
    class func sp_getScanData()->[SPQRCodeModel]{
        let real = try! Realm()
        let resultList = real.objects(SPQRCodeModel.self).filter("sourceType == %@",K_QRCODE_SOURCETYPE_SCAN).sorted(byKeyPath: "createTime", ascending: false)
        var list = [SPQRCodeModel]()
        for model in resultList {
            if sp_getString(string: model.showTime).count == 0 {
                try! real.write {
                    model.showTime = sp_timeString(date: model.createTime)
                }
            }
            list.append(model)
        }
        return list
    }
    /// 删除数据
    ///
    /// - Parameter model: 数据源
    class func sp_delete(model : SPQRCodeModel){
          let real = try! Realm()
        try! real.write {
            real.delete(model)
        }
    }
    class func sp_transaction(complete : ()->Void){
        let real = try! Realm()
        try! real.write {
           complete()
        }
    }
    
}
