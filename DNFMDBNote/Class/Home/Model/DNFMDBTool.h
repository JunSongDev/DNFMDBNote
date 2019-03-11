//
//  DNFMDBTool.h
//  DNFMDBNote
//
//  Created by zjs on 2019/2/27.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNFMDBTool : NSObject

+ (instancetype)defaultManager;

/** 打开数据库 */
//+ (FMDatabase *)dn_openDatabase;

/** 创建表 */
- (void)dn_createTable:(NSString *)tableName;

/** 插入数据 */
- (void)dn_insertData:(id)data;

/** 删除数据 */
- (void)dn_deleteDateUid:(UInt32)uid;

/** 更新数据 */
- (void)dn_updateData:(id)data uid:(UInt32)uid;

/** 更新数据 */
- (NSMutableArray *)dn_selectAllData;

/** 删除数据 */
- (void)dropTable;

@end

@interface NSObject (Extra)

@property (nonatomic, assign) UInt32 user_id;

@end

NS_ASSUME_NONNULL_END
