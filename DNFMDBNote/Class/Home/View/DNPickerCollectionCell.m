//
//  DNPickerCollectionCell.m
//  DNFMDBNote
//
//  Created by zjs on 2019/3/8.
//  Copyright © 2019 zjs. All rights reserved.
//

#import "DNPickerCollectionCell.h"

@interface DNPickerCollectionCell ()

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIImageView * imageView;
@end

@implementation DNPickerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColor.whiteColor;
        [self initializationSubviews];
    }
    return self;
}

- (void)initializationSubviews {
    
    self.closeBtn = [[UIButton alloc] init];
    [self.closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    self.imageView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:self.closeBtn];
    [self.contentView addSubview:self.imageView];
    
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.mas_equalTo(self.imageView);
        make.width.height.mas_equalTo(SCREEN_W*0.06);
    }];
}

- (void)setImageName:(NSString *)imageName {
    
    _imageName = imageName;
    
    self.closeBtn.hidden = DNULLString(imageName) ? YES : NO;
    NSString *nameStr    = DNULLString(imageName) ? @"add" : imageName;
    self.imageView.image = [UIImage imageNamed:nameStr];
}

@end
