//
//  UIBarButtonItem+WJBarButtonItem.m
//  我的微博
//
//  Created by wangjie on 15-3-28.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "UIBarButtonItem+WJBarButtonItem.h"

@implementation UIBarButtonItem (WJBarButtonItem)
+ (instancetype)itemWithBg:(NSString *)bg highBg:(NSString *)highBg target:(id)target action:(SEL)action
{
    // 创建一个按钮
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:bg] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highBg] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 把这个按钮包装成一个UIBarButtonItem，并返回
    return [[self alloc] initWithCustomView:button];
}
@end
