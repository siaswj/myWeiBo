//
//  WJPhotoView.m
//  我的微博
//
//  Created by wangjie on 15-5-27.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJPhotoView.h"
#import "UIImageView+WebCache.h"
#import "WJPicUrl.h"

@interface WJPhotoView ()
@property (nonatomic, weak) UIImageView *gifImageView;
@end

@implementation WJPhotoView

// 外界给我图片地址后，我自己根据这个地址去下载网络上的图片
- (void)setPic_url:(WJPicUrl *)pic_url
{
    _pic_url = pic_url;
    
    [self sd_setImageWithURL:[NSURL URLWithString:pic_url.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    // 判断该图片是不是gif图片（注意：gif、GIF）
    // 或者这样判断：[pic_url.thumbnail_pic.lowercaseString hasSuffix:@"gif"]   以gif结尾。下面那个是扩展名。
    if ([pic_url.thumbnail_pic.pathExtension.lowercaseString isEqualToString:@"gif"]) {
        self.gifImageView.hidden = NO;
    } else {
        self.gifImageView.hidden = YES;
    }
    
//    WJLog(@"%@", pic_url.thumbnail_pic);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        // 创建gif图片
        UIImageView *gifIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        [self addSubview:gifIv];
        self.gifImageView = gifIv;
        
        // 设置imageView的内容模式
        self.contentMode = UIViewContentModeScaleToFill;
        
        /* imageView的内容模式。有一张图详细的说明了这几种模式的区别，有大提琴的那张图片。
         
         默认的。系统按照imageView的宽高比拉伸图片，直到图片填充整个imageView
         UIViewContentModeScaleToFill,
         
         系统按照图片的宽高比拉伸图片，直到宽 或者 高达到imageView的宽高，然后居中显示
         UIViewContentModeScaleAspectFit,
         
         系统按照图片的宽高比拉伸图片，直到宽 和 高都达到imageView的宽高，然后居中显示
         UIViewContentModeScaleAspectFill,
         
         UIViewContentModeRedraw,
         UIViewContentModeCenter,
         UIViewContentModeTop,
         UIViewContentModeBottom,
         UIViewContentModeLeft,
         UIViewContentModeRight,
         UIViewContentModeTopLeft,
         UIViewContentModeTopRight,
         UIViewContentModeBottomLeft,
         UIViewContentModeBottomRight,
         */
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifImageView.x = self.width - self.gifImageView.width;
    self.gifImageView.y = self.height - self.gifImageView.height;
}

@end
