//
//  DNCalendarNoticeManager.m
//  DNFMDBNote
//
//  Created by zjs on 2020/6/8.
//  Copyright © 2020 zjs. All rights reserved.
//

#import "DNCalendarNoticeManager.h"

#import <EventKit/EventKit.h>

static DNCalendarNoticeManager *_manager = nil;

@implementation DNCalendarNoticeManager

+ (instancetype)defaultManeger {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[self alloc] init];
        }
    });
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [super allocWithZone:zone];
        }
    });
    return _manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return _manager;
}

- (void)dn_insertEvent:(NSString *)title date:(NSString *)date {
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        
        [eventStore requestAccessToEntityType:EKEntityTypeEvent
                                   completion:^(BOOL granted, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (error) {
                    NSLog(@"添加失败：%@", error);
                } else if (!granted) {
                    NSLog(@"没有日历权限");
                } else {
                    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                    event.title    = title;
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    
                    NSDate *Date = [formatter dateFromString:date];
                    
                    // 提前一个小时开始
                    NSDate *startDate = [NSDate dateWithTimeInterval:-3600 sinceDate:Date];
                    // 提前一分钟结束
                    NSDate *endDate = [NSDate dateWithTimeInterval:60 sinceDate:Date];
                    
                    event.startDate = startDate;
                    event.endDate = endDate;
                    event.allDay = NO;
                    
                    // 添加闹钟结合（开始前多少秒）若为正则是开始后多少秒。
                    EKAlarm *elarm2 = [EKAlarm alarmWithRelativeOffset:-20];
                    [event addAlarm:elarm2];
                    EKAlarm *elarm = [EKAlarm alarmWithRelativeOffset:-10];
                    [event addAlarm:elarm];
                    
                    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"my_eventIdentifier"];
                    for (NSString *key in dict.allKeys) {
                        
                        if ([key isEqualToString:date] && [event.eventIdentifier isEqualToString:dict[key]]) {
                            
                            NSLog(@"请勿重复添加事件");
                            return;
                        }
                    }
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    
                    NSError *error = nil;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
                    
                    if (!error) {
                        NSLog(@"添加事件成功");
                        //添加成功后需要保存日历关键字
                        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
                        params[date] = event.eventIdentifier;
                        // 保存在沙盒，避免重复添加等其他判断
                        [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"my_eventIdentifier"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            });
        }];
    }
}
@end
