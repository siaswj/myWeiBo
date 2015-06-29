//
//  WJEmotionPopView.m
//  我的微博
//
//  Created by wangjie on 15-4-12.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJEmotionPopView.h"
#import "WJEmotionButton.h"

@interface WJEmotionPopView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation WJEmotionPopView

+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WJEmotionPopView" owner:nil options:nil] lastObject];
}

- (void)popFromEmotionButton:(WJEmotionButton *)emotionButton
{
    self.iconView.image = emotionButton.currentImage;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    CGRect buttonFrame= [window convertRect:emotionButton.frame fromView:emotionButton.superview];
    self.centerX = CGRectGetMidX(buttonFrame);
    self.y = CGRectGetMidY(buttonFrame) - self.height;
    
}

@end
