//
//  RuntimeExploreVC.m
//  ORIOSSummary
//
//  Created by orilme on 2019/4/7.
//  Copyright © 2019年 orilme. All rights reserved.
//

#import "RuntimeExploreVC.h"
#import "RuntimeExploreInfo+RuntimeAddProperty.h"
#import <objc/message.h>

@interface RuntimeExploreVC ()

@end

@implementation RuntimeExploreVC

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(runtimeReplaceViewDidLoad);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        //judge the method named  swizzledMethod is already existed.
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        // if swizzledMethod is already existed.
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)runtimeReplaceViewDidLoad {
    NSLog(@"替换的方法");
    [self runtimeReplaceViewDidLoad];
}

- (void)viewDidLoad {
    NSLog(@"自带的方法");
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self runtimeAddProperty];
    [self runtimeGetPropertyList];
    [self runtimeGetIvarList];
}

// 给分类增加属性
- (void)runtimeAddProperty {
    RuntimeExploreInfo *test = [RuntimeExploreInfo new];
    test.phoneNum = @"12342424242";
    NSLog(@"RuntimeAddProperty---%@", test.phoneNum);
}

- (void)runtimeGetPropertyList {
    id RuntimeExploreInfo = objc_getClass("RuntimeExploreInfo");
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(RuntimeExploreInfo, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        fprintf(stdout, "runtimeGetPropertyList---%s %s\n", property_getName(property), property_getAttributes(property));
    }
}

- (void)runtimeGetIvarList {
    id RuntimeExploreInfo = objc_getClass("RuntimeExploreInfo");
    unsigned int numIvars = 0;
    Ivar *ivars = class_copyIvarList(RuntimeExploreInfo, &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        fprintf(stdout, "runtimeGetIvarList---%s\n", ivar_getName(thisIvar));
    }
}

@end
