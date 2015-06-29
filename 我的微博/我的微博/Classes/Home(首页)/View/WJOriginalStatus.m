//
//  WJOriginalStatus.m
//  我的微博
//
//  Created by wangjie on 15-5-20.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJOriginalStatus.h"
#import "WJStatusFrame.h"
#import "WJStatus.h"
#import "WJUser.h"
#import "UIImageView+WebCache.h"
#import "WJPhotosView.h"
#import "WJStatusTextView.h"

@interface WJOriginalStatus ()
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文\内容 */
//@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) WJStatusTextView *contentLabel;

/** 配图容器 */
@property (nonatomic, weak) WJPhotosView *photosView;
@end


@implementation WJOriginalStatus

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;

        UILabel *nameLabel = [[UILabel alloc] init];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        self.nameLabel.font = WJCellNameFont;

        UIImageView *vipView = [[UIImageView alloc] init];
        [self addSubview:vipView];
        self.vipView = vipView;

        UILabel *timeLabel = [[UILabel alloc] init];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        self.timeLabel.font = WJCellTimeFont;
        self.timeLabel.textColor = [UIColor orangeColor];

        UILabel *sourceLabel = [[UILabel alloc] init];
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        self.sourceLabel.font = WJCellSourceFont;
        
        WJStatusTextView *contentLabel = [[WJStatusTextView alloc] init];
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        //contentLabel.numberOfLines = 0;
        self.contentLabel.font = WJCellContentFont;
        
        WJPhotosView *photosView = [[WJPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
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
    WJStatus *status = self.statusFrame.status;
    WJUser *user = status.user;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.nameLabel.text = user.name;
    self.timeLabel.text = status.created_at;
    self.sourceLabel.text = status.source;
    //self.contentLabel.text = status.text;
    self.contentLabel.attributedText = status.attributedText;
    
    if (user.isVip) {
        // 根据会员等级获取对应的会员图片
        NSString *vipImageName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        // 设置会员图标
        self.vipView.image = [UIImage imageNamed:vipImageName];
        self.vipView.hidden = NO;
        // 设置昵称的颜色
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.vipView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    // 配图容器的数据(里面都是图片数据)
    self.photosView.pic_urls = status.pic_urls;
}
- (void)setupFrame
{
    WJStatusFrame *statusFrame = self.statusFrame;
    
    // 设置自己的Frame
    self.frame = _statusFrame.originalViewF;

    self.iconView.frame = statusFrame.iconViewF;
    self.nameLabel.frame = statusFrame.nameLabelF;
    self.vipView.frame = statusFrame.vipViewF;
    self.contentLabel.frame = statusFrame.contentLabelF;

#warning TOTHINK, 为什么time和source的Frame要在这里计算？？？但是我没有在这里算。。
    self.timeLabel.frame = statusFrame.timeLabelF;
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    
    // 配图容器的Frame
    self.photosView.frame = statusFrame.photosViewF;
}

@end
