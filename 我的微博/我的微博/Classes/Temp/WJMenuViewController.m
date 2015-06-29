//
//  WJMenuViewController.m
//  我的微博
//
//  Created by wangjie on 15-3-31.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJMenuViewController.h"

@interface WJMenuViewController ()
//@property (nonatomic, strong) NSArray *data;
@end

@implementation WJMenuViewController

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.data = @[@"2B", @"SB"];
//}

#pragma ---数据源协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"2B";
    } else {
        cell.textLabel.text = @"SB";
    }
    
    return cell;
}

@end
