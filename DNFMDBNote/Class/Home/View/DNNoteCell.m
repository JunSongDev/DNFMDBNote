//
//  DNNoteCell.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNNoteCell.h"

@interface DNNoteCell ()

@property (nonatomic, strong) UIView  *bottomView;

@property (nonatomic, strong) UIImageView *thumImage;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *dayDate;
@property (nonatomic, strong) UILabel *timeDate;
@end

@implementation DNNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setControlForSuper];
        [self addConstraintsForSuper];
    }
    return self;
}

- (void)setControlForSuper {
    
    self.bottomView = [[UIView alloc] init];
    
    self.thumImage = [[UIImageView alloc] init];
    self.thumImage.layer.cornerRadius  = 3.f;
    self.thumImage.layer.masksToBounds = YES;
    
    self.content  = [[UILabel alloc]init];
    self.content.font = systemFont(15);
    self.content.numberOfLines = 2;
    
    self.dayDate  = [[UILabel alloc]init];
    self.dayDate.font = systemFont(10);
    self.dayDate.textColor = UIColor.lightGrayColor;
    
    self.timeDate = [[UILabel alloc]init];
    self.timeDate.font = systemFont(10);
    self.timeDate.textColor = UIColor.lightGrayColor;
}

- (void)addConstraintsForSuper {
    
    [self.contentView addSubview:self.thumImage];
    [self.thumImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.leading.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.width.height.mas_offset(SCREEN_W * 0.2);
    }];
    
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY).multipliedBy(0.75);
        make.left.mas_equalTo(self.thumImage.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).inset(10);
    }];
    
    [self.contentView addSubview:self.dayDate];
    [self.dayDate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(self.content.mas_leading);
        make.top.mas_equalTo(self.content.mas_bottom).mas_offset(8);
    }];
    
    [self.contentView addSubview:self.timeDate];
    [self.timeDate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(self.dayDate);
        make.left.mas_equalTo(self.dayDate.mas_right).mas_offset(8);
    }];
    
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.thumImage.mas_bottom).mas_offset(AUTO_MARGIN(20));
        make.leading.bottom.trailing.mas_equalTo(self.contentView);
    }];
}

- (void)setModel:(DNNoteModel *)model {
    
    _model = model;
    
    self.thumImage.image = [UIImage sd_imageWithGIFData:model.imageData];
    self.content.text  = model.content;
    self.dayDate.text  = model.dayDate;
    self.timeDate.text = model.timeDate;
}

@end
