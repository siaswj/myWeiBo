
//
//  WJEmotionAttachment.m
//  我的微博
//
//  Created by wangjie on 15-4-12.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJEmotionAttachment.h"
#import "WJEmotion.h"

@implementation WJEmotionAttachment

- (void)setEmotion:(WJEmotion *)emotion
{
    _emotion = emotion;
    
    // 表情图片的路径
    NSString *name = [NSString stringWithFormat:@"%@/%@", emotion.folder, emotion.png];
    self.image = [UIImage imageNamed:name];
    
}

@end
