//
//  DNPersonController.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/16.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNPersonController.h"

@interface DNPersonController ()

@property (nonatomic, strong) UILabel * label1;
@property (nonatomic, strong) UILabel * label2;
@property (nonatomic, strong) UILabel * label3;
@property (nonatomic, strong) UIStackView * stackView;
@end

@implementation DNPersonController

#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setControlForSuper];
    [self addConstrainsForSuper];
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
    self.stackView = [[UIStackView alloc]init];
    self.stackView.backgroundColor = UIColor.grayColor;
    
    self.label1 = [UILabel dn_labelWithText:@"label1"
                                   textFont:16
                                  textColor:UIColor.lightGrayColor
                               textAligment:NSTextAlignmentCenter];
    
    self.label2 = [UILabel dn_labelWithText:@"label2"
                                   textFont:16
                                  textColor:UIColor.lightGrayColor
                               textAligment:NSTextAlignmentCenter];
    
    self.label3 = [UILabel dn_labelWithText:@"label3"
                                   textFont:16
                                  textColor:UIColor.lightGrayColor
                               textAligment:NSTextAlignmentCenter];
    
    self.label1.backgroundColor = UIColor.cyanColor;
    self.label2.backgroundColor = UIColor.cyanColor;
    self.label3.backgroundColor = UIColor.cyanColor;
    self.label1.frame = CGRectMake(0, 0, SCREEN_W*0.3, SCREEN_W*0.3);
    self.label2.frame = CGRectMake(SCREEN_W*0.35, 0, SCREEN_W*0.3, SCREEN_W*0.3);
    self.label3.frame = CGRectMake(SCREEN_W*0.7 , 0, SCREEN_W*0.3, SCREEN_W*0.3);
    
    [self.view addSubview:self.stackView];
    
    [self.stackView addSubview:self.label1];
    [self.stackView addSubview:self.label2];
    [self.stackView addSubview:self.label3];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_offset(SCREEN_W * 0.3);
    }];
    
//    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.left.bottom.mas_equalTo(self.stackView);
//        make.width.mas_offset(SCREEN_W*0.3);
//    }];
//
//    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.mas_equalTo(self.stackView.mas_centerX);
//        make.top.bottom.mas_equalTo(self.stackView);
//        make.width.mas_offset(SCREEN_W*0.3);
//    }];
//
//    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.right.bottom.mas_equalTo(self.stackView);
//        make.width.mas_offset(SCREEN_W*0.3);
//    }];
}

#pragma mark -- Target Methods

#pragma mark -- Private Methods

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
