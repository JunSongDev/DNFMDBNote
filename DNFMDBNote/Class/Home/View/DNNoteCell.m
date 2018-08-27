//
//  DNNoteCell.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNNoteCell.h"

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
    
    self.content  = [[UILabel alloc]init];
    self.content.font = systemFont(15);
    self.content.numberOfLines = 2;
    
    self.dayDate  = [[UILabel alloc]init];
    self.dayDate.font = systemFont(10);
    self.dayDate.textColor = UIColor.lightGrayColor;
    
    self.timeDate = [[UILabel alloc]init];
    self.timeDate.font = systemFont(10);
    self.timeDate.textColor = UIColor.lightGrayColor;
    
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.dayDate];
    [self.contentView addSubview:self.timeDate];
}

- (void)addConstraintsForSuper {
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(self.contentView).inset(SCREEN_W * 0.03);
    }];
    
    [self.dayDate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(self.content.mas_leading);
        make.top.mas_equalTo(self.content.mas_bottom).mas_offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(SCREEN_W * 0.02);
    }];
    
    [self.timeDate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(self.dayDate);
        make.left.mas_equalTo(self.dayDate.mas_right).mas_offset(8);
    }];
}

- (void)setModel:(DNNoteModel *)model {
    
    _model = model;
    
    self.content.text  = model.content;
    self.dayDate.text  = model.dayDate;
    self.timeDate.text = model.timeDate;
}

@end
