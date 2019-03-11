//
//  DNDBTools.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNDBTools.h"
#import "DNNoteModel.h"
#import "NSArray+Extension.h"

static FMDatabase * _db;
static Class *_class;

@implementation DNDBTools

+ (FMDatabase *)dn_openDatabase {
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                           NSUserDomainMask,
                                                           YES) lastObject];
    NSString * dbPath = [path stringByAppendingPathComponent:@"DNDBTools.sqlite"];
    
    _db = [FMDatabase databaseWithPath:dbPath];
    
    if ([_db open]) {
        DNLog(@"打开数据库成功");
    }
    return _db;
}

+ (void)dn_createDatabase {
    
    [self dn_openDatabase];
    
    NSString * sql = @"create table if not exists note(id integer primary key autoincrement,content text,dayDate text,timeDate text)";
    
    BOOL result = [_db executeUpdate:sql];
    
    if (result) {
        DNLog(@"创建表成功");
    }
    //[_db close];
}

+ (void)dn_closerDatabase {

    [_db close];
}

+ (void)dn_insertData:(DNNoteModel *)data {
    
    [self dn_openDatabase];
    NSString * sql = @"insert into note(content,dayDate,timeDate) values(?,?,?)";
    BOOL result = [_db executeUpdate:sql,data.content,data.dayDate,data.timeDate];
    
    if (result) {
        DNLog(@"插入成功");
    }
    [_db close];
}

+ (void)dn_deleteDate:(int)dataID {
    
    [self dn_openDatabase];
    NSString * sql = @"delete from note where id = ?;";
    BOOL result = [_db executeUpdate:sql,@(dataID)];
    if (result) {
        
        DNLog(@"删除成功");
    }
    [_db close];
}

+ (void)dn_updateData:(DNNoteModel *)data {
    
    [self dn_openDatabase];
    
    NSString * sql = @"update note set content = ?,dayDate = ?,timeDate = ? where id = ?";
    
    BOOL result = [_db executeUpdate:sql,data.content,data.dayDate,data.timeDate,@(data.modelID)];
    
    if (result) {
        
        DNLog(@"更新成功");
    }
    [_db close];
}

+ (NSMutableArray *)dn_selectAllData {
    
    [self dn_openDatabase];
    NSString * sql = @"select * from note order by timeline desc";
    FMResultSet * result = [_db executeQuery:sql];
    
    NSMutableArray * array = [NSMutableArray array];
    
    while (result.next) {
        
        int modelID = [result intForColumn:@"id"];
        NSString *content  = [result stringForColumn:@"content"];
        NSString *dayDate  = [result stringForColumn:@"dayDate"];
        NSString *timeDate = [result stringForColumn:@"timeDate"];
        
        DNNoteModel * model = [[DNNoteModel alloc] init];
        model.modelID = modelID;
        model.content = content;
        model.dayDate = dayDate;
        model.timeDate = timeDate;
        
        [array addObject:model];
    }
    [_db close];
    return array;
}

@end
