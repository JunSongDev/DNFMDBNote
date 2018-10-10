//
//  NSArray+Extension.m
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "NSArray+Extension.h"
#import <objc/runtime.h>

@implementation NSArray (Extension)

#pragma mark -- 数组转 json 字符串
- (NSString *)dn_toJsonStrng
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        
        NSError * error = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&error];
        if (error)
        {
            DNLog(@"数组转JSON字符串失败：%@", error);
        }
        return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark -- 数组倒序
- (NSArray *)dn_reverse
{
    return [[self reverseObjectEnumerator] allObjects];
}

+ (instancetype)dn_getPropertiesForModel:(Class)model {
    
    unsigned int count;
    // 获取当前类的所有属性
    objc_property_t *properties = class_copyPropertyList(model, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转化为 OC 字符串
        NSString *objcName = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        // 存数组
        [array addObject:objcName];
    }
    return array.copy;
}
@end

@implementation NSMutableArray (Extension)



//static inline BOOL dn_isEmpty(id thing)
//{
//    return thing == nil ||
//    [thing isEqual:[NSNull null]] ||
//    [thing isEqualToString:@"null"] ||
//    [thing isEqualToString:@"(null)"] ||
//    ([thing respondsToSelector:@selector(length)]
//     && [(NSData *)thing length] == 0) ||
//    ([thing respondsToSelector:@selector(count)]
//     && [(NSArray *)thing count] == 0);
//}
@end
