//
//  DNDBTools.h
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNBaseModel.h"
#import "DNNoteModel.h"
#import <FMDB/FMDB.h>

@interface DNDBTools : DNBaseModel

/** 打开数据库 */
+ (FMDatabase *)dn_openDatabase;

/** 创建数据库 */
+ (void)dn_createDatabase;

/** 关闭数据库 */
//+ (void)dn_closerDatabase;

/** 插入数据 */
+ (void)dn_insertData:(DNNoteModel *)data;

/** 删除数据 */
+ (void)dn_deleteDate: (int)dataID;

/** 更新数据 */
+ (void)dn_updateData:(DNNoteModel *)data;

/** 查询所有数据 */
+ (NSMutableArray *)dn_selectAllData;

@end
