//
//  WJKeyboardToolBar.h
//  我的微博
//
//  Created by wangjie on 15-4-13.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WJKeyboardToolBarButtonTypeCamera, // 拍照按钮
    WJKeyboardToolBarButtonTypePicture, // 相册按钮
    WJKeyboardToolBarButtonTypeMention, // @按钮
    WJKeyboardToolBarButtonTypeTrend, // #按钮
    WJKeyboardToolBarButtonTypeEmotion // 表情按钮
} WJKeyboardToolBarButtonType;

@class WJKeyboardToolBar;

@protocol WJKeyboardToolBarDelegate <NSObject>
@optional
// 把按钮被点击的事件传出去,还要传出去被点击按钮的类型，让外界知道那个按钮被点击了
- (void)keyboardToolBar:(WJKeyboardToolBar *)keyboardToolBar didClickButton:(WJKeyboardToolBarButtonType)buttonType;
@end


@interface WJKeyboardToolBar : UIView
@property (nonatomic, weak) id<WJKeyboardToolBarDelegate> delegate;

- (void)switchEmotionButtonImage:(BOOL)isEmotionImage;
@end
