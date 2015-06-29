//
//  WJKeyboardToolBar.m
//  我的微博
//
//  Created by wangjie on 15-4-13.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJKeyboardToolBar.h"

@interface WJKeyboardToolBar ()
@property (nonatomic, weak) UIButton *btn;
@end

@implementation WJKeyboardToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.height = 44;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 设置工具条上的按钮
        [self setupButton:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" buttonType:WJKeyboardToolBarButtonTypeCamera];
        
        [self setupButton:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" buttonType:WJKeyboardToolBarButtonTypePicture];
        
        [self setupButton:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" buttonType:WJKeyboardToolBarButtonTypeMention];
        
        [self setupButton:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" buttonType:WJKeyboardToolBarButtonTypeTrend];
        
        self.btn = [self setupButton:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" buttonType:WJKeyboardToolBarButtonTypeEmotion];
    }
    return self;
}

- (void)switchEmotionButtonImage:(BOOL)isEmotionImage
{
    NSString *name = @"compose_keyboardbutton_background";
    NSString *highName = @"compose_keyboardbutton_background_highlighted";
    if (isEmotionImage) {
        name = @"compose_emoticonbutton_background";
        highName = @"compose_emoticonbutton_background_highlighted";
    }
    [self.btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:highName] forState:UIControlStateHighlighted];
    
}

/**
 *  这个方法相当于在initWithFrame:中执行
 */
- (UIButton *)setupButton:(NSString *)image highImage:(NSString *)highImage buttonType:(WJKeyboardToolBarButtonType)type
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(toolBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = type;
    [self addSubview:button];
    
    return button;
}

/**
 *  按钮被点击，控制器应该做一些事情，所以这是view跟controller的交互，而且这两者可以直接联系，所以用代理比较好，通知多用于不能直接联系的场景
 *  巧妙使用枚举，枚举的作用：可读性更强直观，便于程序员之间的交流
 */
- (void)toolBarButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(keyboardToolBar:didClickButton:)]) {
        [self.delegate keyboardToolBar:self didClickButton:(WJKeyboardToolBarButtonType)button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = self.subviews[i];
        button.height = self.height;
        button.width = self.width / 5;
        button.y = 0;
        button.x = i * button.width;
    }
}
@end
