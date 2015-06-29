//
//  WJPicUrl.m
//  我的微博
//
//  Created by wangjie on 15-4-5.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJPicUrl.h"

@implementation WJPicUrl

/**
 *  在这个方法中，利用self.thumbnail_pic属性的字符串值，获得self.bmiddle_pic属性的值
 */
- (void)setThumbnail_pic:(NSString *)thumbnail_pic
{
    _thumbnail_pic = [thumbnail_pic copy];
    
    // 用 bmiddle 替换 thumbnail_pic字符串中 的thumbnail
    self.bmiddle_pic = [thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
}

@end
