//
//  WJTableViewCell.h
//  我的微博
//
//  Created by wangjie on 15-5-20.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJStatusFrame;

@interface WJTableViewCell : UITableViewCell
@property (nonatomic, strong) WJStatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
