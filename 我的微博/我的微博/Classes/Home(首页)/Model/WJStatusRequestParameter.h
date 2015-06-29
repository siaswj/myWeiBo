//
//  WJStatusRequestParameter.h
//  我的微博
//
//  Created by wangjie on 15-6-11.
//  Copyright (c) 2015年 sias. All rights reserved.

//  请求微博数据的参数类

#import <Foundation/Foundation.h>

@interface WJStatusRequestParameter : NSObject
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, strong) NSNumber *since_id;
@property (nonatomic, strong) NSNumber *max_id;
// 需要获取多少条微博数据
@property (nonatomic, strong) NSNumber *count;
@end
