//
//  DNEditorInfoViewController.m
//  DNFMDBNote
//
//  Created by zjs on 2020/6/6.
//  Copyright © 2020 zjs. All rights reserved.
//

#import "DNEditorInfoViewController.h"

#import "UITextView+Extra.h"

#import "DNNoteModel.h"

@interface DNEditorInfoViewController ()<HXPhotoViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView      *contentView;
@property (nonatomic, strong) UITextField *titleText;
@property (nonatomic, strong) UITextView  *contentText;
@property (nonatomic, strong) UIButton    *audioBtn;

@property (nonatomic, strong) HXPhotoManager *manager;
@property (nonatomic, strong) HXPhotoView    *photoView;

@property (nonatomic, strong) NSData         *imageData;
@property (nonatomic, strong) NSData         *audioData;
@end

@implementation DNEditorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model == nil ? @"添加":@"修改";
    
    [self setupSubviews];
    [self setupConstraints];
    [self setNavigateRightItem];
    // Do any additional setup after loading the view.
}

- (void)setupSubviews {
    
    self.scrollView  = [[UIScrollView alloc] init];
    
    self.contentView = [[UIView alloc] init];
    
    self.titleText = [[UITextField alloc] init];
    self.titleText.text        = DNULLString(self.model.titleStr)?@"":self.model.titleStr;
    self.titleText.font        = AUTO_SYS_FONT(16);
    self.titleText.textColor   = UIColorMake(51, 51, 51);
    self.titleText.placeholder = @"请输入标题";
    self.titleText.layer.borderColor = UIColorMake(248, 248, 248).CGColor;
    self.titleText.layer.borderWidth = AUTO_MARGIN(1);
    
    self.contentText = [[UITextView alloc] init];
    self.contentText.text      = DNULLString(self.model.content)?@"":self.model.content;
    self.contentText.font      = AUTO_SYS_FONT(14);
    self.contentText.textColor = UIColorMake(102, 102, 102);
    self.contentText.dn_placeholder = @"请输入内容";
    self.contentText.dn_maxLength   = 200;
    self.contentText.layer.borderColor = UIColorMake(248, 248, 248).CGColor;
    self.contentText.layer.borderWidth = AUTO_MARGIN(1);
    
    self.manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    // 最多可选择数量
    self.manager.configuration.photoMaxNum   = 1;
    self.manager.configuration.albumShowMode = HXPhotoAlbumShowModeDefault;
    // 导航栏标题颜色
    self.manager.configuration.navigationTitleColor = UIColor.whiteColor;
    // 导航栏按钮颜色
    self.manager.configuration.themeColor = UIColor.whiteColor;
    
    self.manager.configuration.statusBarStyle = UIStatusBarStyleLightContent;
    
    if (self.model != nil) {
        
        self.imageData = self.model.imageData;
        UIImage *image = [UIImage sd_imageWithGIFData:self.model.imageData];
        HXCustomAssetModel *model = [HXCustomAssetModel assetWithLocalImage:image selected:YES];
        [self.manager addCustomAssetModel:@[model]];
    }
    
    self.photoView = [[HXPhotoView alloc] initWithManager:self.manager];
    self.photoView.delegate  = self;
    self.photoView.lineCount = 4;
    
    self.audioBtn = [[UIButton alloc] init];
    self.audioBtn.titleLabel.font     = AUTO_SYS_FONT(14);
    self.audioBtn.layer.borderColor   = UIColorMake(248, 248, 248).CGColor;
    self.audioBtn.layer.borderWidth   = AUTO_MARGIN(1);
    self.audioBtn.layer.cornerRadius  = AUTO_MARGIN(22);
    self.audioBtn.layer.masksToBounds = YES;
    [self.audioBtn setTitle:@"录音" forState:UIControlStateNormal];
    [self.audioBtn setTitleColor:UIColorMake(51, 51, 51) forState:UIControlStateNormal];
    [self.audioBtn addTarget:self action:@selector(audioRecordAction) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.audioBtn addTarget:self action:@selector(recordAudioAction) forControlEvents:UIControlEventTouchDragEnter];
}

- (void)setupConstraints {
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
    }];
    
    [self.contentView addSubview:self.titleText];
    [self.titleText mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(12));
        make.height.mas_offset(AUTO_MARGIN(40));
    }];
    
    [self.contentView addSubview:self.contentText];
    [self.contentText mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.titleText.mas_bottom).mas_offset(AUTO_MARGIN(12));
        make.leading.trailing.mas_equalTo(self.titleText);
        make.height.mas_offset(AUTO_MARGIN(100));
    }];
    
    [self.contentView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.contentText.mas_bottom).mas_offset(AUTO_MARGIN(12));
        make.leading.trailing.mas_equalTo(self.titleText);
        make.height.mas_offset(AUTO_MARGIN(100));
        
    }];
    
    [self.contentView addSubview:self.audioBtn];
    [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.photoView.mas_bottom).mas_offset(AUTO_MARGIN(20));
        make.leading.trailing.mas_equalTo(self.titleText);
        make.height.mas_offset(AUTO_MARGIN(44));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(12));
    }];
}

#pragma mark -- Private Methods
// 设置导航栏右侧按钮
- (void)setNavigateRightItem {
    
    UIImage *rightBtn = [[UIImage imageNamed:@"insert"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem * insertItem = [[UIBarButtonItem alloc] initWithImage:rightBtn
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(editorInfoAction)];
    self.navigationItem.rightBarButtonItems = @[insertItem];
}

- (void)audioRecordAction {
    
    self.audioBtn.selected = !self.audioBtn.selected;
    if (self.audioBtn.selected) {
        
        [[DNAudioManager defaultManeger] dn_startRecordAudio:^(NSString * _Nonnull timeLong,
                                                               NSData * _Nonnull audioData) {
            
            self.audioData = audioData;
            NSLog(@"%@", timeLong);
        }];
    } else {
        [[DNAudioManager defaultManeger] dn_stopRecordAudio];
    }
}

- (void)editorInfoAction {
    
    NSString *alertMsg = self.model == nil ? @"是否确定保存数据":@"是否确定修改数据";
    
    if (DNULLString(self.titleText.text)) {
        [DNAlert alertWithMessage:@"标题不能为空" superClass:self completeHandler:^{
            
        }];
        return;
    }
    if (DNULLString(self.contentText.text)) {
        [DNAlert alertWithMessage:@"内容不能为空" superClass:self completeHandler:^{
            
        }];
        return;
    }
    
    [DNAlert alertWithMessage:alertMsg
                   superClass:self
              completeHandler:^{
        
        DNNoteModel * model = [[DNNoteModel alloc] init];
        model.titleStr  = self.titleText.text;
        model.content   = self.contentText.text;
        model.imageData = self.imageData;
        model.audioData = self.audioData;
        model.dateStr   = [self dn_getCurrentDate];
        if (self.model == nil) {
            [[DNFMDBTool defaultManager] dn_insertData:model];
        } else {
            model.user_id = self.model.user_id;
            [[DNFMDBTool defaultManager] dn_updateData:model uid:model.user_id];
        }
                          
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNoteRecordsUpdateNotice" object:nil];
                  
        [self.navigationController popViewControllerAnimated:YES];
              
    } cancleHandler:^{
        
    }];
}

// 获取当前的日期 年月日
- (NSString *)dn_getCurrentDate {
    
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
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

@end
