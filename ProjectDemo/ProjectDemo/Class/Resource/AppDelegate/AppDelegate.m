//
//  AppDelegate.m
//  ProjectDemo
//
//  Created by orilme on 2017/3/27.
//  Copyright © 2017年 orilme. All rights reserved.
//

//设置启动页 1.添加启动页图片  2.LaunchScreen.xib 把Use as launch Srceen取消掉,这个就是你之前一直设置Launch  3.单击你整个项目名称,然后选择General, 设置Launch Images source 为lanuchImage  ，launch Screen File 为空
//启动页尺寸：640x960
//          640x1136
//          750x1334
//          1242x2208

#import "AppDelegate.h"
#import "SYSafeCategory.h"//统一处理一些为数组、集合等对nil插入会引起闪退

#import "introductoryPagesHelper.h"//引导页，需要添加Tool中的引导页文件夹，同时导入三方库GVUserDefaults，和category中的GVUserDefaults+BBProperties文件
#import "AdvertiseHelper.h"//启动广告

#import "LoginViewController.h"//登录
#import "ORHomeViewController.h"//公共controller

#import "MPLocationManager.h"//自己的定位管理的类，需要添加Tool中的定位管理文件夹

#import "iflyMSC/IFlyFaceSDK.h"//科大讯飞  人脸识别   需要导入SDK

#import "JSPatchHelper.h"//热更新，需要添加Tool中的热更新文件夹

//友盟第三方登录和分享用
//1.导入友盟的sdk
//2.在AppDelegate加入友盟的AppDelegate+UMeng
//3.plist中加入LSApplicationQueriesSchemes，URL types
//4.如果要测试友盟三方登陆，请把Bundleid 设为 com.Umeng.UMSocial（友盟官方的bundleid）
#import "AppDelegate+UMeng.h"

//友盟统计的使用
//1.导入友盟的sdk
//2.拖入友盟的友盟管理文件夹（Tool）
//3.启动友盟统计（[MPUmengHelper UMAnalyticStart];），导入头文件#import "MPUmengHelper.h"
#import "MPUmengHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //统一处理一些为数组、集合等对nil插入会引起闪退
    [SYSafeCategory callSafeCategory];
    
    //友盟三方登陆和分享用
    [self UMengApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    //启动友盟统计
    [MPUmengHelper UMAnalyticStart];
    
    //科大讯飞 配置文件
    [self makeConfiguration];
    
    //热更新加载
    [JSPatchHelper HSDevaluateScript];
    
    //地图定位初始化
    [MPLocationManager installMapSDK];
    
    
    //百度地图定位
    [[MPLocationManager shareInstance] startBMKLocationWithReg:^(BMKUserLocation *loction, NSError *error) {
        if (error) {
            //DDLogError(@"定位失败,失败原因：%@",error);
        }
        else
        {
            //DDLogError(@"定位信息：%f,%f",loction.location.coordinate.latitude,loction.location.coordinate.longitude);
            
            CLGeocoder *geocoder=[[CLGeocoder alloc]init];
            [geocoder reverseGeocodeLocation:loction.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                //处理手机语言 获得城市的名称（中文）
                NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
                NSString *currentLanguage = [userDefaultLanguages objectAtIndex:0];
                //如果不是中文 则强制先转成中文 获得后再转成默认语言
                if (![currentLanguage isEqualToString:@"zh-Hans"]&&![currentLanguage isEqualToString:@"zh-Hans-CN"]) {
                    //IOS9前后区分
                    if (isIOS9) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-Hans-CN", nil] forKey:@"AppleLanguages"];
                    }
                    else
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-Hans", nil] forKey:@"AppleLanguages"];
                    }
                }
                
                //转换地理信息
                if (placemarks.count>0) {
                    CLPlacemark *placemark=[placemarks objectAtIndex:0];
                    //获取城市
                    NSString *city = placemark.locality;
                    if (!city) {
                        //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                        city = placemark.administrativeArea;
                    }
                    
                    NSLog(@"百度当前城市：[%@]",city);
                    
                    // 城市名传出去后,立即 Device 语言 还原为默认的语言
                    [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
                }
            }];
        }
    }];
    
    //系统自带定位
//    [[MPLocationManager shareInstance]  startSystemLocationWithRes:^(CLLocation *loction, NSError *error) {
//        DDLogError(@"系统自带定位信息：%f,%f",loction.coordinate.latitude,loction.coordinate.longitude);
//    }];
    
    //加载页面
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupLoginViewController];
    
    //引导页面加载
    [self setupIntroductoryPage];
    
    //启动广告（记得放最后，才可以盖在页面上面）
    [self setupAdveriseView];
    
    return YES;
}

#pragma mark 引导页
-(void)setupIntroductoryPage {
    if (BBUserDefault.isNoFirstLaunch)
    {
        return;
    }
    BBUserDefault.isNoFirstLaunch=YES;
    NSArray *images=@[@"introductoryPage1",@"introductoryPage2",@"introductoryPage3",@"introductoryPage4"];
    [introductoryPagesHelper showIntroductoryPageView:images];
}

#pragma mark 启动广告
-(void)setupAdveriseView {
    // TODO 请求广告接口 获取广告图片
    
    //现在了一些固定的图片url代替
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    
    [AdvertiseHelper showAdvertiserView:imageArray];
}

#pragma mark 自定义跳转不同的页面
//登录页面
-(void)setupLoginViewController {
    LoginViewController *logInVc = [[LoginViewController alloc]init];
    self.window.rootViewController = logInVc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

//首页
-(void)setupHomeViewController {
    ORHomeViewController *tabBarController = [[ORHomeViewController alloc] init];
    [self.window setRootViewController:tabBarController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}


#pragma mark --- 科大讯飞配置文件
-(void)makeConfiguration {
    
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,",USER_APPID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

#pragma mark --- 热更新
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //热更新JS文件下载 最好做一个时间限制 比如隔多久进行下载(间隔一小时)
    [JSPatchHelper loadJSPatch];
}

#pragma mark --- 友盟
//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
