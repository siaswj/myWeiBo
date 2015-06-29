//
//  WJNewFeatureViewController.m
//  我的微博
//
//  Created by wangjie on 15-4-17.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJNewFeatureViewController.h"
#import "WJTabBarController.h"

@interface WJNewFeatureViewController ()
- (IBAction)enterWeibo:(UIButton *)sender;
@end

@implementation WJNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 *  进入微博
 */
- (IBAction)enterWeibo:(UIButton *)sender
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[WJTabBarController alloc] init];
}
@end
