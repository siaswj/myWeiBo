//
//  UIWindow+Extension.m
//  我的微博
//
//  Created by wangjie on 15-4-17.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "WJNewFeatureViewController.h"
#import "WJWelcomeViewController.h"

@implementation UIWindow (Extension)
- (void)chooseRootViewController
{
    // 获取沙盒中的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  // 偏好设置
    NSString *sandBoxVersion = [defaults objectForKey:@"CFBundleShortVersionString"];
    
    // 获取当前软件的版本号
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    
    // 比较选择window的控制器
    if ([currentVersion compare:sandBoxVersion] == NSOrderedDescending) { //从左到右降序，新特性控制器
        self.rootViewController = [[WJNewFeatureViewController alloc] init];
        [defaults setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [defaults synchronize];  // 立即同步
    } else {  // 欢迎控制器
        self.rootViewController = [[WJWelcomeViewController alloc] init];
    }
}
@end
