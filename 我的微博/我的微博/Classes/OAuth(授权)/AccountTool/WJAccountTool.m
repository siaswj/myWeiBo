//
//  WJAccountTool.m
//  我的微博
//
//  Created by wangjie on 15-4-2.
//  Copyright (c) 2015年 sias. All rights reserved.
//


/**
 *  这个工具类用来负责“账号“模型类的业务，比如：
 *  1.账号的读取和存储
 *  2.这个账号的授权是否已过期 (最准确的判断方式应该是获取网络时间来进行判断，不过在这里是通过本地判断的方式)
 */

#define WJAccountSavePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#import "WJAccountTool.h"

@implementation WJAccountTool

+ (void)save:(WJAccount *)account
{
    // 哦，原来用的是coding技术存储的
    [NSKeyedArchiver archiveRootObject:account toFile:WJAccountSavePath];
    
}

+ (WJAccount *)read
{
    
    // 读取账号的模型数据
    WJAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:WJAccountSavePath];
    
    // 判断时间是否过期 （本地判断）
    NSDate *readDate = [NSDate date];
    
    if ([readDate compare:account.expires_time] == NSOrderedAscending) {  // 没过期
        return account;
    }
    
    return nil;
}

// NSOrderedAscending,  升序
// NSOrderedSame,  相同
// NSOrderedDescending  降序

@end
