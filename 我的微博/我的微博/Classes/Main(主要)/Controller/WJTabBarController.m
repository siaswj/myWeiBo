//
//  WJTabBarController.m
//  我的微博
//
//  Created by wangjie on 15-3-27.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJTabBarController.h"
#import "WJHomeViewController.h"
#import "WJDiscoverViewController.h"
#import "WJMessageCenterViewController.h"
#import "WJProfileViewController.h"
#import "WJNavigationController.h"
#import "WJTabBar.h"
#import "WJHTTPTool.h"
#import "WJAccountTool.h"

@interface WJTabBarController () <UITabBarControllerDelegate>
@property (nonatomic, strong) WJNavigationController *homeController;
@property (nonatomic, strong) WJNavigationController *messageController;
@property (nonatomic, strong) WJNavigationController *discoverController;
@property (nonatomic, strong) WJNavigationController *profileController;
@end


@implementation WJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加子控制器
    WJHomeViewController *home = [[WJHomeViewController alloc] init];
    self.homeController = [self addOneChildController:home image:@"tabbar_home" selectedImage:@"tabbar_home_selected" title:@"首页"];
    
    WJMessageCenterViewController *message = [[WJMessageCenterViewController alloc] init];
    self.messageController = [self addOneChildController:message image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected" title:@"消息"];
    
    WJDiscoverViewController *discover = [[WJDiscoverViewController alloc] init];
    self.discoverController = [self addOneChildController:discover image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected" title:@"发现"];
    
    WJProfileViewController *profile = [[WJProfileViewController alloc] init];
    self.profileController = [self addOneChildController:profile image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected" title:@"我"];
    
    
    // 2.添加自己的tabbar
    // 通过KVC修改tabbarController的tabbar，因为tabbarController的tabbar是readonly
    WJTabBar *tabbar = [[WJTabBar alloc] init];
    [self setValue:tabbar forKeyPath:@"tabBar"];

    // 3.创建一个定时器定时的获取最新的数据
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getNewUnread) userInfo:nil repeats:YES];
    
    // 遵守协议
    self.delegate = self;
}
- (void)getNewUnread
{
    // 发送网络请求获取未读微博数
    NSString *urlPath = @"https://rm.api.weibo.com/2/remind/unread_count.json";
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"access_token"] = [WJAccountTool read].access_token;
    para[@"uid"] = [WJAccountTool read].uid;
    
    [WJHTTPTool get:urlPath parameters:para success:^(id responseObject) {
        WJLog(@"%@", responseObject[@"status"]);
        NSNumber *Uncount = responseObject[@"status"];
        if (Uncount.intValue > 0) {
            self.homeController.tabBarItem.badgeValue = Uncount.stringValue;
            
            // iOS8之后，要想在应用的图标上显示提醒数字，必须申请权限,在didFinshlaunch方法中注册申请权限
            [UIApplication sharedApplication].applicationIconBadgeNumber = Uncount.intValue;
        }
    } failure:^(NSError *error) {
        WJLog(@"获取网络数据失败了");
    }];
    self.homeController.tabBarItem.badgeValue = nil;
}


/**
 * 给 WJTabBarController 添加一个子控制器
 */
- (WJNavigationController *)addOneChildController:(UIViewController *)childVc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title;
{
    // tabbarItem的背景图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    UIImage *imageSelected = [UIImage imageNamed:selectedImage];
    childVc.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 标题
    NSDictionary *attr = @{
                           NSForegroundColorAttributeName : [UIColor orangeColor]
                           };
    [childVc.tabBarItem setTitleTextAttributes:attr forState:UIControlStateSelected];
//    childVc.tabBarItem.title = title;        // 子控制器的tabbarItem标题
//    childVc.navigationItem.title = title;    // 子控制器的导航栏标题
    childVc.title = title;                // 子控制器的标题，包括tabbarItem、导航栏

    // 子控制器view的随机色
//    childVc.view.backgroundColor = WJRandomColor;
    
    // 给子控制器包装一个导航控制器
    WJNavigationController *navigation = [[WJNavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:navigation];
    
//    设置tabBarItem上的数字, 通过每个子控制器来设置子控制器的tabbaritem的badgeValue
//    navigation.tabBarItem.badgeValue = @"10";
    return navigation;
}

#pragma mark - UITabBarControllerDelegate方法
// 只要点击了对应的tabbarItem就会调用这个方法
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    WJNavigationController *navC = (WJNavigationController *)viewController;
    WJHomeViewController *vc = (WJHomeViewController *)navC.topViewController;

    if ([vc isKindOfClass:[WJHomeViewController class]] && vc.tabBarItem.badgeValue.intValue>0 ) {                  // 刷新
        [vc refresh];
    } else if ([vc isKindOfClass:[WJHomeViewController class]]){               // 滚动到顶部
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [vc.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
@end
