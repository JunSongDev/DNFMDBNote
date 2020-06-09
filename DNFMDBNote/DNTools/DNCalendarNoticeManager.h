//
//  DNCalendarNoticeManager.h
//  DNFMDBNote
//
//  Created by zjs on 2020/6/8.
//  Copyright © 2020 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNCalendarNoticeManager : NSObject

+ (instancetype)defaultManeger;

- (void)dn_insertEvent:(NSString *)title date:(NSString *)date;
@end

NS_ASSUME_NONNULL_END
