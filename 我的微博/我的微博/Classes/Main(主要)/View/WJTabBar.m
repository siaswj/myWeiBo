//
//  WJTabBar.m
//  我的微博
//
//  Created by wangjie on 15-3-27.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJTabBar.h"
#import "WJComposeViewController.h"

@interface WJTabBar ()
/**
 *  加号按钮
 */
@property (nonatomic, weak) UIButton *plusButton;
@end


@implementation WJTabBar

/**
 *  init内部会调用这个方法
 *  只有通过代码创建控件的时候，才会调用这个方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

/**
 *  通过xib/storyboard创建控件的时候，才会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

/**
 *  初始化一个按钮:加号按钮
 */
- (void)setup
{
    UIButton *plusButton = [[UIButton alloc] init];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusButton];
    self.plusButton = plusButton;
}

/**
 *  点击了加号按钮
 */
- (void)plusButtonClick
{
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    WJComposeViewController *compose = [[WJComposeViewController alloc] init];
    [rootVc presentViewController:[[UINavigationController alloc] initWithRootViewController:compose] animated:YES completion:nil];
}


/**
 *  一个控件在确定自己的frame后，会在这个方法中计算它的子控件的frame
 */
- (void)layoutSubviews
{
    // 先让父类算一下！！
    [super layoutSubviews];
    
    CGFloat buttonW = self.width / 5;
    CGFloat buttonH = self.height;
    CGFloat buttonIndex = 0;
    
    // 自己再算一下，覆盖掉父类中一部分子控件的frame
    for (UIView *child in self.subviews) {
        
        // 过滤掉tabbar中的imageView,background..控件,进去这里的都是UITabBarButton
        // 判断条件还可以是：[child isKindOfClass:NSClassFromString(@"UITabBarButton")]
        if ([child isKindOfClass:[UIControl class]] && ![child isKindOfClass:[UIButton class]]) {
            
            /** 计算 TabBarButton 的frame */
            CGFloat buttonX = buttonW * buttonIndex;
            child.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
//            child.x = buttonX;
//            child.y = 0;
//            child.width = buttonW;
//            child.height = buttonH;
            buttonIndex++;
            if (buttonIndex == 2) buttonIndex++;
        }
        
        /** 计算 加号按钮 的frame */
        self.plusButton.size = self.plusButton.currentBackgroundImage.size;
        self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    }
    
}

@end
