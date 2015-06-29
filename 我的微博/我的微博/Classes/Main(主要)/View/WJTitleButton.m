//
//  WJTitleButton.m
//  我的微博
//
//  Created by wangjie on 15-3-28.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJTitleButton.h"

@implementation WJTitleButton

/**
 *  init内部会调用这个方法
 *  只有通过代码创建控件的时候，才会调用这个方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

/**
 *  通过xib/storyboard创建控件的时候，才会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

/**
 *  设置titleButton的属性
 */
- (void)setup
{
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

/***** 重写这两个set方法，只要按钮中的文字、图片size变了，按钮的size也跟着变 ****/
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];   // 设置按钮的size，为图片＋文字的size
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self sizeToFit];   // 设置按钮的size，为图片＋文字的size
}


/**
 *  在这里设置按钮内部titleLabel、imageView的位置
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // titleLabel的x == imageView的x
    self.titleLabel.x = self.imageView.x;
    
    // imageView的x == titleLabel的最大x
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
}

/**
 *  这两个方法也可以用来设置按钮内部titleLabel、imageView的frame
 */
//- (CGRect)titleRectForContentRect:(CGRect)contentRect;
//- (CGRect)imageRectForContentRect:(CGRect)contentRect;
@end
