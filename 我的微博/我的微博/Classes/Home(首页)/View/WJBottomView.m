//
//  WJBottomView.m
//  我的微博
//
//  Created by wangjie on 15-5-20.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJBottomView.h"
#import "WJStatusFrame.h"
#import "UIImage+NJ.h"
#import "WJStatus.h"

@interface WJBottomView ()
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *dividers;

/** 赞 */
@property (nonatomic, weak) UIButton *attitudesButton;
/** 评论 */
@property (nonatomic, weak) UIButton *commentsButton;
/** 转发 */
@property (nonatomic, weak) UIButton *repostsButton;
@end

@implementation WJBottomView

- (NSArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}
- (NSArray *)dividers
{
    if (_dividers == nil) {
        _dividers = [[NSMutableArray alloc] init];
    }
    return _dividers;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 创建三个按钮
        self.repostsButton = [self addButtonWithImage:@"timeline_icon_retweet" title:@"转发"];
        self.commentsButton = [self addButtonWithImage:@"timeline_icon_comment" title:@"评论"];
        self.attitudesButton = [self addButtonWithImage:@"timeline_icon_unlike" title:@"赞"];
        
        // 创建两个分割线
        [self addDivider];
        [self addDivider];
    }
    return self;
}
- (void)addDivider
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
    [self addSubview:imageView];
    [self.dividers addObject:imageView];
    
}
- (UIButton *)addButtonWithImage:(NSString *)imageName title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.adjustsImageWhenHighlighted = NO;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [btn setBackgroundImage:[UIImage resizableImageWithName:@"common_card_bottom_background"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage resizableImageWithName:@"common_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:btn];
    [self.buttons addObject:btn];
    return btn;
}

// 自己的Frame确定后，就会调用这个方法确定它内部的子控件的Frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = self.width / self.buttons.count;
    CGFloat btnH = self.height;
    CGFloat btnY = 0;
    for (int i=0; i<self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        CGFloat btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    CGFloat diviW = 1;
    CGFloat diviH = self.height;
    CGFloat diviY = 0;
    for (int i=0; i<self.dividers.count; i++) {
        CGFloat diviX = (i+1) * btnW;
        UIImageView *imageView = self.dividers[i];
        imageView.frame = CGRectMake(diviX, diviY, diviW, diviH);
    }
}

- (void)setStatusFrame:(WJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    self.frame = statusFrame.bottomViewF;
    
    // 设置按钮上的数据
    WJStatus *status = statusFrame.status;
    [self setButton:self.attitudesButton originalTitle:@"赞" count:@(100000)];
    [self setButton:self.repostsButton originalTitle:@"转发" count:status.reposts_count];
    [self setButton:self.commentsButton originalTitle:@"评论" count:status.comments_count];
}
- (void)setButton:(UIButton *)button originalTitle:(NSString *)title count:(NSNumber *)count
{
    if (count.intValue > 0) {
        [button setTitle:count.stringValue forState:UIControlStateNormal];
    } else {
        [button setTitle:title forState:UIControlStateNormal];
    }
}

@end
