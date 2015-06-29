//
//  WJPopMenu.h
//  我的微博
//
//  Created by wangjie on 15-3-30.
//  Copyright (c) 2015年 sias. All rights reserved.
//


/**
 *  在一个控制器和类之间调用方法： 可以使用block、代理、通知
 */


#import <Foundation/Foundation.h>

@interface WJPopMenu : NSObject

/**
 *  点击标题按钮后，弹出的菜单
 *
 *  @param theView 指向的view
 *  @param content 菜单里的内容
 */
+ (void)popMenuFromView:(UIView *)view content:(UIView *)content dismiss:(void (^)())dismiss;


/**
 *  点击标题按钮后，弹出的菜单
 *
 *  @param rect    指向的矩形框
 *  @param View    在那个view中，以那个view为坐标系
 *  @param content 内容
 *  @param dismiss 菜单消失时要做的事
 */
+ (void)popMenuFromRect:(CGRect)rect inView:(UIView *)view content:(UIView *)content dismiss:(void (^)())dismiss;


/**
 *  传进来的是一个控制器
 */
+ (void)popMenuFromView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(void (^)())dismiss;

+ (void)popMenuFromRect:(CGRect)rect inView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(void (^)())dismiss;

@end
