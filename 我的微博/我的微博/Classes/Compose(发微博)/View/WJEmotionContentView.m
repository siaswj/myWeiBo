//
//  WJEmotionContentView.m
//  我的微博
//
//  Created by wangjie on 15-4-9.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJEmotionContentView.h"
#import "WJEmotion.h"
#import "WJEmotionButton.h"
#import "WJEmotionPopView.h"
#import "WJEmotionTool.h"

@interface WJEmotionContentView () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *divider;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) WJEmotionPopView *popView;
@end


@implementation WJEmotionContentView

- (WJEmotionPopView *)popView
{
    if (_popView == nil) {
        _popView = [WJEmotionPopView popView];
    }
    return _popView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加contentView中的子控件
        // 1.添加一个scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        // 2.pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];     // _pageImage是UIPageControl的私有属性，通过KVC修改
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];    // _currentPageImage是UIPageControl的私有属性
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        // 3.分割线
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = [UIColor grayColor];
        divider.alpha = 0.5;
        [self addSubview:divider];
        self.divider = divider;
        
        // 给contentView添加一个手势识别器
        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:longRecognizer];
    }
    return self;
}

/**
 *  长按触发的事件
 */
- (void)drag:(UILongPressGestureRecognizer *)recognizer
{
    // 手指所在view的位置
    CGPoint location = [recognizer locationInView:recognizer.view];
    // 手指所在的表情按钮
    WJEmotionButton *emotionBtn = [self emotionButtonForLocation:location];
    
//    switch (recognizer.state) {
//        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled: {
//            [self.popView removeFromSuperview];
//            if (emotionBtn == nil) return;
//            [self postNoteEmotionButtonClick:emotionBtn];
//            break;
//        }
//            
//        default: {
//            if (emotionBtn == nil) return;
//            [self.popView popFromEmotionButton:emotionBtn];
//            break;
//        }
//    }
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        [self.popView removeFromSuperview];
        if (emotionBtn == nil) return;
        [self postNoteEmotionButtonClick:emotionBtn];
    } else {
        if (emotionBtn == nil) return;
        [self.popView popFromEmotionButton:emotionBtn];
    }
}

/**
 *  返回location位置对应的表情
 */
- (WJEmotionButton *)emotionButtonForLocation:(CGPoint)location
{
    for (WJEmotionButton *emotionButton in self.scrollView.subviews) {
        if (![emotionButton isKindOfClass:[WJEmotionButton class]]) continue;
        
        CGRect frame = emotionButton.frame;
        // 让按钮的x值减去一定个数的屏幕宽度
        frame.origin.x -= self.pageControl.currentPage * self.width;

        if (CGRectContainsPoint(frame, location)) {
            return emotionButton;
        }
    }
    return nil;
}

/**
 *  重写setEmotion方法来添加表情（按钮）
 */
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 移除一次scrollView中的所有子控件(防止最近表情的contentView.emotions加载两次)
    for (UIView *child in self.scrollView.subviews) {
        [child removeFromSuperview];
    }
    
    // 添加表情到scrollView上
    NSUInteger count = emotions.count;
    for (NSUInteger i = 0; i < count; i++) {
        WJEmotion *emotion = emotions[i];
        
        WJEmotionButton *emotionButton = [[WJEmotionButton alloc] init];
        emotionButton.emotion = emotion;
        [emotionButton addTarget:self action:@selector(emotionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:emotionButton];
    }
    
    // 添加删除按钮(有多少页只需在这里算一次就可以在后面一直使用了)
    self.pageControl.numberOfPages = (count + 20 - 1) / 20;
    for (NSInteger i=0; i<self.pageControl.numberOfPages; i++) {
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:deleteButton];
    }
    
    WJLog(@"setEmotions-%zd---%zd---%zd", emotions.count, self.scrollView.subviews.count, self.pageControl.numberOfPages);
    
    // 重新布局子控件，他说这靠经验
    [self setNeedsLayout];
}

- (void)emotionButtonClick:(WJEmotionButton *)emotionButton
{
    // 发送一个通知
    [self postNoteEmotionButtonClick:emotionButton];
    
    // 2.点击表情按钮显示放大镜
    [self.popView popFromEmotionButton:emotionButton];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
}

/**
 *  发送一个通知－表情按钮被点击的通知
 */
- (void)postNoteEmotionButtonClick:(WJEmotionButton *)emotionButton
{
    // 0.保存刚使用的表情对象（数据来自WJEmotionTool工具类）
    [WJEmotionTool addRecentEmotion:emotionButton.emotion];
    
    // 1.把模型对象传出去
    NSDictionary *userIfon = @{WJEmotionButtonKey : emotionButton.emotion};
    [[NSNotificationCenter defaultCenter] postNotificationName:WJEmotionButtonDidClickNotification object:nil userInfo:userIfon];
}

/**
 *  删除按钮被点击
 *  为了保证封装性，不能使用代理，因为发微博控制器只知道WJEmotionKeyboard，而不知道它里面有什么内容
 */
- (void)deleteButtonClick
{
    // 发出一个WJDeleteButtonDidClick通知
    [[NSNotificationCenter defaultCenter] postNotificationName:WJDeleteButtonDidClickNotification object:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置contentView中子控件的frame
    // scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.pageControl.numberOfPages, 0);
    // pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 25;
    self.pageControl.y = self.height - self.pageControl.height;
    // divider
    self.divider.width = self.width;
    self.divider.height = 1;
    
    // 设置每个表情按钮的frame
    NSInteger totalRow = 7;    // 一共7列
    NSInteger totalCol = 3;    // 一共3行
    CGFloat leftMargin = 15;
    CGFloat topMargin = 20;
    CGFloat buttonW = (self.scrollView.width - 2 * leftMargin) / totalRow;
    CGFloat buttonH = (self.scrollView.height - topMargin) / totalCol;
    
    NSUInteger count = self.scrollView.subviews.count - self.pageControl.numberOfPages;
    for (NSUInteger i = 0; i < count; i++) {
        WJEmotionButton *emotionButton = self.scrollView.subviews[i];
        // 计算button的frame
        NSUInteger row = i % totalRow;   // 列号
        NSUInteger col = i / totalRow;   // 行号
        emotionButton.width = buttonW;
        emotionButton.height = buttonH;
        if (i >= 20) {
            emotionButton.x = [self.scrollView.subviews[i-20] x] + self.scrollView.width;
            emotionButton.y = [self.scrollView.subviews[i-20] y];
        } else {
            emotionButton.x = row * emotionButton.width + leftMargin;
            emotionButton.y = col * emotionButton.height + topMargin;
        }
    }
    
    // 设置删除按钮的frame(单独设置删除按钮)
    for (NSInteger i=count; i<self.scrollView.subviews.count; i++) {
        UIButton *deleteButton = self.scrollView.subviews[i];
        deleteButton.width = buttonW;
        deleteButton.height = buttonH;
        
        if (i == count) {
            deleteButton.x = self.scrollView.width - leftMargin - deleteButton.width;
        } else {
            UIButton *lasBtn = self.scrollView.subviews[i-1];
            deleteButton.x = lasBtn.x + self.scrollView.width;
        }
        deleteButton.y = self.scrollView.height - deleteButton.height;
    }
    
    WJLog(@"layoutSubviews-%zd---%zd---%zd", count, self.scrollView.subviews.count, self.pageControl.numberOfPages);

}


#pragma UIScrollViewDelegate的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}

@end
