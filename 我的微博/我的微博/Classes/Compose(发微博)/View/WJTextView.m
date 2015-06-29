//
//  WJTextView.m
//  我的微博
//
//  Created by wangjie on 15-4-7.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJTextView.h"

@implementation WJTextView

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    // 通过通知机制来监听textView的文字的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:UITextViewTextDidChangeNotification object:self];
    
    // 测试-－－添加一个label到textView上，占位文字写到label上，这样占位文字就可以跟着上下滑动了
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self addSubview:addButton];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 重写这两个方法
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

/**
 *  让输入框的占位文字的font和文本文字的font，实时的保持一致
 *  一套好的自定义控件的要求
 */
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

/**
 *  实时修改占位文字的内容
 *  一套好的自定义控件的要求
 */
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}


/**
 *  在这个方法里，画出占位文字
 */
- (void)drawRect:(CGRect)rect
{
//    WJLog(@"%@" , self.placeholder);
    
    if (self.hasText) return;  // 这里的文本指的是用户输入的文本，不是占位字符
    
    // 设置要画的文字的属性
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor grayColor];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    if (self.font) {
        attr[NSFontAttributeName] = self.font;
    }
    
    // 设置要画文字的区域
    CGRect placeholderRact;
    CGFloat x = 5;
    CGFloat y = 7;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat h = rect.size.height;
    placeholderRact.origin = CGPointMake(x, y);
    placeholderRact.size = CGSizeMake(w, h);
    
    // 画文字
    [self.placeholder drawInRect:placeholderRact withAttributes:attr];
}

@end
