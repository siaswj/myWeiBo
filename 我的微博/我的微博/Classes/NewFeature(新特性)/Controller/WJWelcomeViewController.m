//
//  WJWelcomeViewController.m
//  我的微博
//
//  Created by wangjie on 15-4-17.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJWelcomeViewController.h"
#import "WJTabBarController.h"
#import "UIImageView+WebCache.h"
#import "WJAccountTool.h"

@interface WJWelcomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstraint;
@end

@implementation WJWelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 在这个方法中获取用户头像
    NSString *iconUrlStr = [WJAccountTool read].profile_image_url;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
}

// 在这个方法中显示动画
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.iconImage.alpha = 1.0;
        self.imageConstraint.constant += 200;
        [self.iconImage layoutIfNeeded];   // 用layout做动画，一定要加上这句
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.welcomeLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[WJTabBarController alloc] init];
        }];
    }];
}

@end
