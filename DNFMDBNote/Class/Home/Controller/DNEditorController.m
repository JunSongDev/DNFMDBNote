//
//  DNEditorController.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNEditorController.h"

@interface DNEditorController ()

@property (nonatomic, strong) UITextView * textView;
@end

@implementation DNEditorController

#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Editor";
    
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
    self.textView = [[UITextView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.textView.font = systemFont(15);
    
    [self.view addSubview:self.textView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    
}

#pragma mark -- Target Methods

- (void)insertData {
    
    if (NULLString(self.textView.text)) {
        
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
                  
                  [DNDBTools dn_insertData:model];
                  
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

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
