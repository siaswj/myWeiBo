//
//  WJHomeStatusResult.m
//  我的微博
//
//  Created by wangjie on 15-4-5.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJHomeStatusResult.h"
#import "MJExtension.h"
#import "WJStatus.h"

@implementation WJHomeStatusResult

/**
 *  这个方法的作用：statuses这个数组中放的是[WJStatus class]的类型的对象
 *  statuses这个key要和WJHomeStatusResult.h中的属性名一致。。
 */
- (NSDictionary *)objectClassInArray
{
    return @{ @"statuses" : [WJStatus class] };
}

@end
