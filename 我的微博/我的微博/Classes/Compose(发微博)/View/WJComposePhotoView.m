//
//  WJComposePhotoView.m
//  我的微博
//
//  Created by wangjie on 15-4-13.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJComposePhotoView.h"

@implementation WJComposePhotoView

/**
 *  添加一张图片到photoView上
 */
- (void)addImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [self addSubview:imageView];
}

/**
 *  当自己的frame确定后，再确定子控件的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int maxCols = 3;   // 每行最多3列
    CGFloat margin = 5;
    for (NSUInteger i = 0; i < self.subviews.count; i++) {
        UIImageView *imageView = self.subviews[i];
        imageView.height = 100;
        imageView.width = (self.width - margin * (maxCols+1)) / maxCols;
        imageView.x = margin + (i % maxCols) * (imageView.width + margin);
        imageView.y = (i / maxCols) * (imageView.height + margin);
    }
}

/**
 *  返回给外界一个图片数组
 */
- (NSArray *)images
{
//    NSMutableArray *images = [NSMutableArray array];
//    for (UIImageView *imageView in self.subviews) {
//        [images addObject:imageView.image];
//    }
//    return images;
    
    // 将self.subviews中的所有对象的image属性取出来，放到一个新的数组中，并返回。
    return [self.subviews valueForKeyPath:@"image"];
}

@end
