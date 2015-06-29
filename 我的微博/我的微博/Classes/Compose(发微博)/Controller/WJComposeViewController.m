//
//  WJComposeViewController.m
//  我的微博
//
//  Created by wangjie on 15-4-6.
//  Copyright (c) 2015年 sias. All rights reserved.
//



// 发微博输入框方案的选择：
/**
 UITextField
 1.只能输入一行文字
 2.有placeholder属性,能显示占位文字
 
 UITextView
 1.没有placeholder属性, 默认不能显示占位文字
 2.能输入多行文字, 能够滚动查看文字
 
 理想的文本输入框 : UITextView
 1.能输入多行文字, 能够滚动查看文字
 2.有placeholder属性, 能显示占位文字
 */


#import "WJComposeViewController.h"
#import "WJAccountTool.h"
#import "WJHTTPTool.h"
#import "MBProgressHUD+MJ.h"
#import "WJEmotionKeyboard.h"
#import "WJEmotion.h"
#import "WJEmotionAttachment.h"
//#import "WJTextView.h"
#import "WJEmotionTextView.h"
#import "WJKeyboardToolBar.h"
#import "WJComposePhotoView.h"

@interface WJComposeViewController () <UITextViewDelegate, WJKeyboardToolBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/** 发布微博的输入框 */
@property (nonatomic, weak) WJEmotionTextView *textView;
/** 自定义的表情键盘 */
@property (nonatomic, strong) WJEmotionKeyboard *emotionKeyboard;
/** 盛放照片的view */
@property (nonatomic, strong) WJComposePhotoView *photoView;
@property (nonatomic, strong) WJKeyboardToolBar *toolbar;
@property (nonatomic, strong) WJKeyboardToolBar *tempToolbar;
@end



@implementation WJComposeViewController

- (WJComposePhotoView *)photoView
{
    if (_photoView == nil) {
        _photoView = [[WJComposePhotoView alloc] init];
        _photoView.height = self.view.height;
        _photoView.width = self.view.width;
        _photoView.y = 100;
//        [self.textView addSubview:self.photoView];  // 添加到textView上
        [self.textView addSubview:_photoView];
    }
    return _photoView;
}

- (WJEmotionKeyboard *)emotionKeyboard
{
    if (_emotionKeyboard == nil) {
        _emotionKeyboard = [[WJEmotionKeyboard alloc] init];
        _emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航栏
    [self setupNavigation];
    
    // 设置发微博输入框
    [self setupComposeStatus];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
    [self.textView becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

/**
 *  设置发微博输入框
 */
- (void)setupComposeStatus
{
    // 使用这种view，即有WJTextView的占位文字功能，也有WJEmotionTextView的特有功能
    WJEmotionTextView *compose = [[WJEmotionTextView alloc] init];
    compose.placeholder = @"分享新鲜事...分享新鲜事...分享新鲜事...分享新鲜事...分享新鲜事...";
    compose.frame = self.view.bounds;
    compose.alwaysBounceVertical = YES;    // 垂直方向上总有拉伸效果
    compose.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:compose];
    self.textView = compose;
    
    // 设置输入框的代理
    self.textView.delegate = self;
    
//     // 设置自定义的表情键盘
//    WJEmotionKeyboard *keyboard = [[WJEmotionKeyboard alloc] init];
//    keyboard.height = 216;
//    compose.inputView = keyboard;
    
    // 设置键盘上面的辅助工具条(当键盘显示的时候用的toolbar)
    WJKeyboardToolBar *toolBar = [[WJKeyboardToolBar alloc] init];
    toolBar.delegate = self;
    compose.inputAccessoryView = toolBar;
    self.toolbar = toolBar;
    
    // 当键盘不显示的时候用的toolbar
    // 还有一种方法是不借用temptoolbar，而是监听键盘的弹出和隐藏，改变toolbar的frame来控制，但是那样toolbar就不能作为textView的inputAccessoryView了
    WJKeyboardToolBar *tempToolbar = [[WJKeyboardToolBar alloc] init];
    tempToolbar.delegate = self;
    tempToolbar.height = toolBar.height;
    tempToolbar.width = self.view.width;
    tempToolbar.y = self.view.height - tempToolbar.height;
    [self.view addSubview:tempToolbar];
    self.tempToolbar = tempToolbar;
    
    
    // 尽量不要使用带block的通知(因为无法移除block，可能会导致内存泄漏)
    [[NSNotificationCenter defaultCenter] addObserver:self.textView selector:@selector(deleteBackward) name:WJDeleteButtonDidClickNotification object:nil];
    // 监听键盘表情按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionButtonClick:) name:WJEmotionButtonDidClickNotification object:nil];
}
/**
 *  当这个对象死掉后，移除监听
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.textView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  每点击一个表情按钮和删除按钮，就会发出一个通知；监听者接收到通知，就会调用相应的方法
 *  这个方法：设置属性文字，实现图文混排
 */
- (void)emotionButtonClick:(NSNotification *)note
{
    // 通过这种传递获取传过来的模型对象（通知里面有字典userInfo，保存着通知的信息）
    WJEmotion *emotion = note.userInfo[WJEmotionButtonKey];
    
    // 把这个模型对象传到WJEmotionTextView上显示,将表情插入到当前光标的位置
    [self.textView insertEmotion:emotion];
    
    // 输入表情时，改变发送按钮的状态
    [self textViewDidChange:self.textView];
}

/**
 *  设置导航栏
 */
- (void)setupNavigation
{
    // 控制器view的颜色默认是clearColor
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 统一设置UIBarButtonItem的外观
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor orangeColor]
                                   } forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor lightGrayColor]
                                   } forState:UIControlStateDisabled];
    // 设置导航栏的左右item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancle)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;  // 这句在这里设置不好使（iOS8改了）
    
    // 设置导航栏的标题
    NSString *name = [WJAccountTool read].name;
    if (name) {
        // 设置“发微博”的标题名字
        UILabel *label = [[UILabel alloc] init];
        self.navigationItem.titleView = label;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.height = 44;
        
        // 创建可变的属性文字
        // 哪些文字是可变的属性文字
        NSString *text = [NSString stringWithFormat:@"%@\n%@", @"发微博", name];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
        // 设置文字的属性
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, @"发微博".length)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[text rangeOfString:name]];
        label.attributedText = string;   // label对象有一个这样的属性。。。
        
    } else {
        self.title = @"发微博";
    }
}

- (void)cancle
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 提醒用户正在发布微博
    [WJStatusBarHUD showLoading:@"正在发布微博..."];
    
    // 拿到textView的text发送微博
    // 拼接参数
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"access_token"] = [WJAccountTool read].access_token;
    para[@"status"] = [self.textView emotionText];
    
    NSUInteger count = self.photoView.images.count;
    if (count) {    // 有图片的微博
        [self statusWithImageParameter:para];
    } else {    // 没有图片的纯文字微博
        [self statusWithoutImageParameter:para];
    }
}
- (void)statusWithImageParameter:(NSMutableDictionary *)para
{
    // 发送图片是文件上传
    UIImage *image = [self.photoView.images firstObject];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // 封装成一个WJHTTPFile类型的对象
    WJHTTPFile *file = [WJHTTPFile fileWithData:data name:@"pic" filename:@"test.jpg" mimeType:@"image/jpeg"];
    
    [WJHTTPTool post:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:para files:@[file] success:^(id responseObject) {
        [WJStatusBarHUD showSuccess:@"发布成功"];
    } failure:^(NSError *error) {
        [WJStatusBarHUD showError:@"发布失败"];
    }];
}

- (void)statusWithoutImageParameter:(NSMutableDictionary *)para
{
    [WJHTTPTool post:@"https://api.weibo.com/2/statuses/update.json" parameters:para success:^(id responseObject) {
        // 使用自定义的指示器控件
        [WJStatusBarHUD showSuccess:@"发布成功"];
    } failure:^(NSError *error) {
        [WJStatusBarHUD showError:@"发布失败"];
    }];
}

//- (void)dealloc
//{
//    WJLog(@"控制器");
//}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView
{
    // 如果有文字，导航栏右边的item就可以被点击
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textView resignFirstResponder];
}


#pragma mark - <WJKeyboardToolBarDelegate>
- (void)keyboardToolBar:(WJKeyboardToolBar *)keyboardToolBar didClickButton:(WJKeyboardToolBarButtonType)buttonType
{
    switch (buttonType) {
        case WJKeyboardToolBarButtonTypeCamera:
            [self openCamera];
            break;
            
        case WJKeyboardToolBarButtonTypePicture:
            [self openPicture];
            break;
            
        case WJKeyboardToolBarButtonTypeMention:
            WJLog(@"@");
            break;
            
        case WJKeyboardToolBarButtonTypeTrend:
            WJLog(@"＃");
            break;
            
        case WJKeyboardToolBarButtonTypeEmotion:
            [self switchKeyboard];   // 切换键盘
            break;
    }
}

- (void)switchKeyboard
{
    [self.textView resignFirstResponder];  // 退下键盘
    
    // textView.inputView == nil 时代表是系统键盘
    if (self.textView.inputView) {   // 正在使用自定义的键盘，改为系统的键盘，显示文本图片
        self.textView.inputView = nil;
        [self.toolbar switchEmotionButtonImage:YES];
        [self.tempToolbar switchEmotionButtonImage:YES];
    } else {    // 正在使用系统的键盘，改为自定义的键盘，显示表情图片
        self.textView.inputView = self.emotionKeyboard; // 应该避免频繁创建，所以要留住它
        [self.toolbar switchEmotionButtonImage:NO];
        [self.tempToolbar switchEmotionButtonImage:NO];
    }
    
    // 切换键盘动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
- (void)openPicture
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}


#pragma mark - <UIImagePickerControllerDelegate>
/**
 *  选完照片后就会调用这个方法。但一次只能选一张图片，要想一次选择多张图片得自己自定义
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 关闭控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 选择的图片
    WJLog(@"%@", info);
    [self.photoView addImage:info[UIImagePickerControllerOriginalImage]];
    
}

@end
