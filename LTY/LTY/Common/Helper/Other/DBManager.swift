//
//  DataManager.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import WCDBSwift
/// 以下扩展给业务层使用
///
protocol TableProtocol {
    var name: String {get} // 表名
    var select: Select? {get} 
    var dataBase: Database {get} // 表对应的数据库
}

/// 数据库
protocol DataBaseProtocol {
    var path: String {get} // 数据库存放路径
    var tag: Int {get} // 数据库tag 对应唯一数据库
    var db: Database {get} // 真实数据库
}
enum SFDataBase: String, DataBaseProtocol {
    
    case user = "user.db"
    case main = "main.db"
    case home = "home.db"
    var path: String {
        return rawValue.document
    }
    var tag: Int {
        switch self {
        case .user:
            return 1
        case .main:
            return 2
        case .home:
            return 3
        }
    }
    var db: Database {
        let db = Database(withPath: self.path)
        db.tag = tag
        return db
    }
    
}

enum SFTable: String, TableProtocol {
    var name: String {
        switch self {
        case .user:
            return "UserTable"
        case .main:
            return "MainTabel"
        case .home:
            return "Hometabel"
        }
    }
    
    var select: Select? {
        switch self {
        case .main:
            return try? dataBase.prepareSelect(of: HomeModel.self, fromTable: name)
        default:
            return nil
        }
    }
    
    case user
    case main
    case home
    
    var dataBase: Database {
        switch self {
        case .user:
            return SFDataBase.user.db
        case .main:
            return SFDataBase.main.db
        case .home:
            return SFDataBase.home.db
        }
    }
}

public struct DBManager {
    static let shared = DBManager()
    init() {
        do {
            try SFDataBase.main.db.run(transaction: {
                try SFDataBase.main.db.create(table: SFTable.main.name, of: HomeModel.self)
            })
        } catch  {
            myLog("初始化数据库及ORMb对应关系建立失败")
        }
    }
}



extension DBManager {
    
    typealias ErrorType = (WCDBSwift.Error?)->Void
    
    func insert<Object>(_ table: TableProtocol, objects: [Object]) -> WCDBSwift.Error? where Object: TableEncodable {
        do {
            try table.dataBase.insert(objects: objects, intoTable: table.name)
            return nil
        } catch {
            let errorValue = error as? WCDBSwift.Error
            return errorValue
        }
    }
    
    func update<Object>(_ table: TableProtocol, object: Object, propertys: [PropertyConvertible], condition: Condition? = nil, orderBy: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> WCDBSwift.Error? where Object: TableEncodable {
        do {
            try table.dataBase.update(table: table.name, on: propertys, with: object, where: condition, orderBy: orderBy, limit: limit, offset: offset)
            return nil
        } catch {
            let errorValue = error as? WCDBSwift.Error
            return errorValue
        }
    }
    
    func select<Object>(_ table: TableProtocol, condition: Condition? = nil, errorClosure: ErrorType?) -> [Object]? where Object: TableEncodable {
        do {
            if let condition = condition {
                table.select?.where(condition)
            }
            let objects: [Object]? = try table.select?.allObjects() as? [Object]
            return objects
        } catch {
            let errorValue = error as? WCDBSwift.Error
            errorClosure?(errorValue)
            return nil
        }
    }
    
    func delete(_ table: TableProtocol, condition: Condition?, orderBy: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> WCDBSwift.Error? {
        do {
            try table.dataBase.delete(fromTable: table.name, where: condition, orderBy: orderBy, limit: limit, offset: offset)
            return nil
        } catch {
            let errorValue = error as? WCDBSwift.Error
            return errorValue
        }
    }
    
    func insertOrReplace<Object>(_ table: TableProtocol, objects: [Object]) -> WCDBSwift.Error? where Object : TableEncodable {
        do {
            try table.dataBase.insertOrReplace(objects: objects, intoTable: table.name)
            return nil
        } catch {
            let errorValue = error as? WCDBSwift.Error
            return errorValue
        }
    }
}
