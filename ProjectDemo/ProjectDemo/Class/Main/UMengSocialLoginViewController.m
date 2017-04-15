//
//  UMengSocialLoginViewController.m
//  ProjectDemo
//
//  Created by orilme on 2017/4/5.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import "UMengSocialLoginViewController.h"
#import <UShareUI/UMSocialUIUtility.h>

@interface UMengSocialLoginViewController ()

@property(nonatomic, strong)NSArray *platformArray;

@end

@implementation UMengSocialLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"友盟第三方登录";
    //测试第三方登录
    [self initPageLoad];

    self.platformArray = @[@"4", @"1", @"0"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 布局
-(void)initPageLoad {
    UIButton *qqBtn=[UIButton new];
    qqBtn.backgroundColor = [UIColor blueColor];
    qqBtn.tag = 0;
    [qqBtn setTitle:@"QQ登录" forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).with.offset(80);
        make.centerX.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    
    UIButton *wechatBtn=[UIButton new];
    wechatBtn.tag = 1;
    wechatBtn.backgroundColor = [UIColor redColor];
    [wechatBtn setTitle:@"微信登录" forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatBtn];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(qqBtn.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    
    UIButton *weiboBtn=[UIButton new];
    weiboBtn.tag = 2;
    weiboBtn.backgroundColor = [UIColor purpleColor];
    [weiboBtn setTitle:@"新浪微博登录" forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboBtn];
    [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wechatBtn.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    
    if ([WXApi isWXAppInstalled]) {
        
    }else {
        wechatBtn.hidden=YES;
        NSLog(@"微信客户端没有安装，要把页面的微信隐藏起来，否则会被拒绝上架");
    }
    
    if ([QQApiInterface isQQInstalled]){
    }else {
        qqBtn.hidden=YES;
        NSLog(@"QQ客户端没有安装，要把页面的QQ隐藏起来，否则会被拒绝上架");
    }
    
    if ([WeiboSDK isCanShareInWeiboAPP]){
        
    }else {
        weiboBtn.hidden=YES;
        NSLog(@"新浪客户端没有安装，要把页面的新浪隐藏起来，否则会被拒绝上架");
    }
}

-(void)btnPressed:(UIButton *)btn {
    [self umShareLogin:btn.tag];
}

#pragma mark 第三方登录

-(void)umShareLogin:(NSInteger) num {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:[self.platformArray[num] intValue] currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"failed=====%@", error);
        } else {
            NSString *message = nil;
            
            if (error) {
                message = [NSString stringWithFormat:@"Get info fail:\n%@", error];
                UMSocialLogInfo(@"Get info fail with error %@",error);
            }else{
                if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                    
                    UMSocialUserInfoResponse *resp = result;
                    
                    message = [self authInfoString:resp];
                    NSLog(@"====三方登录获取信息:=====%@========", message);
                }else{
                    message = @"Get info fail";
                }
            }
        }
    }];
    
}

- (NSString *)authInfoString:(UMSocialUserInfoResponse *)resp {
    NSMutableString *string = [NSMutableString new];
    if (resp.uid) {
        [string appendFormat:@"uid = %@\n", resp.uid];
    }
    if (resp.openid) {
        [string appendFormat:@"openid = %@\n", resp.openid];
    }
    if (resp.accessToken) {
        [string appendFormat:@"accessToken = %@\n", resp.accessToken];
    }
    if (resp.refreshToken) {
        [string appendFormat:@"refreshToken = %@\n", resp.refreshToken];
    }
    if (resp.expiration) {
        [string appendFormat:@"expiration = %@\n", resp.expiration];
    }
    if (resp.name) {
        [string appendFormat:@"name = %@\n", resp.name];
    }
    if (resp.iconurl) {
        [string appendFormat:@"iconurl = %@\n", resp.iconurl];
    }
    if (resp.unionGender) {
        [string appendFormat:@"gender = %@\n", resp.unionGender];
    }
    return string;
}

@end
