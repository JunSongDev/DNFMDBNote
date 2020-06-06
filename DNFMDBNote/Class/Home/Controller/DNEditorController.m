//
//  DNEditorController.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNEditorController.h"
#import "DNNoteModel.h"
#import "UITextView+Extra.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface DNEditorController ()<HXPhotoViewDelegate>

@property (nonatomic, strong) UITextView  *textView;
@property (nonatomic, strong) HXPhotoView *photoView;

@property (nonatomic, strong) NSData *imageData;
@end

@implementation DNEditorController

#pragma mark -- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Editor";
    
    [self setControlForSuper];
    [self addConstrainsForSuper];
    [self setNavigateRightItem];
    
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
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
- (void)setControlForSuper {
    
    self.textView = [[UITextView alloc]init];
    self.textView.font = systemFont(15);
    self.textView.dn_placeholder = @"请输入将要存储的内容";
    self.textView.dn_maxLength = 20;
    
    HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    // 最多可选择数量
    manager.configuration.photoMaxNum   = 1;
    manager.configuration.albumShowMode = HXPhotoAlbumShowModeDefault;
    // 导航栏标题颜色
    manager.configuration.navigationTitleColor = UIColor.whiteColor;
    // 导航栏按钮颜色
    manager.configuration.themeColor = UIColor.whiteColor;
    
    manager.configuration.statusBarStyle = UIStatusBarStyleLightContent;
    
    self.photoView = [[HXPhotoView alloc] initWithManager:manager];
    self.photoView.delegate  = self;
    self.photoView.lineCount = 4;
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

- (void)insertData {
    
    if (DNULLString(self.textView.text)) {
        
        DNLog(@"内容不能为空");
        [DNAlert alertWithMessage:@"内容不能为空" superClass:self completeHandler:^{
            
        }];
        return;
    }
    
    [DNAlert alertWithMessage:@"是否要保存数据"
                   superClass:self
              completeHandler:^{
        
        DNNoteModel * model = [[DNNoteModel alloc] init];
        model.content   = self.textView.text;
        model.imageData = self.imageData;
        model.dayDate   = [self getCurrentDayDate];
        model.timeDate  = [self getCurrentTimeDate];
                  
        [[DNFMDBTool defaultManager] dn_insertData:model];
                  
        [self.navigationController popViewControllerAnimated:YES];
              
    } cancleHandler:^{
        
    }];
}

#pragma mark -- Private Methods
// 设置导航栏右侧按钮
- (void)setNavigateRightItem {
    
    UIImage *insertImg = [[UIImage imageNamed:@"insert"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem * insertItem = [[UIBarButtonItem alloc] initWithImage:insertImg
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(insertData)];
    self.navigationItem.rightBarButtonItems = @[insertItem];
}

// 获取当前的日期 年月日
- (NSString *)getCurrentDayDate {
    
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString * dateStr = [format stringFromDate:[NSDate new]];
    
    return dateStr;
}
// 获取当前时间 时分秒
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
    
    if (photos.count > 0) {
        if (photos[0].type == HXPhotoModelMediaTypePhotoGif) {
            
            if (photos[0].asset) {
                
                NSArray *resourceList = [PHAssetResource assetResourcesForAsset:photos[0].asset];
                [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                               
                    PHAssetResource *resource = obj;
                    PHAssetResourceRequestOptions *option = [[PHAssetResourceRequestOptions alloc]init];
                    option.networkAccessAllowed = YES;
                    // 首先,需要获取沙盒路径
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    // 拼接图片名为resource.originalFilename的路径
                    NSString *imageFilePath = [path stringByAppendingPathComponent:resource.originalFilename];

                    if ([resource.uniformTypeIdentifier isEqualToString:@"com.compuserve.gif"]) {
                                   
                        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:imageFilePath] options:option completionHandler:^(NSError * _Nullable error) {
                            if (error) {
                                if(error.code == -1){
                                    //文件已存在
                                    self.imageData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imageFilePath]];
                                }
                            } else {
                                self.imageData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imageFilePath]];
                            }
                        }];
                    }
                }];
            }
            
        } else {
            UIImage *image = photos[0].thumbPhoto;
            self.imageData = UIImagePNGRepresentation(image);
        }
    }
}

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
