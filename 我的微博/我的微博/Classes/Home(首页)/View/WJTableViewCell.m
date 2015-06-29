//
//  WJTableViewCell.m
//  我的微博
//
//  Created by wangjie on 15-5-20.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJTableViewCell.h"
#import "WJStatusFrame.h"
#import "WJTopView.h"
#import "WJBottomView.h"

@interface WJTableViewCell ()
/** 顶部的view */
@property (nonatomic, weak) WJTopView *topView;
/** 底部的工具条 */
@property (nonatomic, weak) WJBottomView *bottomView;
@end


@implementation WJTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    WJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WJTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        
        // 创建cell的顶部视图
        WJTopView *topView = [[WJTopView alloc] init];
        [self.contentView addSubview:topView];
        self.topView = topView;
        
        // 创建cell的底部视图
        WJBottomView *bottomView = [[WJBottomView alloc] init];
        [self.contentView addSubview:bottomView];
        self.bottomView = bottomView;
    }
    return self;
}

- (void)setStatusFrame:(WJStatusFrame *)statusFrame
{
    self.topView.statusFrame = statusFrame;
    self.bottomView.statusFrame = statusFrame;
}

@end
