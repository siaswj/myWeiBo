//
//  WJEmotionTool.h
//  我的微博
//
//  Created by wangjie on 15-4-10.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WJEmotion;

@interface WJEmotionTool : NSObject

/**
 *  返回默认表情
 */
+ (NSArray *)defaultEmotion;

/**
 *  返回浪小花表情
 */
+ (NSArray *)lxhEmotion;


/**
 *  返回最近使用的表情
 */
+ (NSArray *)recentEmotion;

/**
 *  保存刚使用的表情对象
 */
+ (void)addRecentEmotion:(WJEmotion *)emotion;

/**
 *  根据 表情字符串-表情的文字描述 得到 对应的表情模型
 *  @param chs 表情字符串-表情的文字描述
 *  @return 对应的表情模型
 */
+ (WJEmotion *)emotionWithChs:(NSString *)chs;

@end
