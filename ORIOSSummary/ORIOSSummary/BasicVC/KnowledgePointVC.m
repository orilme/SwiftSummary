//
//  KnowledgePointVC.m
//  ORIOSSummary
//
//  Created by orilme on 2019/11/30.
//  Copyright © 2019 orilme. All rights reserved.
//  知识点

#import "KnowledgePointVC.h"
#import "UIDynamicController.h"

@interface KnowledgePointVC ()
@property (nonatomic, copy) NSArray *meunArr;
@end

@implementation KnowledgePointVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.navigationItem.title = @"基础知识点~~";
    self.meunArr = @[
    @{@"menuName": @"知识点", @"className": @"BasicKnowledgeVC"},
    //
    @{@"menuName": @"算法-递归", @"className": @"RecursiveVC"},
    @{@"menuName": @"VC生命周期", @"className": @"LifeCycleOneVC"},
    @{@"menuName": @"继承", @"className": @"InheritVC"},
    @{@"menuName": @"枚举", @"className": @"EnumVC"},
    @{@"menuName": @"分类和类扩展", @"className": @"CategoryVC"},
    @{@"menuName": @"协议", @"className": @"ProtocolVC"},
    @{@"menuName": @"Block", @"className": @"BlockVC"},
    @{@"menuName": @"单例", @"className": @"SingletonVC"},
    // Runtime
    @{@"menuName": @"Runtime探索", @"className": @"RuntimeExploreVC"},
    @{@"menuName": @"RuntimeResolveMethod", @"className": @"RuntimeResolveMethodVC"},
    @{@"menuName": @"RuntimeForwardMethod", @"className": @"RuntimeForwardMethodVC"},
    @{@"menuName": @"RuntimeSignatureMethod", @"className": @"RuntimeResolveMethodVC"},
    //
    @{@"menuName": @"RunLoop", @"className": @"RunLoopVC"},
    // 多线程
    @{@"menuName": @"GCD", @"className": @"GCDVC"},
    @{@"menuName": @"GCDBarrier", @"className": @"GCDBarrierVC"},
    @{@"menuName": @"GCDGroupDemo", @"className": @"GCDGroupDemoVC"},
    @{@"menuName": @"NSOperation", @"className": @"NSOperationVC"},
    @{@"menuName": @"NSThread", @"className": @"NSThreadVC"},
    @{@"menuName": @"锁(NSLock、@synchronized、NSCondition)", @"className": @"ThreadLockVC"},
    // 内存管理
    @{@"menuName": @"AutoreleasePool", @"className": @"AutoreleasePoolVC"},
    @{@"menuName": @"引用计数", @"className": @"MemManagementCountVC"},
    // 通知
    @{@"menuName": @"Notification", @"className": @"NotificationVC"},
    @{@"menuName": @"通知-本地通知", @"className": @"LocalNotificationVC"},
    @{@"menuName": @"KVC", @"className": @"KVCViewController"},
    @{@"menuName": @"KVO", @"className": @"KVOViewController"},
    // 自定义视图
    @{@"menuName": @"Quartz2D", @"className": @"Quartz2DVC"},
    @{@"menuName": @"CoreGraphics(UIBezierPath)", @"className": @"CoreGraphicsVC"},
    @{@"menuName": @"CoreGraphics2(UIBezierPath)", @"className": @"CoreGraphicsTwoVC"},
    @{@"menuName": @"CALayer基本使用(拉伸、旋转、圆角图片、CALayer)", @"className": @"CALayerVC"},
    @{@"menuName": @"自定义图层（位置和锚点）", @"className": @"CALayerCustomVC"},
    @{@"menuName": @"DrawRect示例", @"className": @"DrawRectDemoVC"},
    @{@"menuName": @"DrawRect示例2", @"className": @"DrawRectDemoaTwoVC"},
    @{@"menuName": @"DrawRect涂鸦", @"className": @"DrawRectScrawlVC"},
    @{@"menuName": @"DrawRect涂鸦2", @"className": @"DrawRectScrawlColorVC"},
    // 动画
    @{@"menuName": @"CABasicAnimation", @"className": @"CABasicAnimationVC"},
    @{@"menuName": @"CAKeyframeAnimation", @"className": @"CAKeyframeAnimationVC"},
    @{@"menuName": @"图层的隐式动画(CATransaction)", @"className": @"CATransitionVC"},
    @{@"menuName": @"CAAnimationGroup", @"className": @"CAAnimationGroupVC"},
    @{@"menuName": @"UIViewAnimation", @"className": @"UIViewAnimationVC"},
    @{@"menuName": @"AnimationDemo", @"className": @"AnimationDemoVC"},
    @{@"menuName": @"AnimationDemo2", @"className": @"AnimationDemoTwoVC"},
    @{@"menuName": @"AnimationDemo3", @"className": @"AnimationDemoThreeVC"},
    @{@"menuName": @"类似于探探翻页动画", @"className": @"AnimationDemoFourVC"},
    //
    @{@"menuName": @"仿真动画", @"className": @"UIDynamicController"},
    // 持久化存储
    @{@"menuName": @"Plist存储", @"className": @"PlistVC"},
    @{@"menuName": @"UserDefaults", @"className": @"UserDefaultsVC"},
    @{@"menuName": @"NSCoding(NSKeyedArchiver、NSKeyedUnarchiver)", @"className": @"NSCodingVC"},
    @{@"menuName": @"ArchiveDemo", @"className": @"ArchiveDemoVC"},
    @{@"menuName": @"NSCache", @"className": @"NSCacheVC"},
    @{@"menuName": @"FileManager", @"className": @"FileManagerVC"},
    @{@"menuName": @"FMDB（将任意对象存进数据库）", @"className": @"FMDBDemoVC"},
    // 响应链
    @{@"menuName": @"响应链", @"className": @"ResponderChainVC"},
    @{@"menuName": @"触摸事件的传递", @"className": @"TouchChainVC"},
    //
    @{@"menuName": @"Touch事件", @"className": @"TouchVC"},
    // 手势
    @{@"menuName": @"手势", @"className": @"GestureVC"},
    @{@"menuName": @"手势拼图demo", @"className": @"GesturePuzzleVC"},
    @{@"menuName": @"CAAnimationGroup", @"className": @"CAAnimationGroupVC"},
    @{@"menuName": @"CAAnimationGroup", @"className": @"CAAnimationGroupVC"},
    @{@"menuName": @"CAAnimationGroup", @"className": @"CAAnimationGroupVC"},
    @{@"menuName": @"CAAnimationGroup", @"className": @"CAAnimationGroupVC"},
    // 音频
    @{@"menuName": @"Audio-短音频播放", @"className": @"ShortAudioPlayVC"},
    @{@"menuName": @"Audio-MP3播放", @"className": @"AudioPlayVC"},
    @{@"menuName": @"Audio-录音", @"className": @"VoiceRecorderVC"},
    @{@"menuName": @"Audio-歌词同步", @"className": @"AudioLyricSyncVC"},
    // 新
    @{@"menuName": @"苹果内购", @"className": @"AppleStoreVC"},
    @{@"menuName": @"ARKit", @"className": @"ARSCNViewVC"},
    @{@"menuName": @"CoreMotion(陀螺仪、陀螺仪、加速剂)", @"className": @"CoreMotionVC"},
    @{@"menuName": @"距离传感器、摇一摇", @"className": @"ProximityMonitorVC"},
    @{@"menuName": @"加速计举例", @"className": @"CoreMotionExampleVC"},
    // 基础
    @{@"menuName": @"NSString、NSData、typedef、static", @"className": @"BasicTypeVC"},
    @{@"menuName": @"Exception", @"className": @"ExceptionVC"},
    @{@"menuName": @"NavigationOneVC", @"className": @"NavigationOneVC"},
    @{@"menuName": @"指针", @"className": @"PointerVC"},
    //
    @{@"menuName": @"应用间的跳转", @"className": @"JumpVC"},
    @{@"menuName": @"通讯录有UI", @"className": @"AddressBookUIVC"},
    @{@"menuName": @"通讯录无UI", @"className": @"AddressBookVC"},
    @{@"menuName": @"KeyboardToolbarTestVC", @"className": @"KeyboardToolbarTestVC"},
    @{@"menuName": @"发短信", @"className": @"SendMessageVC"},
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.meunArr[indexPath.row];
    if ([dict[@"className"] isEqualToString:@"LifeCycleOneVC"]) {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LifeCycle" bundle:nil];
        UIViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"LifeCycleOneVC"];
        [self.navigationController pushViewController:test2obj animated:YES];
    }else if ([dict[@"className"] isEqualToString:@"UIDynamicController"]) {
        UIDynamicController *vc = [[UIDynamicController alloc]initWithNibName:@"UIDynamicController" bundle:nil];
        vc.title = dict[@"menuName"];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        UIViewController *vc = [[NSClassFromString(dict[@"className"]) alloc]init];
        vc.title = dict[@"menuName"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end

