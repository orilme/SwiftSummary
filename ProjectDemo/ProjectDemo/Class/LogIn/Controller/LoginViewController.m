//
//  LoginViewController.m
//  ProjectDemo
//
//  Created by orilme on 2017/4/1.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    //测试日志
//    DDLogError(@"测试 Error 信息");
//    DDLogWarn(@"测试 Warn 信息");
//    DDLogDebug(@"测试 Debug 信息");
//    DDLogInfo(@"测试 Info 信息");
//    DDLogVerbose(@"测试 Verbose 信息");
    
    
    //登录成功后跳转到首页
    [((AppDelegate*) AppDelegateInstance) setupHomeViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
