//
//  WJEmotionButton.m
//  我的微博
//
//  Created by wangjie on 15-4-11.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJEmotionButton.h"
#import "WJEmotion.h"

@implementation WJEmotionButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)setEmotion:(WJEmotion *)emotion
{
    _emotion = emotion;
    
    NSString *name = [NSString stringWithFormat:@"%@/%@", emotion.folder, emotion.png];
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

@end
