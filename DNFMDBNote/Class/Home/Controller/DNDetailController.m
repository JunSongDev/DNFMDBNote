//
//  DNDetailController.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNDetailController.h"

@interface DNDetailController ()<HXPhotoViewDelegate>

@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) HXPhotoView *photoView;

@property (nonatomic, strong) NSData *imageData;
@end

@implementation DNDetailController

#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Update";
    
    [self setControlForSuper];
    [self addConstrainsForSuper];
    [self setNavigateRightItem];
}

/**

- (void)viewWillAppear:(BOOL)animated {
[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
[super viewDidDisappear:animated];
}
*/


#pragma mark -- DidReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- SetControlForSuper
- (void)setControlForSuper
{    
    self.textView = [[UITextView alloc] init];
    self.textView.font = systemFont(15);
    self.textView.text = self.model.content;
    
    HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    // 最多可选择数量
    manager.configuration.photoMaxNum   = 1;
    manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
    // 导航栏标题颜色
    manager.configuration.navigationTitleColor = UIColor.whiteColor;
    // 导航栏按钮颜色
    manager.configuration.themeColor = UIColor.whiteColor;
    
    manager.configuration.statusBarStyle = UIStatusBarStyleLightContent;
    
    self.photoView = [[HXPhotoView alloc] initWithManager:manager];
    self.photoView.backgroundColor = UIColor.whiteColor;
    self.photoView.delegate = self;
    
    [self.view addSubview:self.photoView];
    [self.view addSubview:self.textView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper {
    
    [self.view addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.bottom.trailing.mas_equalTo(self.view);
        make.height.mas_offset(SCREEN_W);
    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.photoView.mas_top);
    }];
}

#pragma mark -- Target Methods

- (void)updateData {
    
    if (DNULLString(self.textView.text)) {
        DNLog(@"内容不可以为空");
        return;
    }
    
    [DNAlert alertWithMessage:@"是否要更新数据"
                   superClass:self
              completeHandler:^{
    
        DNNoteModel * model = [[DNNoteModel alloc] init];
        model.user_id   = self.model.user_id;
        model.content   = self.textView.text;
        model.imageData = self.imageData;
        model.dayDate   = [self getCurrentDayDate];
        model.timeDate  = [self getCurrentTimeDate];
        
        [[DNFMDBTool defaultManager] dn_updateData:model uid:model.user_id];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } cancleHandler:^{
        
    }];
}

- (void)choosePhoto {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- Private Methods

- (void)setNavigateRightItem {
    
    UIImage *insertImg = [[UIImage imageNamed:@"insert"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem * insertItem = [[UIBarButtonItem alloc] initWithImage:insertImg
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(updateData)];
    self.navigationItem.rightBarButtonItems = @[insertItem];
}

- (NSString *)getCurrentDayDate {
    
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString * dateStr = [format stringFromDate:[NSDate new]];
    
    return dateStr;
}

- (NSString *)getCurrentTimeDate {
    
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"HH:mm:ss";
    NSString * dateStr = [format stringFromDate:[NSDate new]];
    
    return dateStr;
}

// 获取当前时间戳
- (NSString *)getCurrentTimeLine {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    // 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString * dateStr = [formatter stringFromDate:[NSDate new]];
    
    return dateStr;
}

#pragma mark -- UITableView Delegate && DataSource


#pragma mark -- HXPhotoViewDelegate
- (void)photoListViewControllerDidDone:(HXPhotoView *)photoView
                               allList:(NSArray<HXPhotoModel *> *)allList
                                photos:(NSArray<HXPhotoModel *> *)photos
                                videos:(NSArray<HXPhotoModel *> *)videos
                              original:(BOOL)isOriginal {
    
    UIImage *image = photos[0].thumbPhoto;
    self.imageData = UIImagePNGRepresentation(image);
}

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
