//
//  WJEmotionTextView.h
//  我的微博
//
//  Created by wangjie on 15-4-12.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJTextView.h"

@class WJEmotion;

@interface WJEmotionTextView : WJTextView

/** 将表情插入到当前光标的位置 */
- (void)insertEmotion:(WJEmotion *)emotion;

/** 返回带有表情描述的字符串，比如：[发红包]7878[马到成功] */
- (NSString *)emotionText;

@end
