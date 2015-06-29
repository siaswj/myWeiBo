//
//  WJStatusFrame.h
//  我的微博
//
//  Created by wangjie on 15-5-20.
//  Copyright (c) 2015年 sias. All rights reserved.
//

// 间隙
#define WJCellMargin 10
#define WJCellNameFont [UIFont systemFontOfSize:16]
#define WJCellTimeFont  [UIFont systemFontOfSize:13]
#define WJCellSourceFont    WJCellTimeFont
#define WJCellContentFont   [UIFont systemFontOfSize:16]

#import <Foundation/Foundation.h>

@class WJStatus;

@interface WJStatusFrame : NSObject

/****************** 微博的模型数据 *******************/
@property (nonatomic, strong) WJStatus *status;


/****************  顶部视图的Frame *****************/
/** 顶部视图 */
@property (nonatomic, assign, readonly) CGRect topViewF;

/** 自己发的微博的view */
@property (nonatomic, assign, readonly) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/** 会员图标 */
@property (nonatomic, assign, readonly) CGRect vipViewF;
/** 时间 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign, readonly) CGRect sourceLabelF;
/** 正文\内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;
/** 配图容器 */
@property (nonatomic, assign, readonly) CGRect photosViewF;

/** 转发的微博的View */
@property (nonatomic, assign, readonly) CGRect retweetViewF;
/** 转发的微博的正文 */
@property (nonatomic, assign, readonly) CGRect retweetContentLabelF;
/** 配图容器 */
@property (nonatomic, assign, readonly) CGRect retweetPhotosViewF;


/****************  底部视图的Frame *****************/
/** 底部的工具条 */
@property (nonatomic, assign, readonly) CGRect bottomViewF;


/**************** cell的高度 *****************/
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
