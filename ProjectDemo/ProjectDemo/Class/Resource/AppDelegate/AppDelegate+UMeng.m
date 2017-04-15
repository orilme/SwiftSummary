//
//  AppDelegate+UMeng.m
//  ProjectDemo
//
//  Created by orilme on 2017/4/6.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import "AppDelegate+UMeng.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation AppDelegate (UMeng)

-(void)UMengApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /* 打开日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    // 打开图片水印
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUmengKey];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    /* 钉钉的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];
    
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    
    /* 设置易信的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置点点虫（原来往）的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置领英的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
    
    /* 设置Twitter的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    
    /* 设置Facebook的appKey和UrlString */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:@"http://www.umeng.com/social"];
    
    /* 设置Pinterest的appKey */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];
    
    /* dropbox的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DropBox appKey:@"k4pn9gdwygpy4av" appSecret:@"td28zkbyb9p49xu" redirectURL:@"https://mobile.umeng.com/social"];
    
    /* vk的appkey */
    [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:@"5786123" appSecret:nil redirectURL:nil];
    
}



@end
