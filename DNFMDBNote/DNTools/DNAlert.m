//
//  DNAlert.m
//  WalletGroup
//
//  Created by zjs on 2018/5/28.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNAlert.h"

@implementation DNAlert

/*================================================================
 -----------------> Toast 隐藏、显示
 ================================================================*/
+ (void)hideToast
{
    [ToastWindows hideToast];
}

+ (void)showToastwithMessage:(NSString *)message
{
    [ToastWindows makeToast:message duration:1.5 position:CSToastPositionCenter];
}

/*================================================================
 -----------------> 自动消失
 ================================================================*/

+ (void)alertWithMessage:(NSString *)message superClass:(id)superClass {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    [alert performSelector:@selector(alertSelctor:) withObject:alert afterDelay:1.5];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [superClass presentViewController:alert animated:YES completion:nil];
    });
}

- (void)alertSelctor:(UIAlertController *)alert {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

/*================================================================
 -----------------> 仅确认回调
 ================================================================*/

+ (void)alertWithMessage:(NSString *)message superClass:(id)superClass completeHandler:(void (^)(void))completeHandler
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completeHandler();
        });
        
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [superClass presentViewController:alert animated:YES completion:nil];
    });
}

/*================================================================
 -----------------> 确认和取消回调
================================================================*/

+ (void)alertWithMessage:(NSString *)message superClass:(id)superClass completeHandler:(void (^)(void))completeHandler cancleHandler:(void (^)(void))cancleHandle
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cancleHandle();
        });
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completeHandler();
        });
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [superClass presentViewController:alert animated:YES completion:nil];
    });
}

@end
