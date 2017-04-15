//
//  ORHomeViewController.h
//  ProjectDemo
//
//  Created by orilme on 2017/4/5.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLTabBarController.h"
#import "ORBaseNavigationController.h"

//底部四个ViewController
#import "UMengSocialLoginViewController.h"//首页，友盟三方登录
#import "UMengSocialViewController.h"//友盟分享
//#import "MPDiscoveryViewController.h"//发现
//#import "MPMoreViewController.h"//功能导航
//
//#import "BaiDuMapViewController.h"

@interface ORHomeViewController : CYLTabBarController<UITabBarControllerDelegate>

@end
