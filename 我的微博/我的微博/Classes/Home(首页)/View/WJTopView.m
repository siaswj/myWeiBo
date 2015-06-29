//
//  WJTopView.m
//  我的微博
//
//  Created by wangjie on 15-5-20.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJTopView.h"
#import "WJOriginalStatus.h"
#import "WJRetweetStatus.h"
#import "WJStatusFrame.h"

@interface WJTopView ()
/** 自己发的微博的View */
@property (nonatomic, weak) WJOriginalStatus *originalView;
/** 转发别人的微博的View */
@property (nonatomic, weak) WJRetweetStatus *retweetView;
@end


@implementation WJTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 创建一个自己发的微博的View
        WJOriginalStatus *orginalView = [[WJOriginalStatus alloc] init];
        [self addSubview:orginalView];
        self.originalView = orginalView;
        
        // 转发别人的View的
        WJRetweetStatus *retweetView = [[WJRetweetStatus alloc] init];
        retweetView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:retweetView];
        self.retweetView = retweetView;
    }
    return self;
}

- (void)setStatusFrame:(WJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 设置自己本身的Frame
    self.frame = statusFrame.topViewF;
    
    self.originalView.statusFrame = statusFrame;
    self.retweetView.statusFrame = statusFrame;
}

@end
