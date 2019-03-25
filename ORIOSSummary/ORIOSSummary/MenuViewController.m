//
//  MenuViewController.m
//  GCD
//
//  Created by orilme on 2018/7/28.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "MenuViewController.h"
#import "CoreMotionVC.h"
#import "ProximityMonitorVC.h"

@interface MenuViewController ()
@property (nonatomic, copy) NSArray *meunVCArr;
@property (nonatomic, copy) NSArray *meunTitleArr;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.meunVCArr = @[@"CoreMotionVC", @"ProximityMonitorVC", @"CoreMotionExampleVC", @"AddressBookUIVC", @"AddressBookVC", @"GCDVC", @"GCDBarrierVC", @"NSOperationVC", @"NSThreadVC"];
    self.meunTitleArr = @[@"CoreMotion(陀螺仪、陀螺仪、加速剂)", @"距离传感器、摇一摇", @"加速计举例", @"通讯录有UI", @"通讯录无UI", @"GCD", @"GCDBarrier", @"NSOperation", @"NSThread"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.meunVCArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =  self.meunTitleArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [[NSClassFromString(self.meunVCArr[indexPath.row]) alloc]init];
    vc.title = self.meunVCArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
