//
//  WJHomeViewController.m
//  我的微博
//
//  Created by wangjie on 15-3-27.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJHomeViewController.h"
#import "WJPopMenu.h"
#import "WJMenuViewController.h"
#import "WJMenuTestController.h"
#import "WJHTTPTool.h"
#import "WJAccountTool.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "WJHomeStatusResult.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "WJStatus.h"
#import "WJStatusFrame.h"
#import "WJTableViewCell.h"
#import "WJHomeStatusBusinessTool.h"

@interface WJHomeViewController () <UITableViewDataSource, UITableViewDelegate>
/** 获取的微博数据 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end


@implementation WJHomeViewController

- (NSMutableArray *)statusFrames
{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 在控制器上添加一个tableview
    [self setupTableView];
    
    // 设置导航栏
    [self setupNavigationBar];
    
    // 下拉刷新更多微博数据
    [self downLoadMoreStatus];
    
    // 获取用户信息
    [self getUserInfo];
    
}

- (void)refresh
{
    [self.tableView headerBeginRefreshing];
}

/**
 *  在控制器上添加一个tableview
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.frame = self.view.bounds;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // cell之间没有分割线
    tableView.backgroundColor = [UIColor grayColor];    // tableView的颜色
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - 发送网络请求获取数据
/**
 *  获取用户信息,需要发送网络请求来获取----（其实用户信息也是需要缓存的。。。）
 */
- (void)getUserInfo
{
    // 拼接参数
    WJAccount *account = [WJAccountTool read];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"access_token"] = account.access_token;
    para[@"uid"] = account.uid;
    
    // 使用自己的网络请求工具(封装的AFN)发送请求
    [WJHTTPTool get:@"https://api.weibo.com/2/users/show.json" parameters:para success:^(id responseObject) {
        WJUser *user = [WJUser objectWithKeyValues:responseObject];
        // 设置首页标题的文字为用户昵称
        WJTitleButton *titleBtn = (WJTitleButton *)self.navigationItem.titleView;
        [titleBtn setTitle:user.name forState:UIControlStateNormal];
        // 存储用户最新的昵称
        if (account.name != user.name) {
            account.name = user.name;
            account.profile_image_url = user.profile_image_url;
            [WJAccountTool save:account];
        }
    } failure:^(NSError *error) {
        // 提示错误信息
        [MBProgressHUD showError:@"网络繁忙，稍后再试"];
    }];
}
/**
 *  刷新更多微博数据
 */
- (void)downLoadMoreStatus
{
    [self.tableView addHeaderWithTarget:self action:@selector(downLoadNewStatus)];
    [self.tableView addFooterWithTarget:self action:@selector(upLoadMoreStatus)];
    
    [self downLoadNewStatus];
}
/**
 *  下拉加载更多微博－refreshcontrol的状态改变，发送网络请求
 */
- (void)downLoadNewStatus
{
    // 清空提醒数字
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    /*
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"access_token"] = [WJAccountTool read].access_token;
    if (self.statusFrames.count) {
        para[@"since_id"] = [[self.statusFrames.firstObject status] idstr];
    }

     [WJHTTPTool get:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:para success:^(id responseObject) {
     
     // 把加载的最新数据转成模型
     WJHomeStatusResult *result = [WJHomeStatusResult objectWithKeyValues:responseObject];
     
     // status模型转换成statusFrame模型
     NSMutableArray *statusframes = (NSMutableArray *)[self statusFramesWithStatuses:result.statuses];
     
     // 把刷新到最新的微博数据 添加到 旧数据的最前面
     NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, statusframes.count)];
     [self.statusFrames insertObjects:statusframes atIndexes:indexSet];
     // 重新刷新界面
     [self.tableView reloadData];
     // 结束刷新
     [self.tableView headerEndRefreshing];
     // 提示用户有几条最新的微博
     [self tellUserHowManyNewStatuses:result.statuses.count];
     } failure:^(NSError *error) {
     
     // 提示错误信息
     [MBProgressHUD showError:@"网络繁忙，稍后再试"];
     // 结束刷新
     [self.tableView headerEndRefreshing];
     }];
     */
    
    WJStatusRequestParameter *reqPara = [[WJStatusRequestParameter alloc] init];
    reqPara.access_token = [WJAccountTool read].access_token;
    if (self.statusFrames.count) {
        reqPara.since_id = @([[[self.statusFrames.firstObject status] idstr] longLongValue]);
    }
    
    [WJHomeStatusBusinessTool statusWithRequestParameter:reqPara sucess:^(WJHomeStatusResult *successData) {
        // status模型转换成statusFrame模型
        NSMutableArray *statusframes = (NSMutableArray *)[self statusFramesWithStatuses:successData.statuses];
        // 把刷新到最新的微博数据 添加到 旧数据的最前面
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, statusframes.count)];
        [self.statusFrames insertObjects:statusframes atIndexes:indexSet];
        // 重新刷新界面
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView headerEndRefreshing];
        // 提示用户有几条最新的微博
        [self tellUserHowManyNewStatuses:successData.statuses.count];
    } failure:^(NSError *failure) {
        // 提示错误信息
        [MBProgressHUD showError:@"网络繁忙，稍后再试"];
        // 结束刷新
        [self.tableView headerEndRefreshing];
    }];
    
}
/**
 *  上拉刷新更多微博数据
 */
- (void)upLoadMoreStatus
{
    WJStatusRequestParameter *reqPara = [[WJStatusRequestParameter alloc] init];
    reqPara.access_token = [WJAccountTool read].access_token;
    if (self.statusFrames.count) {
        reqPara.max_id = @([[[[self.statusFrames lastObject] status] idstr] longLongValue] - 1);
    }
    
    [WJHomeStatusBusinessTool statusWithRequestParameter:reqPara sucess:^(WJHomeStatusResult *successData) {
        // statuses模型数组转换为statusframes数组
        NSMutableArray *statusFrames = (NSMutableArray *)[self statusFramesWithStatuses:successData.statuses];
        // 把刷新到最新的微博数据 添加到 旧数据的最后面
        [self.statusFrames addObjectsFromArray:statusFrames];
        // 重新刷新界面
        [self.tableView reloadData];
        // 结束刷新，隐藏footerView
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *failure) {
        // 提示错误信息
        [MBProgressHUD showError:@"网络繁忙，稍后再试"];
        // 结束刷新
        [self.tableView footerEndRefreshing];
    }];
    
    //    WJLog(@"一直在加载。。。。");
}
#pragma mark -------------------


- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    // 返回和statuses一样大小的数组
//    WJStatusFrame *statusFrame = [[WJStatusFrame alloc] init];  // 把这句写在循环外面，也是傻逼了！！！！！！！！！！！
    NSMutableArray *statusFrames = [NSMutableArray arrayWithCapacity:statuses.count];
    for (WJStatus *status in statuses) {
//#warning 为什么重写statusframe模型中status属性的set方法
// 在status的set方法中计算各子控件的frame，在赋值数据的同时，计算frame
        WJStatusFrame *statusFrame = [[WJStatusFrame alloc] init];
        statusFrame.status = status;
        [statusFrames addObject:statusFrame];
    }
    
    return statusFrames;
}

/**
 *  告诉用户有多少条新微博
 */
- (void)tellUserHowManyNewStatuses:(NSUInteger)count
{
    NSString *title = @"没有新微博";
    if (count) {
        title = [NSString stringWithFormat:@"有%ld条新微博", count];
    }
    
    // 使用自己设计的框架－从状态栏上面提醒
//    [WJStatusBarHUD showMessage:title image:nil];
//    [WJStatusBarHUD showSuccess:title];
    
    // 按照新浪官方的样子做,从导航栏下面提醒(因为只有这里用到，所以就不考虑封装什么的了)
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];  // 平铺
    label.font = [UIFont systemFontOfSize:14];
    label.width = self.view.width;
    label.height = 35;
    label.x = 0;
    label.y = -label.height + 64;
    [self.view addSubview:label];
//    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    [UIView animateWithDuration:1.0 animations:^{
        label.y = 64;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.y = -label.height + 64;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}


/**
 *  设置导航栏
 */
- (void)setupNavigationBar
{
    // 导航栏左边的item
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBg:@"navigationbar_friendsearch" highBg:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendsearch)];
    
    // 导航栏右边的item
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBg:@"navigationbar_pop" highBg:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    // 导航栏中间的titleButton
    WJTitleButton *titleButton = [[WJTitleButton alloc] init];
    NSString *name = [WJAccountTool read].name;  // 但第一次进来的时候name可能没有值
    name = name ? name : @"首页";           // 所以要判断一下
    [titleButton setTitle:name forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;

}
- (void)pop
{
    WJLog(@"pop");
}

- (void)friendsearch
{
    WJLog(@"friendsearch");
}
/**
 *  点击了导航栏中间的按钮
 */
- (void)titleButtonClick:(WJTitleButton *)titleButton
{
    WJMenuTestController *menuTestVc = [[WJMenuTestController alloc] init];
    menuTestVc.view.width = 150;
    menuTestVc.view.height = 200;
    menuTestVc.view.autoresizingMask = UIViewAutoresizingNone;
    
    [WJPopMenu popMenuFromRect:self.navigationItem.titleView.bounds inView:self.navigationItem.titleView contentVc:menuTestVc dismiss:^{
        titleButton.selected = !titleButton.isSelected;
    }];
    
    titleButton.selected = !titleButton.isSelected;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJTableViewCell *cell = [WJTableViewCell cellWithTableView:tableView];
    cell.statusFrame = self.statusFrames[indexPath.row];
    return cell;
}

#pragma scrollView 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.statusFrames[indexPath.row] cellHeight];
}

@end
