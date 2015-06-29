//
//  WJStatusFrame.m
//  我的微博
//
//  Created by wangjie on 15-5-20.
//  Copyright (c) 2015年 sias. All rights reserved.
//

/**
 readOnly : 只生成get方法，没有生成set方法，但是依然可以通过 ”_属性名“ 来访问/修改其值
 */

#import "WJStatusFrame.h"
#import "WJStatus.h"
#import "WJUser.h"
#import "WJPhotosView.h"

#define WJScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation WJStatusFrame

- (void)setStatus:(WJStatus *)status
{
    // 保存数据
    _status = status;
    
    // 计算子控件的frame
    // 计算原创微博frame
    [self setupOriginalFrame];
    
    // 计算转发微博frame
    [self setupRetweetedFrame];
    
    // 顶部视图
    [self setupTopViewFrame];
    
    // 底部视图
    [self setupBottomViewFrame];
    
    // cell的高度
    _cellHeight = CGRectGetMaxY(_bottomViewF);
}
- (void)setupRetweetedFrame
{
    // 取出转发微博
    WJStatus *retweetedStatus = _status.retweeted_status;
    if (retweetedStatus != nil) {   // 有转发
        // 转发的正文
        CGFloat retweetContentX = WJCellMargin;
        CGFloat retweetContentY = WJCellMargin;
        CGSize retweetContentMaxSize = CGSizeMake(WJScreenWidth - WJCellMargin - WJCellMargin, CGFLOAT_MAX);
        //CGSize retweetContentSize = [retweetedStatus.text sizeWithFont:WJCellContentFont constrainedToSize:retweetContentMaxSize];
        CGSize retweetContentSize = [retweetedStatus.attributedText boundingRectWithSize:retweetContentMaxSize options:NSStringDrawingUsesLineFragmentOrigin context:NULL].size;
        _retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        
        CGFloat retweetH = 0.0;
        if (retweetedStatus.pic_urls.count > 0) {    // 微博中有图片数据
            
            NSInteger photoCount = retweetedStatus.pic_urls.count;
            CGFloat retweetPhotosViewX = retweetContentX;
            CGFloat retweetPhotosViewY = CGRectGetMaxY(_retweetContentLabelF) + WJCellMargin;
            // 封装思想，谁里面的东西谁就应该最清楚
            CGSize retweetPhotosViewSize = [WJPhotosView sizeWithPhotoCount:photoCount];
            
            _retweetPhotosViewF = CGRectMake(retweetPhotosViewX, retweetPhotosViewY, retweetPhotosViewSize.width, retweetPhotosViewSize.height);
            
            retweetH = CGRectGetMaxY(_retweetPhotosViewF) + WJCellMargin;
            
        } else {            // 没有图片数据
            retweetH = CGRectGetMaxY(_retweetContentLabelF) + WJCellMargin;
        }
        
        // 转发微博
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(_originalViewF) + WJCellMargin;
        CGFloat retweetW = WJScreenWidth;
        _retweetViewF = (CGRect){{retweetX, retweetY}, {retweetW, retweetH}};
        
    }
}
- (void)setupOriginalFrame
{
    /** 头像 */
    CGFloat iconX = WJCellMargin;
    CGFloat iconY = WJCellMargin;
    CGFloat iconWidth = 35;
    CGFloat iconHeight = 35;
    _iconViewF = (CGRect){{iconX, iconY}, {iconWidth, iconHeight}};
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(_iconViewF) + WJCellMargin;
    CGFloat nameY = iconY;
    CGSize nameSize = [_status.user.name sizeWithFont:WJCellNameFont];
    _nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 创建时间 */
    CGFloat timeX = _nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameLabelF) + WJCellMargin * 0.5;
    CGSize timeSize = [_status.created_at sizeWithFont:WJCellTimeFont];
    _timeLabelF = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(_timeLabelF) + WJCellMargin;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [_status.source sizeWithFont:WJCellSourceFont];
    _sourceLabelF = CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height);
    
    /** 会员图标 */
    CGFloat vipX = CGRectGetMaxX(_nameLabelF) + WJCellMargin;
    CGFloat vipY = iconY;
    CGFloat vipW = 14;
    CGFloat vipH = 14;
    _vipViewF = (CGRect){{vipX, vipY}, {vipW, vipH}};
    
    
    /** 正文\内容 */
    CGFloat contentX = iconX;
    CGFloat contentY = CGRectGetMaxY(_iconViewF) + WJCellMargin;
    CGSize contentMaxSize = CGSizeMake(WJScreenWidth - WJCellMargin - WJCellMargin, CGFLOAT_MAX);
    //CGSize contentSize = [_status.text sizeWithFont:WJCellContentFont constrainedToSize:contentMaxSize];
    CGSize contentSize = [_status.attributedText boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin context:NULL].size;
    _contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    
    CGFloat orginalH = 0.0;
    if (_status.pic_urls.count > 0) {    // 微博中有图片数据
        
        NSInteger photoCount = _status.pic_urls.count;
        CGFloat photosViewX = iconX;
        CGFloat photosViewY = CGRectGetMaxY(_contentLabelF) + WJCellMargin;
        CGSize photosViewSize = [WJPhotosView sizeWithPhotoCount:photoCount];
        
        _photosViewF = CGRectMake(photosViewX, photosViewY, photosViewSize.width, photosViewSize.height);
        
        orginalH = CGRectGetMaxY(_photosViewF);
        
    } else {                            // 微博中没有图片数据
        orginalH = CGRectGetMaxY(_contentLabelF);
    }
    
    /** 原创微博View */
    CGFloat orginalX = 0;
    CGFloat orginalY = 0;
    CGFloat orginalW = WJScreenWidth;
    _originalViewF = (CGRect){{orginalX, orginalY}, {orginalW, orginalH}};
    
}
- (void)setupTopViewFrame
{
    CGFloat topX = 0;
    CGFloat topY = 20;
    CGFloat topW = WJScreenWidth;
    // 取出转发微博
    WJStatus *retweetedStatus = _status.retweeted_status;
    CGFloat topH = 0.0;
    if (retweetedStatus != nil) {
        topH = CGRectGetMaxY(_retweetViewF);
    } else {    // 没有转发微博
        topH = CGRectGetMaxY(_originalViewF);   // 顶部视图高度 = 原创微博最大的Y + 间隙
    }
    _topViewF = (CGRect){{topX, topY}, {topW, topH}};
}
- (void)setupBottomViewFrame
{
    CGFloat bottomX = 0;
    CGFloat bottomY = CGRectGetMaxY(_topViewF);
    CGFloat bottomW = WJScreenWidth;
    CGFloat bottomH = 35;
    _bottomViewF = (CGRect){{bottomX, bottomY}, {bottomW, bottomH}};
}

@end
