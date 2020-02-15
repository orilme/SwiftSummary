//
//  LocalNotificationVC.m
//  ORIOSSummary
//
//  Created by orilme on 2019/11/17.
//  Copyright © 2019 orilme. All rights reserved.
//

#import "LocalNotificationVC.h"

@interface LocalNotificationVC ()
// 点击按钮之后添加通知
- (IBAction)addLocalNote;
@end

@implementation LocalNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (IBAction)addLocalNote {
    /*
     @property(nonatomic,copy) NSDate *fireDate; // 设置本地推送的时间
     @property(nonatomic,copy) NSTimeZone *timeZone; // 时区
     
     @property(nonatomic) NSCalendarUnit repeatInterval;     // 重复多少个单元发出一次
     @property(nonatomic,copy) NSCalendar *repeatCalendar;   // 设置日期
     
     @property(nonatomic,copy) CLRegion *region NS_AVAILABLE_IOS(8_0);  // 比如某一个区域的时候发出通知
     @property(nonatomic,assign) BOOL regionTriggersOnce NS_AVAILABLE_IOS(8_0); // 进入区域是否重复
     
     @property(nonatomic,copy) NSString *alertBody;      消息的内容
     @property(nonatomic) BOOL hasAction;                是否显示alertAction的文字(默认是YES)
     @property(nonatomic,copy) NSString *alertAction;    设置锁屏状态下,显示的一个文字
     @property(nonatomic,copy) NSString *alertLaunchImage;   启动图片
     
     @property(nonatomic,copy) NSString *soundName;      UILocalNotificationDefaultSoundName
     
     @property(nonatomic) NSInteger applicationIconBadgeNumber;  应用图标右上角的提醒数字
     
     // user info
     @property(nonatomic,copy) NSDictionary *userInfo;
     */
    // 1.创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    // 1.1.设置什么时间弹出
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
    
    // 1.2.设置弹出的内容
    localNote.alertBody = @"吃饭了吗?";
    
    // 1.3.设置锁屏状态下,显示的一个文字
    localNote.alertAction = @"快点打开";
    
    // 1.4.显示启动图片
    localNote.alertLaunchImage = @"123";
    
    // 1.5.是否显示alertAction的文字(默认是YES)
    localNote.hasAction = YES;
    
    // 1.6.设置音效
    localNote.soundName = UILocalNotificationDefaultSoundName;
    
    // 1.7.应用图标右上角的提醒数字
    localNote.applicationIconBadgeNumber = 999;
    
    // 1.8.设置UserInfo来传递信息
    localNote.userInfo = @{@"alertBody" : localNote.alertBody, @"applicationIconBadgeNumber" : @(localNote.applicationIconBadgeNumber)};
    
    // 2.调度通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

@end
