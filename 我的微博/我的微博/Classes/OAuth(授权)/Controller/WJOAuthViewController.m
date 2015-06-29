//
//  WJOAuthViewController.m
//  我的微博
//
//  Created by wangjie on 15-4-1.
//  Copyright (c) 2015年 sias. All rights reserved.
//


/**
 *  主要内容：
 *  1.WJAccount模型类：字典转模型，存储账号模型
 *  2.WJAccountTool类：
     *  1>统一存储/读取账号
     *  2>记录/读取账号的时间
 */

#import "WJOAuthViewController.h"
#import "WJHTTPTool.h"
#import "WJTabBarController.h"
#import "WJAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "UIWindow+Extension.h"

@interface WJOAuthViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WJOAuthViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 先暂借3期微博的key用一下 ：4067793982,   key : ece7d82faaf0b8edcd9ba1f07564cb27
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=4067793982&redirect_uri=http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


#pragma UIWebViewDelegate方法
/**
 *  每当webview想要发送请求之前，都会调用这个方法，询问是否可以发送请求
 *  也就是说，能在这个方法中拦截所有webview发出的请求
 *  @param request  webview发出的请求
 *  @return YES ： 允许加载这个请求，NO ： 禁止加载这个请求
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 每次webview要发送的网络请求
    NSString *url = request.URL.absoluteString;
    
    NSRange rang = [url rangeOfString:@"code="];
    if (rang.length) {
        // 截取code
        NSString *code = [url substringFromIndex:rang.location + rang.length];
        
        // 用得到的code换取access_token
        [self accessTokenWithCode:code];
        return NO;   // 如果成功找到code，就没有必要再回到回调地址
    }

    return YES;
}

/**
 *  用得到的code换取access_token
 */
- (void)accessTokenWithCode:(NSString *)code
{
    // 1.拼接参数
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"client_id"] = WJAppKey;
    para[@"client_secret"] = WJAppSecret;
    para[@"redirect_uri"] = WJRedirectUri;
    para[@"code"] = code;
    para[@"grant_type"] = @"authorization_code";
    
    // 2.发送请求
    [WJHTTPTool post:@"https://api.weibo.com/oauth2/access_token" parameters:para success:^(id responseObject) {
        // 字典转模型
        WJAccount *account = [WJAccount accountWithDic:responseObject];
        // 将模型存储沙盒中(使用什么技术存储的，封装在WJAccountTool中，外界不需要关心)
        [WJAccountTool save:account];
        
//        // 切换到主控制器
//        [UIApplication sharedApplication].keyWindow.rootViewController = [[WJTabBarController alloc] init];
        // 选择控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window chooseRootViewController];
        
    } failure:^(NSError *error) {
        WJLog(@"发送失败－－－－");
    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载中，等我。。。"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

@end
