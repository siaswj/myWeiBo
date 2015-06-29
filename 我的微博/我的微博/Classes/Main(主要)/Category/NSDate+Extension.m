//
//  NSDate+Extension.m
//  我的微博
//
//  Created by wangjie on 15-4-5.
//  Copyright (c) 2015年 sias. All rights reserved.
//

/*
 *  可以用时间格式化类(NSDateFormatter)来做，也可以用日历类来做，这里使用日历类(NSCalendar)来做。。
 */

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *   返回NO ： 不是今年：显示 年-月-日-时-分， 返回YES ： 是今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear= [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

/**
 *   昨天：显示 时－分
 */
- (BOOL)isYesterday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];    // toDate－fromDate
    
    return components.day == 1;
}

/**
 *  返回YES ： 今天， 返回NO ： 不是今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];
    return components.day == 0;
}

/**
 *  比较self和toDate的时间差距
 */
- (NSDateComponents *)componentsToDate:(NSDate *)toDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *components = [calendar components:unit fromDate:self toDate:toDate options:0];
    
    return components;
}

@end
