//
//  UITextView+Extra.h
//  DNFMDBNote
//
//  Created by zjs on 2019/3/8.
//  Copyright © 2019 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Extra)

@property (nonatomic, assign) NSInteger dn_maxLength;

// 设置占位文字
@property (nonatomic,   copy) NSString *dn_placeholder;

// 设置占位文字的颜色
@property (nonatomic, strong) UIColor  *dn_placeholderColor;
@end

NS_ASSUME_NONNULL_END
