//
//  MutexLockOCVC.m
//  ORSwiftSummary
//
//  Created by orilme on 2021/3/30.
//  Copyright © 2021 orilme. All rights reserved.
//

#import "MutexLockOCVC.h"

@interface MutexLockOCVC () {
    int _tickets;
    int _tickets2;
}

@end

@implementation MutexLockOCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tickets = 5;
    _tickets2 = 5;

    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(30, 100, 200, 100)];
    [button1 setTitle: @"nsConditio" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(testSaleTicketsError) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor redColor];
    [self.view addSubview:button1];
    
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(30, 230, 200, 100)];
    [button2 setTitle: @"nsConditio" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(testSaleTickets) forControlEvents:UIControlEventTouchUpInside];
    button2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button2];
}

- (void)testSaleTicketsError {
    NSThread *threadOne = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicketsError) object:nil];
    NSThread *threadTwo = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicketsError) object:nil];
    [threadOne start];
    [threadTwo start];
}

- (void)saleTicketsError {
    NSObject *object = [[NSObject alloc]init];
    while (1) {
        @synchronized(object) {
            [NSThread sleepForTimeInterval:1];
            if (_tickets > 0) {
                _tickets --;
                NSLog(@"剩余票数= %d", _tickets);
            } else {
                NSLog(@"票卖没了");
                break;
            }
        }
    }
}

- (void)testSaleTickets {
    NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTickets) object:nil];
    NSThread *thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTickets) object:nil];
    [thread1 start];
    [thread2 start];
}

- (void)saleTickets {
    while (1) {
        @synchronized(self) {
            [NSThread sleepForTimeInterval:1];
            if (_tickets2 > 0) {
                _tickets2 --;
                NSLog(@"2---剩余票数= %d", _tickets2);
            } else {
                NSLog(@"2---票卖没了");
                break;
            }
        }
    }
}

@end
