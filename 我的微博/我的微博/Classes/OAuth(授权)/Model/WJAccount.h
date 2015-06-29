//
//  WJAccount.h
//  我的微博
//
//  Created by wangjie on 15-4-2.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJAccount : NSObject <NSCoding>

/**
 *  用于调用access_token，接口获取授权后的access token
 */
@property (nonatomic, copy) NSString *access_token;
/**
 *  access_token的生命周期，单位是秒数
 */
@property (nonatomic, copy) NSString *expires_in;
/**
 *  当前授权用户的UID
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  当前授权用户的昵称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  access_token的过期时间
 */
@property (nonatomic, strong) NSDate *expires_time;
/**
 *  用户的头像
 */
@property (nonatomic, copy) NSString *profile_image_url;

/**
 *  账号的字典转模型
 */
+ (instancetype)accountWithDic:(NSDictionary *)dic;

@end
