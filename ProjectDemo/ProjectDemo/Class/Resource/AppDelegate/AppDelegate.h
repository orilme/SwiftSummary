//
//  AppDelegate.h
//  ProjectDemo
//
//  Created by orilme on 2017/3/27.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//登录页面
-(void)setupLoginViewController;

//跳转到首页
-(void)setupHomeViewController;

@end

