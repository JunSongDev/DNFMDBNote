//
//  AppDelegate+JPush.h
//  DNFMDBNote
//
//  Created by zjs on 2018/11/5.
//  Copyright © 2018 zjs. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (JPush)<JPUSHRegisterDelegate>

- (void)registerJPushWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
