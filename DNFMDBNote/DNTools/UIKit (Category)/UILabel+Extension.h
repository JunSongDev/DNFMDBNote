//
//  UILabel+Extension.h
//  DNFMDBNote
//
//  Created by zjs on 2018/7/16.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/**
 *  @brief 快速创建一个 UILabel
 *
 *  @param text 内容
 *  @param textFont 文本大小
 *  @param textColor 文本颜色
 *  @param textAligment 对其方式
 */
+ (UILabel *)dn_labelWithText:(NSString *)text
                     textFont:(CGFloat)textFont
                    textColor:(UIColor *)textColor
                 textAligment:(NSTextAlignment)textAligment;

@end
