//
//  WJEmotionKeyboard.m
//  我的微博
//
//  Created by wangjie on 15-4-9.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJEmotionKeyboard.h"
#import "WJEmotionContentView.h"
#import "WJEmotionTool.h"

// 定义一个WJEmotionKeyboardToolbarButton类
@interface WJEmotionKeyboardToolbarButton : UIButton
@end
@implementation WJEmotionKeyboardToolbarButton
- (void)setHighlighted:(BOOL)highlighted {};  // 不要按钮的高亮状态
@end

static NSString * const WJDefaultText = @"默认";
static NSString * const WJRecentText = @"最近";
static NSString * const WJLxhText = @"浪小花";

@interface WJEmotionKeyboard ()
/** 底部工具条 */
@property (nonatomic, weak) UIView *toolbar;
/** 被选中的按钮 */
@property (nonatomic, weak) WJEmotionKeyboardToolbarButton *selectedButton;

/** 最近使用表情的view */
@property (nonatomic, strong) WJEmotionContentView *recentContentView;
/** 默认表情的view */
@property (nonatomic, strong) WJEmotionContentView *defaultContentView;
/** 浪小花表情的view */
@property (nonatomic, strong) WJEmotionContentView *lxhContentView;
/** 选中的contentView */
@property (nonatomic, weak) WJEmotionContentView *selectedContentView;
@end


@implementation WJEmotionKeyboard

- (WJEmotionContentView *)recentContentView
{
    if (_recentContentView == nil) {
        _recentContentView = [[WJEmotionContentView alloc] init];
        // 在这里把对应的表情数据赋给对应的contentView
        _recentContentView.emotions = [WJEmotionTool recentEmotion];
    }
    return _recentContentView;
}
- (WJEmotionContentView *)defaultContentView
{
    if (_defaultContentView == nil) {
        _defaultContentView = [[WJEmotionContentView alloc] init];
        _defaultContentView.emotions = [WJEmotionTool defaultEmotion];
    }
    return _defaultContentView;
}
- (WJEmotionContentView *)lxhContentView
{
    if (_lxhContentView == nil) {
        _lxhContentView = [[WJEmotionContentView alloc] init];
        _lxhContentView.emotions = [WJEmotionTool lxhEmotion];
    }
    return _lxhContentView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 创建底部工具条
        UIView *toolbar = [[UIView alloc] init];
        toolbar.backgroundColor = [UIColor blueColor];
        [self addSubview:toolbar];
        self.toolbar = toolbar;
        
        // 底部工具条上的按钮
        [self setupButton:WJRecentText];
        [self buttonClick:[self setupButton:WJDefaultText]];   // 刚创建键盘的时候默认点击了“默认”按钮
        [self setupButton:WJLxhText];
    }
    return self;
}

- (WJEmotionKeyboardToolbarButton *)setupButton:(NSString *)title
{
    WJEmotionKeyboardToolbarButton *button = [[WJEmotionKeyboardToolbarButton alloc] init];
    // 普通状态下的
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
    // 不可用状态下的
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_mid_selected"] forState:UIControlStateDisabled];
    // 监听按钮的点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self.toolbar addSubview:button];
    
    return button;
    
}

- (void)buttonClick:(WJEmotionKeyboardToolbarButton *)button
{
    // 切换按钮
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 切换按钮对应的表情contentView
    [self.selectedContentView removeFromSuperview];
    NSString *buttonTitle = button.currentTitle;
    
    if ([buttonTitle isEqualToString:WJDefaultText]) {
        [self addSubview:self.defaultContentView];
        self.selectedContentView = self.defaultContentView;
        
    } else if ([buttonTitle isEqualToString:WJRecentText]) {
        [self addSubview:self.recentContentView];
        self.selectedContentView = self.recentContentView;
        // 刷新最近的数据(注意：有可能出现加载两次的现象，懒加载recentContentView一次，这里一次)，所以在setEmotions:中要判断一下
        self.recentContentView.emotions = [WJEmotionTool recentEmotion];
        
    } else if ([buttonTitle isEqualToString:WJLxhText]) {
        [self addSubview:self.lxhContentView];
        self.selectedContentView = self.lxhContentView;
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 底部工具条的frame
    self.toolbar.height = 44;
    self.toolbar.width = self.width;
    self.toolbar.x = 0;
    self.toolbar.y = self.height - self.toolbar.height;
    
    // 底部工具条上按钮的frame
    for (int i = 0; i < 3; i++) {
        WJEmotionKeyboardToolbarButton *button = self.toolbar.subviews[i];
        button.width = self.toolbar.width / 3;
        button.height = self.toolbar.height;
        button.x = i * button.width;
        button.y = 0;
    }
    
    // 设置contentView的frame(x,y默认为0)
    self.selectedContentView.width = self.width;
    self.selectedContentView.height = self.toolbar.y;
}
@end
