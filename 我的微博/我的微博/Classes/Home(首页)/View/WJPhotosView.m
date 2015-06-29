//
//  WJPhotosView.m
//  我的微博
//
//  Created by wangjie on 15-5-26.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJPhotosView.h"
#import "UIImageView+WebCache.h"
#import "WJPicUrl.h"
#import "WJPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define photoMargin 10     // 图片之间的间隙
#define photoWidth 70     // 图片的宽高
#define photoHeight 70    // 图片的宽高

@implementation WJPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        for (int i=0; i<9; i++) {
            WJPhotoView *imageView = [[WJPhotoView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            [self addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [imageView addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)imageTap:(UITapGestureRecognizer *)tapGesture
{
    // 创建浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 设置浏览器的数据
    NSMutableArray *photos = [NSMutableArray array];
    for (int i=0; i<_pic_urls.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[_pic_urls[i] bmiddle_pic]];
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    browser.photos = photos;
    
    // 告诉浏览器当前对应的原始图片
    browser.currentPhotoIndex = tapGesture.view.tag;
    
    // 显示浏览器
    [browser show];
}

// 设置图片数据
- (void)setPic_urls:(NSArray *)pic_urls
{
    _pic_urls = pic_urls;
    
    /*  这样写，重复的创建和移除存在着性能上的问题！！！
    // 每个cell进入屏幕显示的时候，都要调用这个方法一次设置数据，所以需要清除原来的cell中的图片（因为cell是重用的）
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 下载数组中pic_url对应的照片
    for (int i=0; i<pic_urls.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        
        NSString *picURL = [pic_urls[i] thumbnail_pic];
        [imageView sd_setImageWithURL:[NSURL URLWithString:picURL] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    }
     */
    
    for (int i=0; i<9; i++) {    // 这里必须全部遍历9张图片，因为涉及到cell的重用！！要修改重用cell的图片的状态（每张）
        
        WJPhotoView *imageView = self.subviews[i];
        
        if (i < pic_urls.count) {    // 需要显示的几张图片
            imageView.hidden = NO;
            imageView.pic_url = _pic_urls[i];
        } else {
            imageView.hidden = YES;
        }
    }
}

// 设置每个图片的Frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i=0; i<self.subviews.count; i++) {
        
        WJPhotoView *imageView = self.subviews[i];
        
        int col = i % 3;   // 列号
        int row = i / 3;   // 行号
        CGFloat imageViewX = col * (photoWidth + photoMargin);
        CGFloat imageViewY = row * (photoHeight + photoMargin);
        
        imageView.frame = CGRectMake(imageViewX, imageViewY, photoWidth, photoHeight);
        
    }
}

// 根据图片的数量，计算配图容器的Frame, 也就是说photosView容器的size取决于图片的数量，没有图片photosView的size就为(0,0)
+ (CGSize)sizeWithPhotoCount:(NSInteger)photoCount
{
    NSInteger col = photoCount >= 3 ? 3 : photoCount;   // 列数
    NSInteger row = 0;                                  // 行数
    if (photoCount % 3 == 0) {
        row = photoCount / 3;
    } else {
        row = photoCount / 3 + 1;
    }
    
    CGFloat retweetPhotosViewW = photoWidth * col + (col - 1) * photoMargin;
    CGFloat retweetPhotosViewH = photoHeight * row + (row - 1) * photoMargin;
    
    return CGSizeMake(retweetPhotosViewW, retweetPhotosViewH);
}
@end
