//
//  AppDelegate.m
//  我的微博
//
//  Created by wangjie on 15-3-27.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "AppDelegate.h"
#import "WJTabBarController.h"
#import "WJOAuthViewController.h"
#import "WJAccountTool.h"
#import "SDWebImageManager.h"  // 管理图片缓存的
#import "UIWindow+Extension.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 2.设置窗口的根控制器
    if ([WJAccountTool read]) {
//        self.window.rootViewController = [[WJTabBarController alloc] init];
        [self.window chooseRootViewController];
    } else {
        self.window.rootViewController = [[WJOAuthViewController alloc] init];
    }
    
    // 3.让这个窗口成为主窗口并显示
    [self.window makeKeyAndVisible];
    
    // 申请应用图标上的提醒数字的权限
    UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [application registerUserNotificationSettings:settings];
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 取消图片下载
    [[SDWebImageManager sharedManager] cancelAll];
    
    // 清除图片缓存（内存中的图片缓存，不是磁盘上的）
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 开启后台任务，当应用进入后台后可以继续执行任务
    [application beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
