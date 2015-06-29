//
//  WJTextPart.h
//  我的微博
//
//  Created by wangjie on 15-6-8.
//  Copyright (c) 2015年 sias. All rights reserved.
//

//  记录的是微博内容-属性文字的’碎片‘的特性

#import <Foundation/Foundation.h>

@interface WJTextPart : NSObject
/**
 *  用来存储属性文字的‘碎片’的字符串，包括 特殊的字符串 和 非特殊的字符串
 */
@property (nonatomic, copy) NSString *textPart;
/**
 *  碎片字符串的range
 */
@property (nonatomic, assign) NSRange textPartRange;
/**
 *  是不是动画表情字符串
 */
@property (nonatomic, assign) BOOL emotionString;
/**
 *  是不是特殊字符串
 */
@property (nonatomic, assign) BOOL specialString;
@end
