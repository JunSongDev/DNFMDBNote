//
//  DNTabBarController.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNTabBarController.h"
#import "DNNavigationController.h"

@interface DNTabBarController ()

@end

@implementation DNTabBarController

#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBarTheme];
    [self setControlForSuper];
    // Do any additional setup after loading the view.
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
    UIViewController * wallet = [[UIViewController alloc]init];
    DNNavigationController * walletVc = [[DNNavigationController alloc]initWithRootViewController:wallet
                                                                                            title:@"钱包"
                                                                                      normalImage:@"首页灰色_03"
                                                                                      selectImage:@"首页-0"];
    
    UIViewController * market = [[UIViewController alloc]init];
    DNNavigationController * marketVc = [[DNNavigationController alloc]initWithRootViewController:market
                                                                                            title:@"行情"
                                                                                      normalImage:@"行情灰色"
                                                                                      selectImage:@"行情_07"];
    
    UIViewController * fastNews = [[UIViewController alloc]init];
    DNNavigationController * fastNewsVc = [[DNNavigationController alloc]initWithRootViewController:fastNews
                                                                                              title:@"快讯"
                                                                                        normalImage:@"资讯灰色"
                                                                                        selectImage:@"资讯_03"];
    
    UIViewController * mine = [[UIViewController alloc]init];
    DNNavigationController * mineVc = [[DNNavigationController alloc]initWithRootViewController:mine
                                                                                          title:@"设置"
                                                                                    normalImage:@"设置灰色"
                                                                                    selectImage:@"设置_31"];
    
    self.viewControllers = @[walletVc,marketVc,fastNewsVc,mineVc];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{

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

- (void)setupTabBarTheme
{
    UITabBar * tabBar = [UITabBar appearance];
    tabBar.tintColor  = barColor;
}

#pragma mark -- Setter && Getter


@end
