//
//  WJEmotion.h
//  我的微博
//
//  Created by wangjie on 15-4-10.
//  Copyright (c) 2015年 sias. All rights reserved.
//  一个表情 == 一个对象


#import <Foundation/Foundation.h>

@interface WJEmotion : NSObject <NSCoding>

/** 表情的文件名 */
@property (nonatomic, copy) NSString *png;

/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;

/** 表情所在的文件夹名 */
@property (nonatomic, copy) NSString *folder;

@end
