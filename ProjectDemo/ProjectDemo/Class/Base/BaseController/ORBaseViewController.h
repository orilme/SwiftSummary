//
//  ORBaseViewController.h
//  ProjectDemo  基控制器
//
//  Created by orilme on 2017/4/5.
//  Copyright © 2017年 orilme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Color.h"
#import "Reachability.h"

@protocol  ORBaseViewControllerDataSource<NSObject>

@optional
-(NSMutableAttributedString*)setTitle;
-(UIButton*)set_leftButton;
-(UIButton*)set_rightButton;
-(UIColor*)set_colorBackground;
-(CGFloat)set_navigationHeight;
-(UIView*)set_bottomView;
-(UIImage*)navBackgroundImage;
-(BOOL)hideNavigationBottomLine;
-(UIImage*)set_leftBarButtonItemWithImage;
-(UIImage*)set_rightBarButtonItemWithImage;
@end


@protocol ORBaseViewControllerDelegate <NSObject>

@optional
-(void)left_button_event:(UIButton*)sender;
-(void)right_button_event:(UIButton*)sender;
-(void)title_click_event:(UIView*)sender;
@end

@interface ORBaseViewController : UIViewController<ORBaseViewControllerDataSource , ORBaseViewControllerDelegate>

-(void)changeNavigationBarTranslationY:(CGFloat)translationY;
-(void)set_Title:(NSMutableAttributedString *)title;

@end
