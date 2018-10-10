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

@property (nonatomic, strong) UIButton * insertButton;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NSMutableArray * topArray;
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
    self.dataArr = [DNDBTools dn_selectAllData];
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
- (void)setControlForSuper
{
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
    [self.tableView registerClass:[DNNoteCell class] forCellReuseIdentifier:@"DNNoteCell"];
    
    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.insertButton aboveSubview:self.tableView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
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

- (void)leftItemClick {
    
    DNLog(@"left");
//    DNPersonController * vc = [[DNPersonController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- Private Methods

- (void)setNavigationBarItem {
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                               target:self
                                                                               action:@selector(leftItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        
        cell = [[DNNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DNNoteCell"];
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DNNoteModel * model = self.dataArr[indexPath.section];
    DNDetailController * vc = [[DNDetailController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
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
        [DNDBTools dn_deleteDate:model.modelID];
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
// tableView 编辑类型
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return UITableViewCellEditingStyleDelete;
//}
// tableView 进行删除是的操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    DNNoteModel * model = self.dataArr[indexPath.section];
//    // 删除 tableView 上的数据 （表象）
//    [self.dataArr removeObjectAtIndex:indexPath.section];
//    // 删除数据库中的数据（实质）
//    [DNDBTools dn_deleteDate:model.modelID];
//    // tableView 刷新数据
//    [self.tableView reloadData];
//}

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

- (NSMutableArray *)topArray {
    if (!_topArray) {
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}

@end
