//
//  DNNavigationController.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNNavigationController.h"

@interface DNNavigationController ()

@end

@implementation DNNavigationController

#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarTheme];
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
    
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{

}

#pragma mark -- Target Methods

// 自定义初始化方法
- (instancetype)initWithRootViewController:(UIViewController *)root
                                     title:(NSString *)title
                               normalImage:(NSString *)nomalImage
                               selectImage:(NSString *)selectImage
{
    self = [super initWithRootViewController:root];
    if (self)
    {
        // 标题
        self.tabBarItem.title = title;
        // 未选中状态的图片
        self.tabBarItem.image = [[UIImage imageNamed:nomalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 选中状态的图片
        self.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

#pragma mark -- Private Methods

/**
 导航栏设置
 */
- (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    // 设置标题 按钮
    NSMutableDictionary *textAttrs            = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = UIColor.whiteColor;
    textAttrs[NSFontAttributeName]            = systemFont(17);
    [appearance setTitleTextAttributes:textAttrs];
    
    [appearance setBackgroundImage:[UIImage dn_imageWithColor:UIColor.orangeColor]
                    forBarPosition:UIBarPositionAny
                        barMetrics:UIBarMetricsDefault];

    [appearance setShadowImage:[[UIImage alloc]init]];
    
    [appearance setTranslucent:NO];
    appearance.tintColor = UIColor.whiteColor;
    // 设置导航栏背景颜色
    appearance.barTintColor = UIColor.orangeColor;
    // 设置状态样式
    appearance.barStyle = UIBarStyleBlackOpaque;
}

// 重写 push 方法，push 时隐藏 TabBar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0)
    {
        
//        // 禁用系统的 pop 手势
//        self.interactivePopGestureRecognizer.enabled = NO;
//        // 获取系统自带的手势对象
//        id targer = self.interactivePopGestureRecognizer.delegate;
//        // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//        UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:targer action:@selector(handleNavigationTransition:)];
//        // 设置手势代理，拦截手势触发
//        panGesture.delegate = self;
//        // 导航控制器的 view 添加全屏手势
//        [self.view addGestureRecognizer:panGesture];
        
        // 跳转时隐藏 tabBar
        viewController.hidesBottomBarWhenPushed = YES;
        
//        // 自定义导航栏返回按钮
//        UIButton * navBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//        // 返回按钮的图片
//        [navBack setImage:IMAGE(@"页面返回按钮_03") forState:UIControlStateNormal];
//        // 设置按钮的对齐方式
//        navBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        // 设置按钮的内边距（左侧贴近边缘）
//        [navBack setImageEdgeInsets:UIEdgeInsetsMake(0, -spaceSize(15), 0, 0)];
//        // 按钮添加点击事件
//        [navBack addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
//        // 将按钮添加到导航栏上
//        UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:navBack];
//        viewController.navigationItem.leftBarButtonItem = left;
        
        //        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[IMAGE(@"页面返回按钮_03") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
        //                                                                                           style:UIBarButtonItemStylePlain
        //                                                                                          target:self
        //                                                                                          action:@selector(backClick:)];
    }
    
    /** 放在 if 语句之后 ！！！！！！ */
    [super pushViewController:viewController animated:animated];
}

- (void)handleNavigationTransition:(id)sender
{
    
}

// pop 点击相应事件
- (void)backClick:(id)sender
{
    [self popViewControllerAnimated:YES];
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
