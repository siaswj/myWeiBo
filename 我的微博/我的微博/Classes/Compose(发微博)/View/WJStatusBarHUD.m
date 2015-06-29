//
//  WJStatusBarHUD.m
//  我的微博
//
//  Created by wangjie on 15-4-7.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJStatusBarHUD.h"

/****************** WJStatusBarHUDButton这个button（就是下面的_button） ***************/
// 自定义一个WJStatusBarHUDButton类
// 类的声明
@interface WJStatusBarHUDButton : UIButton
@property (nonatomic, weak) UIActivityIndicatorView *loadView;
@end
// 类的实现
@implementation WJStatusBarHUDButton
- (UIActivityIndicatorView *)loadView
{
    if (_loadView == nil) {
        UIActivityIndicatorView *loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadView.hidesWhenStopped = YES;
        [self addSubview:loadView];
        self.loadView = loadView;
    }
    return _loadView;
}

- (void)layoutSubviews
{
    // 先在WJStatusBarHUDButton的父类UIButton中算一下imageView、label的frame
    [super layoutSubviews];
    
    // 然后再在WJStatusBarHUDButton中算一下frame，覆盖UIButton中算出的结果
    self.titleLabel.frame = self.bounds;     // 这里：self == WJStatusBarHUDButton
    
    CGFloat titileW = [[self titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].width;
    CGFloat imgWH = 14;
    CGFloat imgY = 3;
    CGFloat imgX = (self.width - titileW) * 0.5 - imgWH - 10;
    self.imageView.frame = CGRectMake(imgX, imgY, imgWH, imgWH);
    
    self.loadView.center = self.imageView.center;
}
@end
/****************** WJStatusBarHUDButton这个button（就是下面的_button） ***************/



/****************************** WJStatusBarHUD的实现 *********************************/
@implementation WJStatusBarHUD

static UIWindow *_window;
static WJStatusBarHUDButton *_button;

/**
 *  这个类被第一次使用的时候调用
 */
+ (void)initialize
{
    // 创建窗口对象
    _window = [[UIWindow alloc] init];
    _window.backgroundColor = [UIColor blackColor];
    _window.width = [UIScreen mainScreen].bounds.size.width;
    _window.height = 20;
    _window.transform = CGAffineTransformMakeTranslation(0, -_window.height);
    _window.windowLevel = UIWindowLevelAlert;
    
    // 创建button对象
    _button = [[WJStatusBarHUDButton alloc] init];
    _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    _button.frame = _window.bounds;
    _button.titleLabel.font = [UIFont systemFontOfSize:13];
    [_window addSubview:_button];
}

/**
 *  展示普通的信息
 */
+ (void)showMessage:(NSString *)message image:(NSString *)image
{
    // 如果正在展示信息且没有转圈圈，就返回
    if (_window.hidden == NO && !_button.loadView.isAnimating) return;
    _window.hidden = NO;
    
    // 设置按钮上的文字
    [_button setTitle:message forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [_button.loadView stopAnimating];
    
    [UIView animateWithDuration:1.0 animations:^{
        _window.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _window.transform = CGAffineTransformMakeTranslation(0, -_window.height);
        } completion:^(BOOL finished) {
            _window.hidden = YES;
        }];
    }];
}

/** 展示成功的信息 */
+ (void)showSuccess:(NSString *)message
{
    
    [self showMessage:message image:@"WJStatusBarHUD.bundle/statusBarSuccess"];
}

/** 展示失败的信息 */
+ (void)showError:(NSString *)message
{
    [self showMessage:message image:@"WJStatusBarHUD.bundle/statusBarError"];
}

/** 展示正在加载的信息 */
+ (void)showLoading:(NSString *)message
{
    // 如果正在展示信息，就返回
    if (_window.hidden == NO) return;
    _window.hidden = NO;
    
    // 设置按钮上的文字
    [_button setTitle:message forState:UIControlStateNormal];
    [_button setImage:nil forState:UIControlStateNormal];
    [_button.loadView startAnimating];
    
    [UIView animateWithDuration:1.0 animations:^{
        _window.transform = CGAffineTransformIdentity;
    }];
}

// 我个人觉得这个方法好像没有多大用处，1加载，2要不加载成功要不加载失败，就可以了。。。。
/** 隐藏正在加载的信息 */
+ (void)hideLoading
{
    [_button.loadView stopAnimating];
    
    [UIView animateWithDuration:1.0 animations:^{
        _window.transform = CGAffineTransformMakeTranslation(0, -_window.height);
    } completion:^(BOOL finished) {
        _window.hidden = YES;
    }];
}

#warning BUG！如果创建这个窗口后，并且让它一直在状态栏上面待命(不销毁它)，那么先发条微博，再试着连续点击首页的标题按钮试试，下拉菜单不会添加到原来的键盘窗口上，因为这个窗口在最上面。（当然这个问题不算是这个框架的问题，因为这只是涉及到窗口的层级问题）

@end

/****************************** WJStatusBarHUD的实现 *********************************/


