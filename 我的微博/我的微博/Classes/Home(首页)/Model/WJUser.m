//
//  WJUser.m
//  我的微博
//
//  Created by wangjie on 15-4-4.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJUser.h"

@implementation WJUser
- (BOOL)isVip
{
    return self.mbtype > 2;
}
@end
