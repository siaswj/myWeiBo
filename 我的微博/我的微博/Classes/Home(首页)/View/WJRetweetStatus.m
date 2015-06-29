//
//  WJRetweetStatus.m
//  我的微博
//
//  Created by wangjie on 15-5-20.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJRetweetStatus.h"
#import "WJStatusFrame.h"
#import "WJStatus.h"
#import "WJPhotosView.h"

@interface WJRetweetStatus ()
@property (nonatomic, weak) UILabel *retweetContentLabel;
@property (nonatomic, weak) WJPhotosView *retweetPhotosView;
@end

@implementation WJRetweetStatus


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        // 创建label
        UILabel *retweetContentLabel = [[UILabel alloc] init];
        retweetContentLabel.font = WJCellContentFont;
        retweetContentLabel.numberOfLines = 0;
        [self addSubview:retweetContentLabel];
        self.retweetContentLabel = retweetContentLabel;
        
        WJPhotosView *retweetPhotosView = [[WJPhotosView alloc] init];
        [self addSubview:retweetPhotosView];
        self.retweetPhotosView = retweetPhotosView;
        
    }
    return self;
}

- (void)setStatusFrame:(WJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    [self setupData];
    [self setupFrame];
}
- (void)setupData
{
    // 被转发的status模型数据
    WJStatus *reStatus = _statusFrame.status.retweeted_status;
    self.retweetPhotosView.pic_urls = reStatus.pic_urls;

#warning 如果直接设置带属性的字符串，将来显示出来的内容会有问题, 因为计算label的frame的时候, 是用text计算的, 但是显示的时候确实用attributedText显示的
    //self.retweetContentLabel.text = [NSString stringWithFormat:@"@%@: %@", reStatus.user.name, reStatus.text];
    // 原创微博的数据模型。因为原创微博数据中就自带有转发的微博数据，所以不能使用“转发微博的转发微博数据模型”来赋值，因为不存在这样的数据！
    WJStatus *status = _statusFrame.status;
    self.retweetContentLabel.attributedText = status.reStatusAttributedText;
}
- (void)setupFrame
{
    self.frame = _statusFrame.retweetViewF;
    self.retweetContentLabel.frame = _statusFrame.retweetContentLabelF;
    self.retweetPhotosView.frame = _statusFrame.retweetPhotosViewF;
}
@end
