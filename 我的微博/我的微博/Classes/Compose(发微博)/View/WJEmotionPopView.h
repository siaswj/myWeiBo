//
//  WJEmotionPopView.h
//  我的微博
//
//  Created by wangjie on 15-4-12.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJEmotionButton;

@interface WJEmotionPopView : UIView
/**
 *  返回一个popView
 */
+ (instancetype)popView;

/**
 *  从这个表情按钮pop
 */
- (void)popFromEmotionButton:(WJEmotionButton *)emotionButton;
@end
