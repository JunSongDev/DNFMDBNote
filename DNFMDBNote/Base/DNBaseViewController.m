//
//  DNBaseViewController.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNBaseViewController.h"

static NSString * identifier = @"cell";

@interface DNBaseViewController ()

@end

@implementation DNBaseViewController

#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
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
    
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{

}

#pragma mark -- Target Methods

#pragma mark -- Private Methods

#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        //_tableView.backgroundColor = tableViewColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        if(@available(iOS 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}
@end
