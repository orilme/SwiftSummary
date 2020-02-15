//
//  NormalDemoVC.m
//  GCD
//
//  Created by orilme on 2018/7/28.
//  Copyright © 2018年 orilme. All rights reserved.
//  常用demo

#import "NormalDemoVC.h"

@interface NormalDemoVC ()
@property (nonatomic, copy) NSArray *meunArr;
@end

@implementation NormalDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.navigationItem.title = @"常用demo~~";
    self.meunArr = @[

    @{@"menuName": @"轮播图", @"className": @"CarouselOneVC"},
    @{@"menuName": @"转盘", @"className": @"WheelVC"},
    
    @{@"menuName": @"我的界面-仿简书", @"className": @"MineJianShuVC"},
    @{@"menuName": @"header图片下拉拉伸", @"className": @"HeaderStretchVC"},
    
    /// 地图
    @{@"menuName": @"苹果地图-CoreLocationVC", @"className": @"CoreLocationVC"},
    @{@"menuName": @"苹果地图-MapKit", @"className": @"MKMapViewVC"},
    @{@"menuName": @"苹果地图-大头针", @"className": @"MKMapAnnotationVC"},
    @{@"menuName": @"苹果地图-导航", @"className": @"MKMapNavigationVC"},
    @{@"menuName": @"苹果地图-画线", @"className": @"MKMapDrawLineVC"},
        
    ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.meunArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =  self.meunArr[indexPath.row][@"menuName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.meunArr[indexPath.row];
    UIViewController *vc = [[NSClassFromString(dict[@"className"]) alloc]init];
    vc.title = dict[@"menuName"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
