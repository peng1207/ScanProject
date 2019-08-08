//
//  SPBaseModel.swift
//  ScanProject
//
//  Created by 黄树鹏 on 2019/7/29.
//  Copyright © 2019 shupenghuang. All rights reserved.
//

import Foundation
import RealmSwift
import HandyJSON
import SPCommonLibrary
class SPBaseModel : Object, HandyJSON {
    class func sp_deserialize(from:String) -> Self?  {
        return self.deserialize(from: from)
    }
    class func sp_deserialize(from : [String : Any]?) -> Self?  {
        return self.deserialize(from: from)
    }
    /// 返回字符串的json
    ///
    /// - Returns: 字符串json
    func sp_toString()->String{
        return sp_getString(string: self.toJSONString())
    }
    /// 返回json对象
    ///
    /// - Returns: json
    func sp_toJson()->[String : Any]?{
        return self.toJSON()
    }
    
}
