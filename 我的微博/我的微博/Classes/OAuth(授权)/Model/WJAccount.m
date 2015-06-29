//
//  WJAccount.m
//  我的微博
//
//  Created by wangjie on 15-4-2.
//  Copyright (c) 2015年 sias. All rights reserved.
//  存储“账号”

#import "WJAccount.h"

@implementation WJAccount

+ (instancetype)accountWithDic:(NSDictionary *)dic
{
    WJAccount *account = [[self alloc] init];
    account.access_token = dic[@"access_token"];
    account.expires_in = dic[@"expires_in"];
    account.uid = dic[@"uid"];
    account.profile_image_url = dic[@"profile_image_url"];
    
    // 保存授权时的时间,并且计算过期的时间
    NSDate *saveDate = [NSDate date];
    account.expires_time = [saveDate dateByAddingTimeInterval:[account.expires_in doubleValue]];
    
    return account;
}

/**
 *  从文件中解析对象的时候调用：说明对象的那些属性需要读取
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.expires_time = [decoder decodeObjectForKey:@"expires_time"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.profile_image_url = [decoder decodeObjectForKey:@"profile_image_url"];
    }
    
    return self;
}

/**
 *  把一个对象写入文件的时候调用：说明对象的那些属性需要被存储
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.expires_time forKey:@"expires_time"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.profile_image_url forKey:@"profile_image_url"];
}

@end
