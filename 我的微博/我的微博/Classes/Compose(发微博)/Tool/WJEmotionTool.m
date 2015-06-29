//
//  WJEmotionTool.m
//  我的微博
//
//  Created by wangjie on 15-4-10.
//  Copyright (c) 2015年 sias. All rights reserved.
//  表情数据类（工具类）

#import "WJEmotionTool.h"
#import "WJEmotion.h"
#import "MJExtension.h"

#define WJRecentEmotionFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentEmotion.data"]

@implementation WJEmotionTool

// 采取懒加载的方式加载表情数据，但因为这个工具类提供的都是类方法，所以不能用成员变量
static NSArray *_defaultEmotion;
static NSArray *_lxhEmotion;

/**
 *  返回默认表情
 *  从plist中加载表情数据
 *  数组中装的都是模型（一个表情对应一个模型）
 */
+ (NSArray *)defaultEmotion;
{
    if (_defaultEmotion == nil) {
        // 去main.bundle中加载表情数据（plist）
        _defaultEmotion = [WJEmotion objectArrayWithFilename:@"default/info.plist"];
        // 让_defaultEmotion中的每个对象都执行这个setFolder:方法，来设置folder的值,default是参数
        [_defaultEmotion makeObjectsPerformSelector:@selector(setFolder:) withObject:@"default"];
    }
    return _defaultEmotion;
}

/**
 *  返回浪小花表情
 */
+ (NSArray *)lxhEmotion
{
    if (_lxhEmotion == nil) {
        // 去main.bundle中加载表情数据（plist）
        _lxhEmotion = [WJEmotion objectArrayWithFilename:@"lxh/info.plist"];
        [_lxhEmotion makeObjectsPerformSelector:@selector(setFolder:) withObject:@"lxh"];
    }
    return _lxhEmotion;
}


static NSMutableArray *_recentEmotion;

/**
 *  返回最近使用的表情
 */
+ (NSArray *)recentEmotion
{
    if (_recentEmotion == nil) {
        _recentEmotion = [NSKeyedUnarchiver unarchiveObjectWithFile:WJRecentEmotionFile];
        if (_recentEmotion == nil) {
            _recentEmotion = [NSMutableArray array];
        }
    }
    return _recentEmotion;
    
}

/**
 *  保存刚使用的表情对象
 */
+ (void)addRecentEmotion:(WJEmotion *)emotion
{
    // 先加载之前存储的表情
    [self recentEmotion];
    // 删除此时数组中和这次emotion表情相同的表情（默认会调用emotion对象的isEqual:,所以可以在这个方法中控制,找到和他相同的对象）
    [_recentEmotion removeObject:emotion];
    
    // 把传进来的模型存入数组中
    [_recentEmotion insertObject:emotion atIndex:0];
    
    // 控制最近的表情只显示一页
    if (_recentEmotion.count > 20) {
        [_recentEmotion removeObjectAtIndex:20];
    };
    
    // 直接把数组存进去（没存一次就覆盖以前的一次）
    [NSKeyedArchiver archiveRootObject:_recentEmotion toFile:WJRecentEmotionFile];
}


+ (WJEmotion *)emotionWithChs:(NSString *)chs
{
    // 获取所有的默认表情模型
    NSArray *defaultEmotion = [self defaultEmotion];
    for (WJEmotion *emotion in defaultEmotion) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    
    // 获取所有的浪小花表情模型
    NSArray *lxhEmotion = [self lxhEmotion];
    for (WJEmotion *emotion in lxhEmotion) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    
    return nil;
}
@end
