//
//  DNMainPageNoteCell.m
//  DNFMDBNote
//
//  Created by zjs on 2020/6/6.
//  Copyright © 2020 zjs. All rights reserved.
//

#import "DNMainPageNoteCell.h"

#import "DNNoteModel.h"

@interface DNMainPageNoteCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *content;
@property (nonatomic, strong) UILabel     *dateLabel;

@property (nonatomic, strong) UIButton    *playBtn;
@end

@implementation DNMainPageNoteCell

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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    
    self.contentView.backgroundColor = RGB(248, 248, 248, 1);
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor     = UIColor.whiteColor;
    self.bgView.layer.cornerRadius  = AUTO_MARGIN(12);
    self.bgView.layer.masksToBounds = YES;
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = UIColor.whiteColor;
    
    self.logoImage = [[UIImageView alloc] init];
    self.logoImage.layer.cornerRadius  = 3.f;
    self.logoImage.layer.masksToBounds = YES;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = systemFont(15);
    self.titleLabel.textColor = RGB(51, 51, 51, 1);
    
    self.content  = [[UILabel alloc]init];
    self.content.font = systemFont(14);
    self.content.textColor = RGB(102, 102, 102, 1);
    self.content.numberOfLines = 2;
    
    self.dateLabel  = [[UILabel alloc]init];
    self.dateLabel.font = systemFont(10);
    self.dateLabel.textColor = RGB(153, 153, 153, 1);
    
    self.playBtn = [[UIButton alloc] init];
    self.playBtn.titleLabel.font     = AUTO_SYS_FONT(14);
    self.playBtn.backgroundColor     = barColor;
    self.playBtn.layer.cornerRadius  = AUTO_MARGIN(10);
    self.playBtn.layer.masksToBounds = YES;
    [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupConstraints {
    
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.contentView.mas_top).inset(AUTO_MARGIN(12));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(12));
    }];
    
    [self.bgView addSubview:self.logoImage];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.leading.mas_equalTo(self.bgView.mas_leading).inset(AUTO_MARGIN(20));
        make.width.height.mas_offset(AUTO_MARGIN(60));
    }];
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.bgView.mas_top).inset(AUTO_MARGIN(20));
        make.leading.mas_equalTo(self.logoImage.mas_trailing).mas_offset(AUTO_MARGIN(10));
        
    }];
    
    [self.bgView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(AUTO_MARGIN(12));
        make.leading.mas_equalTo(self.titleLabel.mas_trailing).mas_offset(AUTO_MARGIN(10));
        make.width.mas_offset(AUTO_MARGIN(60));
        make.height.mas_offset(AUTO_MARGIN(20));
    }];
    
    [self.bgView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(AUTO_MARGIN(10));
        make.leading.trailing.mas_equalTo(self.titleLabel);
    }];
    
    [self.bgView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.content.mas_bottom).mas_offset(AUTO_MARGIN(10));
        make.leading.trailing.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
}

- (void)playAction {
    
    [[DNAudioManager defaultManeger] dn_playRecordAudio:self.model.audioData];
}

- (void)setModel:(DNNoteModel *)model {
    
    _model = model;
    
    self.logoImage.image = [UIImage sd_imageWithGIFData:model.imageData];
    self.titleLabel.text = model.titleStr;
    self.content.text    = model.content;
    self.dateLabel.text  = model.dateStr;
    self.playBtn.hidden  = model.audioData == nil;
}

@end
