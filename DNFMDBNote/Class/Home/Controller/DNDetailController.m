//
//  DNDetailController.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNDetailController.h"

@interface DNDetailController ()

@property (nonatomic, strong) UITextView * textView;
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
    self.textView = [[UITextView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.textView.font = systemFont(15);
    self.textView.text = self.model.content;
    
    [self.view addSubview:self.textView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    
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
                  model.user_id  = self.model.user_id;
                  model.modelID  = self.model.modelID;
                  model.content  = self.textView.text;
                  model.dayDate  = [self getCurrentDayDate];
                  model.timeDate = [self getCurrentTimeDate];
                  model.timeline = [self getCurrentTimeLine];
                  
                  [[DNFMDBTool defaultManager] dn_updateData:model uid:model.user_id];
                  
                  [self.navigationController popViewControllerAnimated:YES];
    
              } cancleHandler:^{
        
              }];
}

#pragma mark -- Private Methods

- (void)setNavigateRightItem {
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(updateData)];
    self.navigationItem.rightBarButtonItem = rightItem;
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
