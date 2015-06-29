//
//  WJHomeViewController.h
//  我的微博
//
//  Created by wangjie on 15-3-27.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJHomeViewController : UIViewController
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

// 下拉刷新,提供给外界的借口用于告诉首页控制器刷新首页上的微博数据
- (void)refresh;
@end
