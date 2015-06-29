//
//  WJEmotionButton.h
//  我的微博
//
//  Created by wangjie on 15-4-11.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJEmotion;

@interface WJEmotionButton : UIButton

/** 一个表情按钮对应一个表情模型对象 */
@property (nonatomic, strong) WJEmotion *emotion;

@end
