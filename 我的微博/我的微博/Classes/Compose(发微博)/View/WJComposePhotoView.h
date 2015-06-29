//
//  WJComposePhotoView.h
//  我的微博
//
//  Created by wangjie on 15-4-13.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJComposePhotoView : UIView

/**
 *  外界给我传一张图片，我把它添加到photoView上（也就是自己上）
 */
- (void)addImage:(UIImage *)image;

/**
 *  返回给外界一个图片数组
 */
- (NSArray *)images;

@end
