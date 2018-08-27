//
//  UILabel+Extension.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/16.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

/** 快速创建一个 UILabel */
+ (UILabel *)dn_labelWithText:(NSString *)text
                     textFont:(CGFloat)textFont
                    textColor:(UIColor *)textColor
                 textAligment:(NSTextAlignment)textAligment {
    
    UILabel * label = [[UILabel alloc]init];
    label.text = text;
    label.font = systemFont(textFont);
    label.textColor = textColor;
    label.textAlignment = textAligment;
    
    return label;
}
@end
