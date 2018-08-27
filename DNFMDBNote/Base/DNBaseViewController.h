//
//  DNBaseViewController.h
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// 用于传值
@property (nonatomic,   copy) NSString     * baseStr;
@property (nonatomic, strong) NSArray      * baseArr;
@property (nonatomic, strong) NSDictionary * baseDict;
// tableView
@property (nonatomic, strong) UITableView  * tableView;

@end
