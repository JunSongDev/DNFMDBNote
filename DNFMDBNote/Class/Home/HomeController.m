//
//  HomeController.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "HomeController.h"
#import "DNNoteCell.h"
#import "DNNoteModel.h"
#import "DNDetailController.h"
#import "DNEditorController.h"
#import "DNPersonController.h"
#import "NSArray+Extension.h"

@interface HomeController ()

@property (nonatomic, strong) UIButton *insertButton;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *selectArr;
@end

@implementation HomeController

#pragma mark -- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Note";
    self.view.backgroundColor = RGB(245, 245, 245, 1.0);
    
    [self setControlForSuper];
    [self addConstrainsForSuper];
    
    [self setNavigationBarItem];
    
    NSArray * array = [NSArray dn_getPropertiesForModel:[DNNoteModel class]];
    NSLog(@"%@",array);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 查询数据库数据
    self.dataArr = [[DNFMDBTool defaultManager] dn_selectAllData];
    [self.tableView reloadData];
}

/**

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
    DNWeak(self);
    self.insertButton = [[UIButton alloc]init];
    [self.insertButton setBackgroundColor:UIColor.orangeColor];
    [self.insertButton setImage:IMAGE(@"insert") forState:UIControlStateNormal];
    self.insertButton.layer.cornerRadius = SCREEN_W * 0.08;
    self.insertButton.layer.masksToBounds = YES;
    
    [self.insertButton dn_addActionHandler:^{
       
        [weakself editorNoteRecord];
    }];
    
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.allowsMultipleSelectionDuringEditing = YES; // 允许多选
    [self.tableView registerClass:[DNNoteCell class] forCellReuseIdentifier:@"DNNoteCell"];
    
    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.insertButton aboveSubview:self.tableView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper {
    
    UIEdgeInsets edgs = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view).insets(edgs);
    }];
    
    [self.insertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(SCREEN_W * 0.1);
        make.width.height.mas_offset(SCREEN_W * 0.16);
    }];
}

#pragma mark -- Target Methods
- (void)editorNoteRecord {
    
    DNEditorController * vc = [[DNEditorController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftItemClick:(UIBarButtonItem *)item {
    
    self.selectArr = [NSMutableArray array];
    BOOL editing = !self.tableView.editing;
    [self.tableView setEditing:editing animated:YES];
    item.title = editing ? @"Complete":@"Edit";
    if (editing) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteClick)];
    } else {
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)deleteClick {
    
    if (self.selectArr.count <= 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"暂未选中删除的数据" preferredStyle:UIAlertControllerStyleAlert];
        
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
 
    [self.selectArr enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                 NSUInteger idx,
                                                 BOOL * _Nonnull stop) {
        // 获取储存的 model 对象
        DNNoteModel * model = obj;
        // 删除 tableView 上的数据 （表象）
        [self.dataArr removeObject:model];
        // 删除数据库中的数据（实质）
        [[DNFMDBTool defaultManager] dn_deleteDateUid:model.user_id];
        // tableView 刷新数据
        [self.tableView reloadData];
        
    }];
}

#pragma mark -- Private Methods
- (void)setNavigationBarItem {
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(leftItemClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

// 自动隐藏提示框
- (void)dismissAlert:(UIAlertController *)alert {
 
    if (alert) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -- UITableView Delegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DNNoteModel * model = self.dataArr[indexPath.section];
    DNNoteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DNNoteCell"];
    if (!cell) {
        
        cell = [[DNNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DNNoteCell"];
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.isEditing) {
        
        DNNoteModel * model = self.dataArr[indexPath.section];
        
        if ([self.selectArr containsObject:model]) {
            
            [self.selectArr removeObject:model];
        } else {
            [self.selectArr addObject:model];
        }
        
    } else {
        
        DNNoteModel * model = self.dataArr[indexPath.section];
        DNDetailController * vc = [[DNDetailController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DNNoteModel * model = self.dataArr[indexPath.section];
    if ([self.selectArr containsObject:model]) {
        
        [self.selectArr removeObject:model];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
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

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter
@end
