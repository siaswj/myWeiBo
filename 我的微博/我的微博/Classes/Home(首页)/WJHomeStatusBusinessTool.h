//
//  WJHomeStatusBusinessTool.h
//  我的微博
//
//  Created by wangjie on 15-6-11.
//  Copyright (c) 2015年 sias. All rights reserved.

//  首页-微博业务类

#import <Foundation/Foundation.h>
#import "WJHomeStatusResult.h"
#import "WJStatusRequestParameter.h"

typedef void (^successBlock)(WJHomeStatusResult *successData);
typedef void (^failureBlock)(NSError *failure);

@interface WJHomeStatusBusinessTool : NSObject

/**
 *  获取微博数据
 *  @param parameter 请求参数
 *  @param success   成功的回调
 *  @param failure   失败的回调
 */
+ (void)statusWithRequestParameter:(WJStatusRequestParameter *)parameter sucess:(successBlock)success failure:(failureBlock)failure;

@end
