//
//  WJStatusTextView.m
//  我的微博
//
//  Created by wangjie on 15-6-10.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJStatusTextView.h"
#import "WJTextPart.h"

@implementation WJStatusTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor greenColor];
        
        // 清空textView四周的内边距
        //self.contentInset = UIEdgeInsetsZero;    不是这个属性
        //self.textContainerInset = UIEdgeInsetsZero;     只设置为zero 不能清空左右两边的内边距
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        
        // 如果设置内容的内边距为负数, 会导致内容显示不出来, 解决该bug的办法是禁止TextView滚动
        self.scrollEnabled = NO;
        
        // 禁止用户输入
        self.editable = NO;
    }
    
    return self;
}

/**
 *  在这个方法中监听用户点击文字
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.获取手指的位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 取出随属性字符串传递过来的装有‘不是表情的特殊字符串’的数组, 里面存储的都是 不是表情的特殊字符串 的模型
    NSArray *speStrArray = [self.attributedText attribute:@"speStrArray" atIndex:0 effectiveRange:NULL];
    BOOL flag = NO;   // 解决特殊字符串换行问题
    for (int i = 0; i < speStrArray.count; i++) {
        WJTextPart *partString = speStrArray[i];
        
        // 2.判断手指的位置在不在特殊字符串的Frame中
        // 设置self.selectedRange，内部会影响self.selectedTextRange
        self.selectedRange = partString.textPartRange;
        // 根据一个selectedTextRange获得一个特殊字符串的Frame，这个方法返回的是一个数组
        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
        // 恢复self.selectedRange的值，可以解决系统默认框住某段文字
        self.selectedRange = NSMakeRange(0, 0);
        
        for (UITextSelectionRect *selectionRect in rects) {
            if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0) {
                continue;
            }
            if (CGRectContainsPoint(selectionRect.rect, point)) {
                flag = YES;
                break;
            }
        }
        if (flag) {
            for (UITextSelectionRect *selectionRect in rects) {
                if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0) {
                    continue;
                }
                // 3.创建一个View，设置View的Frame为上面的Frame
                UIView *cover = [[UIView alloc] init];
                cover.frame = selectionRect.rect;
                cover.backgroundColor = [UIColor blueColor];
                cover.alpha = 0.6;
                cover.tag = 100;
                [self addSubview:cover];
            }
            break;
        }
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *view in self.subviews) {
        if (view.tag == 100) {
            [view removeFromSuperview];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

@end
