//
//  WJAccountTool.h
//  我的微博
//
//  Created by wangjie on 15-4-2.
//  Copyright (c) 2015年 sias. All rights reserved.

/**
 *  这个工具类用来负责“账号“模型类的业务，比如：
 *  1.账号的读取和存储
 *  2.这个账号的授权是否已过期
 */

#import <Foundation/Foundation.h>
#import "WJAccount.h"

@interface WJAccountTool : NSObject

/**
 *  保存账号
 */
+ (void)save:(WJAccount *)account;

/**
 *  读取账号
 */
+ (WJAccount *)read;

@end
