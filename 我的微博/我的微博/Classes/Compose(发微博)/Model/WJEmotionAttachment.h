//
//  WJEmotionAttachment.h
//  我的微博
//
//  Created by wangjie on 15-4-12.
//  Copyright (c) 2015年 sias. All rights reserved.

//  自定义一个Attachment，一个属性文字的附件对应的一个表情模型 ：一对一！！！

#import <Foundation/Foundation.h>

@class WJEmotion;

@interface WJEmotionAttachment : NSTextAttachment

/** 一个属性文字的附件对应的一个表情模型 */
@property (nonatomic, strong) WJEmotion *emotion;

@end
