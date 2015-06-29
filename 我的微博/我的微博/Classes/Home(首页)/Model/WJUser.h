//
//  WJUser.h
//  我的微博
//
//  Created by wangjie on 15-4-4.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJUser : NSObject
/** 用户昵称 */
@property (nonatomic, copy) NSString *name;
/** 用户头像 */
@property (nonatomic, copy) NSString *profile_image_url;
/** 用户的性别 */
@property (nonatomic, copy) NSString *gender;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;
/** 会员类型 */
@property (nonatomic, assign) int mbtype;
/** 是否是VIP */
@property (nonatomic, assign, getter=isVip) BOOL vip;
@end




/** 
 *  "MJExtension.h" 中还有一个方法比较重要且常用：
 *  - (NSDictionary *)replacedKeyFromPropertyName
 */