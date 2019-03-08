//
//  DNEditorController.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNEditorController.h"
#import "DNPickerCollectionCell.h"
#import "DNNoteModel.h"
#import "UITextView+Extra.h"

@interface DNEditorController ()<UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *photoArr;
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
    self.photoArr = [NSMutableArray arrayWithObjects:@"", nil];
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
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.collectionView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_offset(SCREEN_W);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.collectionView.mas_top).mas_offset(-5);
    }];
}

#pragma mark -- Target Methods

- (void)insertData {
    
    if (DNULLString(self.textView.text)) {
        
        DNLog(@"内容不能为空");
        //[DNAlert alertWithMessage:@"内容不能为空" superClass:self];
        return;
    }
    
    [DNAlert alertWithMessage:@"是否要保存数据"
                   superClass:self
              completeHandler:^{
        
                  DNNoteModel * model = [[DNNoteModel alloc] init];
                  model.content  = self.textView.text;
                  model.dayDate  = [self getCurrentDayDate];
                  model.timeDate = [self getCurrentTimeDate];
                  model.timeline = [self getCurrentTimeLine];
                  
                  [[DNFMDBTool defaultManager] dn_insertData:model];
                  
                  [self.navigationController popViewControllerAnimated:YES];
    
              } cancleHandler:^{
        
              }];
}

#pragma mark -- Private Methods
// 设置导航栏右侧按钮
- (void)setNavigateRightItem {
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(insertData)];
    self.navigationItem.rightBarButtonItem = rightItem;
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
/**
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return <#section#>;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return <#row#>;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 return <# UITableViewCell #>;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 return <#height#>;
 }
 */

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    NSString *str = self.photoArr[indexPath.row];
    if (DNULLString(str)) {
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        browser.autoPlayOnAppear = NO; // Auto-play first video
        
        // Customise selection images to change colours if required
//        browser.customImageSelectedIconName = @"ImageSelected.png";
//        browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
        
        // Optionally set the current visible photo before displaying
        [browser setCurrentPhotoIndex:1];
        
        // Present
        [self.navigationController pushViewController:browser animated:YES];
    } else {
     
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
 
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    return self.photoArr.count >= 9 ? 9 : self.photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DNPickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DNPickerCollectionCell" forIndexPath:indexPath];
    
    cell.imageName = self.photoArr[indexPath.row];
    return cell;
}

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter
- (UICollectionView *)collectionView {
 
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_W/3-2, SCREEN_W/3-2);
        flowLayout.minimumLineSpacing      = 6.f;
        flowLayout.minimumInteritemSpacing = 6.f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[DNPickerCollectionCell class] forCellWithReuseIdentifier:@"DNPickerCollectionCell"];
    }
    return _collectionView;
}
@end
