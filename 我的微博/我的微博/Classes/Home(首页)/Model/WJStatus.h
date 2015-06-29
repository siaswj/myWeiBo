//
//  WJStatus.h
//  我的微博
//
//  Created by wangjie on 15-4-4.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJUser.h"

@interface WJStatus : NSObject

/** 字符串型的微博ID */
@property (nonatomic, copy) NSString *idstr;

/** 微博内容 */
@property (nonatomic, copy) NSString *text;
/** 带有属性文字的-原创微博内容 */
@property (nonatomic, copy) NSMutableAttributedString *attributedText;

/** 微博用户 */
@property (nonatomic, strong) WJUser *user;

/** 微博来源 */
@property (nonatomic, copy) NSString *source;

/** 微博的创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** 缩略图数组，存放的都是WJPicUrl模型对象, 用户所发微博的图片 */
@property (nonatomic, strong) NSArray *pic_urls;

/** 转发微博 */
@property (nonatomic, strong) WJStatus *retweeted_status;
/** 带有属性文字的-转发微博的内容 */
@property (nonatomic, copy) NSMutableAttributedString *reStatusAttributedText;

/**
 *  赞数
 */
@property (nonatomic, strong) NSNumber *attitudes_count;
/**
 *  评论数
 */
@property (nonatomic, strong) NSNumber *comments_count;
/**
 *  转发数
 */
@property (nonatomic, strong) NSNumber *reposts_count;

@end
