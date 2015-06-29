//
//  UIBarButtonItem+WJBarButtonItem.h
//  我的微博
//
//  Created by wangjie on 15-3-28.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WJBarButtonItem)
/**
 *  创建一个UIBarButtonItem
 */
+ (instancetype)itemWithBg:(NSString *)bg highBg:(NSString *)highBg target:(id)target action:(SEL)action;
@end
