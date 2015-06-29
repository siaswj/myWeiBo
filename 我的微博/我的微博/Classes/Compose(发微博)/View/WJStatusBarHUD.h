//
//  WJStatusBarHUD.h
//  我的微博
//
//  Created by wangjie on 15-4-7.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJStatusBarHUD : NSObject

/** 展示普通的信息 */
+ (void)showMessage:(NSString *)message image:(NSString *)image;

/** 展示成功的信息 */
+ (void)showSuccess:(NSString *)message;

/** 展示失败的信息 */
+ (void)showError:(NSString *)message;

/** 展示正在加载的信息 */
+ (void)showLoading:(NSString *)message;

/** 隐藏正在加载的信息 */
+ (void)hideLoading;

@end
