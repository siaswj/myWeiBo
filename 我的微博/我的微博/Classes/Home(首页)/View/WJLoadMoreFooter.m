//
//  WJLoadMoreFooter.m
//  我的微博
//
//  Created by wangjie on 15-4-6.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJLoadMoreFooter.h"

@implementation WJLoadMoreFooter

+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WJLoadMoreFooter" owner:nil options:nil] lastObject];
}

/**
 *  去除autoresizing，最好的方法还是用代码设置
 */
- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
