//
//  UMengSocialViewController.m
//  ProjectDemo
//
//  Created by orilme on 2017/4/5.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import "UMengSocialViewController.h"


@interface UMengSocialViewController ()

@property(nonatomic, strong)NSArray *platformArray;

@end

@implementation UMengSocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPageLoad];
    
    self.navigationItem.title=@"友盟分享跳转";
    [self.navigationController.tabBarItem setBadgeValue:@"2"];
    
    self.platformArray = @[@"5", @"2", @"1", @"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 页面布局

-(void)initPageLoad {
    UIButton *qqBtn=[UIButton new];
    qqBtn.backgroundColor = [UIColor redColor];
    qqBtn.tag=0;
    [qqBtn setTitle:@"QQ空间分享" forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).with.offset(100);
        make.centerX.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    
    UIButton *wechatBtn=[UIButton new];
    wechatBtn.backgroundColor = [UIColor blueColor];
    wechatBtn.tag=1;
    [wechatBtn setTitle:@"微信朋友圈" forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatBtn];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(qqBtn.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    
    UIButton *wechatfriendBtn=[UIButton new];
    wechatfriendBtn.backgroundColor = [UIColor greenColor];
    wechatfriendBtn.tag=2;
    [wechatfriendBtn setTitle:@"微信好友" forState:UIControlStateNormal];
    [wechatfriendBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatfriendBtn];
    [wechatfriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wechatBtn.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    
    UIButton *weiboBtn=[UIButton new];
    weiboBtn.backgroundColor = [UIColor purpleColor];
    weiboBtn.tag=3;
    [weiboBtn setTitle:@"新浪微博分享" forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboBtn];
    [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wechatfriendBtn.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    
}

-(void)btnPressed:(id)sender {
    UIButton *btn=(UIButton *)sender;
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"ProjectDemo分享";
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:[self.platformArray[btn.tag] intValue] messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
    
}

@end

