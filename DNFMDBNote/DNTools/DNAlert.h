//
//  DNAlert.h
//  WalletGroup
//
//  Created by zjs on 2018/5/28.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNAlert : NSObject

+ (void)hideToast;

+ (void)showToastwithMessage:(NSString *)message;

/**
 *  @breif  可消失的提示框
 *
 *  @param  message         提示信息
 *  @param  superClass      present的self
 */
+ (void)alertWithMessage:(NSString *)message
              superClass:(id)superClass;

/**
 *  @breif  可回调的提示框
 *
 *  @param  message         提示信息
 *  @param  superClass      present的self
 *  @param  completeHandler 完成回调
 */
+ (void)alertWithMessage:(NSString *)message
              superClass:(id)superClass
         completeHandler:(void(^)(void))completeHandler;

/**
 *  @breif  可回调的提示框
 *
 *  @param  message         提示信息
 *  @param  superClass      present的self
 *  @param  completeHandler 完成回调
 *  @param  cancleHandle    取消回调
 */
+ (void)alertWithMessage:(NSString *)message
              superClass:(id)superClass
         completeHandler:(void(^)(void))completeHandler
           cancleHandler:(void(^)(void))cancleHandle;

@end
