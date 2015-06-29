//
//  WJPicUrl.h
//  我的微博
//
//  Created by wangjie on 15-4-5.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJPicUrl : NSObject

/** 缩略图图片地址 */
@property (nonatomic, copy) NSString *thumbnail_pic;

/** 中等尺寸的缩略图 */
@property (nonatomic, copy) NSString *bmiddle_pic;

@end
