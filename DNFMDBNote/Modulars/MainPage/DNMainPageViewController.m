//
//  DNMainPageViewController.m
//  DNFMDBNote
//
//  Created by zjs on 2020/6/6.
//  Copyright © 2020 zjs. All rights reserved.
//

#import "DNMainPageViewController.h"
#import "DNEditorInfoViewController.h"

#import "DNMainPageNoteCell.h"

#import "DNNoteModel.h"

@interface DNMainPageViewController ()

@property (nonatomic, strong) UIButton *insertButton;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation DNMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"记事本";
    
    [self setupSubviews];
    [self setupConstraints];
    
    [self reloadNoteRecords];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNoteRecords) name:@"kNoteRecordsUpdateNotice" object:nil];
    // Do any additional setup after loading the view.
}

- (void)setupSubviews {
    
    DNWeak(self);
    self.insertButton = [[UIButton alloc]init];
    [self.insertButton setBackgroundColor:UIColor.orangeColor];
    [self.insertButton setImage:IMAGE(@"insertData") forState:UIControlStateNormal];
    self.insertButton.layer.cornerRadius = SCREEN_W * 0.08;
    self.insertButton.layer.masksToBounds = YES;
    
    [self.insertButton dn_addActionHandler:^{
       
        [weakself editorNoteRecord];
    }];
    
    self.tableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor    = RGB(248, 248, 248, 1);
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight          = UITableViewAutomaticDimension;
    [self.tableView registerClass:[DNMainPageNoteCell class] forCellReuseIdentifier:@"DNMainPageNoteCell"];
    
    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.insertButton aboveSubview:self.tableView];
}

- (void)setupConstraints {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.insertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(SCREEN_W * 0.1);
        make.width.height.mas_offset(SCREEN_W * 0.16);
    }];
}

#pragma mark -- Target Methods
- (void)editorNoteRecord {
    
    DNEditorInfoViewController * vc = [[DNEditorInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- Private Methods
- (void)reloadNoteRecords {
    
    self.dataArr = [[DNFMDBTool defaultManager] dn_selectAllData];
    [self.tableView reloadData];
}

#pragma mark -- UITableView Delegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DNNoteModel *model = self.dataArr[indexPath.section];
    DNMainPageNoteCell  *cell  = [tableView dequeueReusableCellWithIdentifier:@"DNMainPageNoteCell"];
    if (!cell) {
        cell = [[DNMainPageNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DNMainPageNoteCell"];
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DNNoteModel * model = self.dataArr[indexPath.section];
    DNEditorInfoViewController * vc = [[DNEditorInfoViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

// tableView 是否为可编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

/**
 *  自定义 tableViewCell 的左滑编辑按钮
 *  若滑动至最左边则执行第一个添加按钮的响应方法
 */
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction * rowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        action.backgroundColor = UIColor.redColor;
        
        DNNoteModel * model = self.dataArr[indexPath.section];
        // 删除 tableView 上的数据 （表象）
        [self.dataArr removeObjectAtIndex:indexPath.section];
        // 删除数据库中的数据（实质）
        [[DNFMDBTool defaultManager] dn_deleteDateUid:model.user_id];
        // tableView 刷新数据
        [self.tableView reloadData];
    }];
    
    UITableViewRowAction * rowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        id obj = self.dataArr[indexPath.section];
        [self.dataArr removeObject:obj];
        [self.dataArr insertObject:obj atIndex:0];
        [self.tableView reloadData];
    }];
    
    rowAction2.backgroundColor = UIColor.redColor;
    
    NSArray * array = @[rowAction1,rowAction2];
    
    return array;
}

@end
