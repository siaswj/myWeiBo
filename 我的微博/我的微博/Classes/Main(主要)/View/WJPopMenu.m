//
//  WJPopMenu.m
//  我的微博
//
//  Created by wangjie on 15-3-30.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJPopMenu.h"

@interface WJPopMenu ()
///**
// *  屏幕上的遮盖
// */
//@property (nonatomic, weak) UIButton *cover;
///**
// *  下拉菜单的容器－图片
// */
//@property (nonatomic, weak) UIImageView *container;
@end



@implementation WJPopMenu

#warning 全局变量的作用范围－－－－－－－
static void (^_dismiss)();
static UIButton *_cover;
static UIImageView *_container;
static UIViewController *_contentVc;  // 保证传进来的控制器不会很快死掉，这样就可以调用它的数据源方法
// static修饰全局变量：表示这个全局变量只能在当前文件中被访问，如果不用static修饰，可能被别人在外面用extern引用这个变量，进而可能访问/修改该变量
// static修饰局部变量：并不会改变局部变量的作用域，但是可以让这个局部变量在内存中只创建一份，直到程序退出时才销毁。
// static修饰函数：？？？？？？？？？


+ (void)popMenuFromRect:(CGRect)rect inView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(void (^)())dismiss
{
    _contentVc = contentVc;
    [self popMenuFromRect:rect inView:view content:contentVc.view dismiss:dismiss];
}

+ (void)popMenuFromView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(void (^)())dismiss
{
    _contentVc = contentVc;
    [self popMenuFromView:view content:contentVc.view dismiss:dismiss];
}

/**
 *  点击标题按钮后，弹出的菜单
 *
 *  @param rect    指向的矩形框
 *  @param View    在那个view中，以那个view为坐标系
 *  @param content 内容
 *  @param dismiss 菜单消失时要做的事
 */
+ (void)popMenuFromRect:(CGRect)rect inView:(UIView *)view content:(UIView *)content dismiss:(void (^)())dismiss
{
#warning block的内存问题－－－－－－－－
    // block需要copy，才能抱住性命
    // block的copy的作用：把block从栈空间 移动到 堆空间中（把block从基本类型变成对象）
    _dismiss = [dismiss copy];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];  // 键盘所在的窗口
    
    // 屏幕上的遮盖,添加到窗口中
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    cover.frame = [UIScreen mainScreen].bounds;
    [window addSubview:cover];
    _cover = cover;
    
    // 弹出下拉菜单－容器－图片
    UIImageView *container = [[UIImageView alloc] init];
    container.userInteractionEnabled = YES;
    container.image = [UIImage imageNamed:@"popover_background"];
    [window addSubview:container];
    _container = container;
    
    // 把content添加到容器－图片中
    content.x = 10;
    content.y = 15;
    [container addSubview:content];
    
    // 容器的frame
    container.width = content.width + content.x * 2;
    container.height = content.height + content.y * 2;
    container.centerX = CGRectGetMidX(rect);
    container.y = CGRectGetMaxY(rect);
    
    // 转换坐标系
    container.center = [window convertPoint:container.center fromView:view];
//    container.center = [view convertPoint:container.center toView:window];
    

#warning BUG原因在这里，是窗口的问题，状态栏创建的窗口成为了最上面的窗口，所以下拉菜单不能正常显示出来了。。
    WJLog(@"appwin = %@", [[UIApplication sharedApplication].windows lastObject]);
    WJLog(@"win = %@", window);
// 可以把这三个window打印出来看前后是不是同一个对象_window/window/[[UIApplication sharedApplication].windows lastObject]
}

/**
 *  点击标题按钮后，弹出的菜单
 *
 *  @param view 指向的view
 *  @param content 菜单里的内容
 *  @param dismiss 菜单消失后，要做的事（传的是block，保存的是代码块）
 */
+ (void)popMenuFromView:(UIView *)view content:(UIView *)content dismiss:(void (^)())dismiss
{
    [self popMenuFromRect:view.bounds inView:view content:content dismiss:dismiss];
//    [self popMenuFromRect:view.frame inView:view.superview content:content dismiss:dismiss];
}

/**
 *  点击了遮盖
 */
+ (void)coverClick
{
    [_cover removeFromSuperview];
    _cover = nil;
    
    [_container removeFromSuperview];
    _container = nil;
    
    _contentVc = nil;
    
    // 执行dismiss－block里面的代码（控制箭头的方向）
    if (_dismiss) {
        _dismiss();   // 执行dismiss——block代码块
        _dismiss = nil;
    }
}

@end
