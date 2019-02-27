//
//  DNFMDBTool.m
//  DNFMDBNote
//
//  Created by zjs on 2019/2/27.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNFMDBTool.h"
#import <objc/runtime.h>

@interface DNFMDBTool ()

@property (nonatomic, copy) NSString *tableName;
@end

static FMDatabase * _db;
static DNFMDBTool *_manager = nil;

@implementation DNFMDBTool

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [super allocWithZone:zone];
        }
    });
    return _manager;
}

+ (instancetype)defaultManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            
            _manager = [[self alloc] init];
        }
    });
    return _manager;
}

- (FMDatabase *)dn_openDatabase {
    // /Users/zjs/Library/Developer/CoreSimulator/Devices/47652CCB-4399-43C6-8D33-8C30E0EAC602/data/Containers/Data/Application/6FD1BDD0-A38B-4059-9EF5-630572A745B6/Documents
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * dbPath = [path stringByAppendingPathComponent:@"DNFMDBTools.sqlite"];
    
    _db = [FMDatabase databaseWithPath:dbPath];
    
    if ([_db open]) {
        DNLog(@"open dataBase sueccess");
    }
    return _db;
}

/** 创建表 */
- (void)dn_createTable:(NSString *)tableName {
    
    self.tableName = tableName;
    
    [self dn_openDatabase];
    
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoincrement, model BOLB)", self.tableName];
    BOOL result = [_db executeUpdate:sql];
    
    if (result) {
        DNLog(@"create table success");
    }
}

- (void)dn_insertData:(id)data {
    
    [self dn_openDatabase];
    
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:data];
    NSString *sql = [NSString stringWithFormat:@"insert into %@(model) values (?)", self.tableName];
    
    BOOL result = [_db executeUpdate:sql values:@[modelData] error:nil];
    
    if (result) {
        DNLog(@"insert data success");
    }
    [_db close];
}

- (void)dn_deleteDateUid:(UInt32)uid {
    
    [self dn_openDatabase];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where id = ?", self.tableName];
    BOOL result = [_db executeUpdate:sql values:@[@(uid)] error:nil];
    if (result) {
        
        DNLog(@"delete data success");
    }
    [_db close];
}

- (void)dn_updateData:(id)data uid:(UInt32)uid {
    
    [self dn_openDatabase];
    
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:data];
    NSString * sql = [NSString stringWithFormat:@"update %@ set model = ? where id = ?", self.tableName];
    BOOL result = [_db executeUpdate:sql values:@[modelData, @(uid)] error:nil];
    
    if (result) {
        DNLog(@"update data success");
    } else {
        
        [_db rollback];
    }
    [_db close];
}

- (NSMutableArray *)dn_selectAllData {
    
    [self dn_openDatabase];
    NSString *sql = [NSString stringWithFormat:@"select * from %@", self.tableName];
    FMResultSet *result = [_db executeQuery:sql];
    NSMutableArray *resultArr = [NSMutableArray array];
    while (result.next) {
        
        NSObject *model = [[NSObject alloc] init];
        // 获取表中存储字段对应的值
        NSData *modelData = [result dataForColumn:@"model"];
        UInt32 uid        = [result intForColumn:@"id"];
        
        model = [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:modelData error:nil];
        model.user_id = uid;
        
        [resultArr addObject:model];
    }
    [_db close];
    return resultArr;
}

- (void)dropTable {
    
    [self dn_openDatabase];
    NSString *sql = [NSString stringWithFormat:@"drop table if exists %@", self.tableName];
    BOOL result = [_db executeUpdate:sql withArgumentsInArray:@[]];
    if (result) {
        
        NSLog(@"drop table success");
    }
    [_db close];
}

@end

@implementation NSObject (Extra)

static NSString *User_Id_Key = @"userIdKey";

- (void)setUser_id:(UInt32)user_id {
    
    objc_setAssociatedObject(self, &User_Id_Key, @(user_id), OBJC_ASSOCIATION_ASSIGN);
}

- (UInt32)user_id {
    
    NSNumber *num =  objc_getAssociatedObject(self, &User_Id_Key);
    return num.intValue;
}

@end
