//
//  WJPhotosView.h
//  我的微博
//
//  Created by wangjie on 15-5-26.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJPhotosView : UIView
/** 里面都是图片数据 */
@property (nonatomic, strong) NSArray *pic_urls;

/** 根据图片的数量确定，photosView的size */
+ (CGSize)sizeWithPhotoCount:(NSInteger)photoCount;
@end
