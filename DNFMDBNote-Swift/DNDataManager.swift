//
//  DNDataManager.swift
//  DNFMDBDemo-Swift
//
//  Created by zjs on 2018/10/11.
//  Copyright © 2018 zjs. All rights reserved.
//

import UIKit
import FMDB

class DNDataManager: NSObject {

    static let manager = DNDataManager()
    
    private var tableName:String?
    
    lazy var fmdb:FMDatabase = {
        
        var  path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        path = path?.appending("/dispatch.db")
        let _fmdb = FMDatabase(path: path)
        
        return _fmdb
    }()
    
    /**
     *  create table for dataBase
     */
    public func createTable(tableName: String) -> Void {
        
        self.fmdb.open()
        // 全局变量存储表明
        self.tableName = tableName
        
        let createSql = "create table if not exists \(tableName) (id integer primary key autoincrement, model BOLB)"
        
        let result = self.fmdb.executeUpdate(createSql, withArgumentsIn: [])
        
        if result {
            print("create table success!")
        }
    }
    /**
     *  insert into data for table
     */
    public func insertData(model: NSObject, successHandler: () -> Void) -> Void {
        
        self.fmdb.open()
        
        let modelData = try! NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
        let insertSql = "insert into " + self.tableName! + " (model) values(?)"
        
        do {
            try self.fmdb.executeUpdate(insertSql, values: [modelData])
            successHandler()
            print("insert data success!")
        } catch  {
            print(self.fmdb.lastError())
        }
        self.fmdb.close()
    }
    /**
     *  delete into data form table
     */
    public func deleteData(uid: Int32) -> Void {
        
        self.fmdb.open()
        
        let deleteSql = "delete from " + self.tableName! + " where id = ?"
        do {
            try self.fmdb.executeUpdate(deleteSql, values: [uid])
            print("delete data success!")
        } catch {
            self.fmdb.rollback()
        }
        self.fmdb.close()
    }
    /**
     *  update data for table
     */
    public func updateData(model: NSObject, uid: Int32, successHandler: () -> Void) -> Void {
        
        self.fmdb.open()
        
        let modelData = try! NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
        let updateSql = "update " + self.tableName! + " set model = ? where id = ?"
        
        do {
            try self.fmdb.executeUpdate(updateSql, values: [modelData, uid])
            successHandler()
            print("update data success!")
        } catch {
            self.fmdb.rollback()
        }
        self.fmdb.close()
    }
    /**
     *  select all data form table
     */
    public func selectAllData() -> [NSObject] {
    
        self.fmdb.open()
        var temp = [NSObject]()
        let selectSql = "select * from " + self.tableName!
        do {
            let result = try fmdb.executeQuery(selectSql, values:nil)
            while result.next() {
                var model = NSObject()
                let modelData = result.data(forColumn: "model")
                let id = result.int(forColumn: "id")
                model = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(modelData!) as! NSObject
                model.user_fmdb_id = id
                
                temp.append(model)
            }
        } catch {
            print(self.fmdb.lastError())
        }
        self.fmdb.close()
        return temp
    }
    /**
     *  delete table
     */
    public func deleteTable() -> Void {
        self.fmdb.open()
        let deleteSql = "drop table if exists " + self.tableName!
        let result = self.fmdb.executeUpdate(deleteSql, withArgumentsIn: [])
        if result {
            print("delete table success!")
        }
        self.fmdb.close()
    }
}

private var user_id_key = "UserIDKey"

extension NSObject {
    open var user_fmdb_id: Int32? {
        get{
            return objc_getAssociatedObject(self, &user_id_key) as? Int32
        } set{
            objc_setAssociatedObject(self, &user_id_key, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
