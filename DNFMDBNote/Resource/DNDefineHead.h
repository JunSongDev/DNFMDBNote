//
//  DNDefineHead.h
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#ifndef DNDefineHead_h
#define DNDefineHead_h

#define APIKEY @"Tuac9Cl4RQFT3S8ijAfjxHATHk4BZabc"
#define PDESKEY @"asfdweyeyrVgOV4P8Uf70REVpIw3iVNwNs"

#ifdef DEBUG
#define DNLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else

#define DNLog(...);

#endif

// 微信 APPID
#define WeChatID            @"wx7831453201ed8c7f"

// 域名
//#define HOST                @"http://52.77.241.64:8089/"
//#define HOST                @"http://103.195.187.79:8089/"
#define HOST                @"http://admin.qianbao8.top/"

// 后台返回的 message
#define MESSAGE             @"message"

// 数据本地保存
#define USERINFO            @"USERINFO"

// 取字符串对应数字
#define INTAGER(name)       [name integerValue]


// keyWindow
#define  ToastWindows       [UIApplication sharedApplication].delegate.window

#define APPLICATION         [UIApplication sharedApplication].delegate

// weak 弱引用
#define DNWeak(name)        __weak typeof(name) weak##name = name

// 图片
#define IMAGE(name)         [UIImage imageNamed:name]

// 颜色
#define RGB(r, g, b, a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define tableViewColor      RGB(225, 225, 225, 0.6)
// barTinColor
#define barColor            RGB(28, 28, 28, 1.0)
// barTitle
#define barTitle            RGB(237, 193, 115, 1.0)
// 屏幕宽高
#define SCREEN_W            [UIScreen mainScreen].bounds.size.width
#define SCREEN_H            [UIScreen mainScreen].bounds.size.height
// 自适应字体大小
#define fontSize(size)      size*(SCREEN_W/375.0)
#define systemFont(size)    [UIFont systemFontOfSize:fontSize(size)]
// 边距
#define spaceSize(space)     space*(SCREEN_W/375.0)

// tableView 的行高
#define tableHeight         SCREEN_WIDTH <= 320 ? 44 : 50

// iPhoneX适配
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//Iphone4S
#define iPhone4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)

// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)

// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)

// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

// 空字符串
#define DNULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 || [string isEqual:@"NULL"] ||  [string isEqual:NULL]||[[string class] isSubclassOfClass:[NSNull class]] || string == NULL || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])

// 空数组
#define NUllArr(array) (array.count <= 0 || [array isKindOfClass:[NSNull class]] || array == nil)

// 空字典
#define NUllDict(dict) (dict == nil || [dict isKindOfClass:[NSNull class]] || dict.count <= 0)

#endif /* DNDefineHead_h */
