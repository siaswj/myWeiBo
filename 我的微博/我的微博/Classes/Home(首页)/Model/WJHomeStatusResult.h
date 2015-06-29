//
//  WJHomeStatusResult.h
//  我的微博
//
//  Created by wangjie on 15-4-5.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJHomeStatusResult : NSObject

/** 服务器返回的数据中的数组 */
@property (nonatomic, strong) NSArray *statuses;

/** 返回的微博总数 */
@property (nonatomic, assign) int total_number;

@end
