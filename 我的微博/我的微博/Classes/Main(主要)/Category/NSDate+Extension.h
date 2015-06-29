//
//  NSDate+Extension.h
//  我的微博
//
//  Created by wangjie on 15-4-5.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 *   返回NO ： 不是今年：显示 年-月-日-时-分， 返回YES ： 是今年
 */
- (BOOL)isThisYear;

/**
 *   昨天：显示 时－分
 */
- (BOOL)isYesterday;

/**
 *  返回YES ： 今天， 返回NO ： 不是今天
 */
- (BOOL)isToday;

/**
 *  比较self和toDate的时间差距
 */
- (NSDateComponents *)componentsToDate:(NSDate *)toDate;

#warning 有一个方法我没有实现
// 还有一个方法，我没有实现，不知道这样会不会不严谨。。
/**
 *  将一个时间变为只有年月日的时间(时分秒都是0)
 */
//- (NSDate *)ymd;

@end
