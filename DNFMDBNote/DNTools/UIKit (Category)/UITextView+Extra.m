//
//  UITextView+Extra.m
//  DNFMDBNote
//
//  Created by zjs on 2019/3/8.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "UITextView+Extra.h"
#import <objc/runtime.h>


static char *placeholderKey      = "placeholderKey";
static char *textMaxLengthKey    = "textMaxLengthKey";
static char *placeholderColorKey = "placeholderColorKey";

@interface UITableView (Extra)

@property (nonatomic, strong) UILabel *dn_placeholderLabel;
@property (nonatomic, strong) UILabel *dn_maxLengthLabel;
@end

@implementation UITextView (Extra)

// 交换方法
+ (void)load {
    
    [super load];
    
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(dn_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(dn_dealloc)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"setText:")),
                                   class_getInstanceMethod(self.class, @selector(dn_setText:)));
}

- (void)dn_dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dn_dealloc];
}

- (void)dn_layoutSubviews {
    
    if (self.dn_placeholder) {
        
        self.dn_placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.dn_placeholderLabel.topAnchor      constraintEqualToAnchor:self.topAnchor constant:5].active = YES;
        [self.dn_placeholderLabel.leadingAnchor  constraintEqualToAnchor:self.leadingAnchor constant:5].active = YES;
        [self.dn_placeholderLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5].active = YES;
    }
    
//    if (self.dn_maxLengthLabel) {
//
//        [self.dn_maxLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.bottom.trailing.mas_equalTo(self).inset(5);
//        }];
//    }
    [self dn_layoutSubviews];
}

- (void)dn_setText:(NSString *)text {
    
    [self dn_setText:text];
    if (self.dn_placeholder) {
        [self updatePlaceHolder];
    }
}

#pragma mark - update
- (void)updatePlaceHolder {
    
    if (self.text.length > self.dn_maxLength) {
        
        self.text = [self.text substringWithRange:NSMakeRange(0, self.dn_maxLength)];
//        self.dn_maxLengthLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.text.length, self.dn_maxLength];
    }
    
    if (self.text.length) {
        [self.dn_placeholderLabel removeFromSuperview];
        return;
    }
    self.dn_placeholderLabel.font = self.font;
    self.dn_placeholderLabel.text = self.dn_placeholder;
    self.dn_placeholderLabel.textColor = self.dn_placeholderColor ? :[UIColor colorWithWhite:0.8 alpha:1.0];
    [self insertSubview:self.dn_placeholderLabel atIndex:0];
//    [self insertSubview:self.dn_maxLengthLabel atIndex:0];
}

#pragma mark - lazzing
- (UILabel *)dn_placeholderLabel {
    
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(dn_placeholderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        
        objc_setAssociatedObject(self, @selector(dn_placeholderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceHolder)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    return placeHolderLab;
}

//- (UILabel *)dn_maxLengthLabel {
//
//    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(dn_maxLengthLabel));
//    if (!placeHolderLab) {
//        placeHolderLab = [[UILabel alloc] init];
//        placeHolderLab.font      = [UIFont systemFontOfSize:14];
//        placeHolderLab.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//
//
//        objc_setAssociatedObject(self, @selector(dn_maxLengthLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
//
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(updatePlaceHolder)
//                                                     name:UITextViewTextDidChangeNotification
//                                                   object:self];
//    }
//    return placeHolderLab;
//}

#pragma mark -- 占位文字
- (void)setDn_placeholder:(NSString *)dn_placeholder {
    
    objc_setAssociatedObject(self, placeholderKey, dn_placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self updatePlaceHolder];
}

- (NSString *)dn_placeholder {
    
    return objc_getAssociatedObject(self, placeholderKey);
}

#pragma mark -- 占位文字的颜色
- (void)setDn_placeholderColor:(UIColor *)dn_placeholderColor {
    
    objc_setAssociatedObject(self, placeholderColorKey, dn_placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}

- (UIColor *)dn_placeholderColor {
    
    return objc_getAssociatedObject(self, placeholderColorKey);
}

#pragma mark -- UITextView 的最大输入长度
- (void)setDn_maxLength:(NSInteger)dn_maxLength {
    
    NSNumber *number = [NSNumber numberWithInteger:dn_maxLength];
    objc_setAssociatedObject(self, textMaxLengthKey, number, OBJC_ASSOCIATION_ASSIGN);
    [self updatePlaceHolder];
}

- (NSInteger)dn_maxLength {
    
    NSNumber *number = objc_getAssociatedObject(self, textMaxLengthKey);
    return number.integerValue;
}
@end
