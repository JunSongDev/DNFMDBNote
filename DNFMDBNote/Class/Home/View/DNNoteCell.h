//
//  DNNoteCell.h
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNBaseCell.h"
#import "DNNoteModel.h"

@interface DNNoteCell : DNBaseCell

@property (nonatomic, strong) UIImageView *thumImage;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *dayDate;
@property (nonatomic, strong) UILabel *timeDate;

@property (nonatomic, strong) DNNoteModel * model;

@end
