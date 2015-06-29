//
//  WJHomeStatusBusinessTool.m
//  我的微博
//
//  Created by wangjie on 15-6-11.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJHomeStatusBusinessTool.h"
#import "MJExtension.h"
#import "WJHTTPTool.h"
#import "FMDB.h"
#import "WJAccountTool.h"
#import "WJStatus.h"

@implementation WJHomeStatusBusinessTool

/**
 *  数据库
 */
FMDatabase *_fmdb;

/**
 *  只要使用了这个微博业务类，就说明可能要存储数据，就需要打开/用到数据库
 */
+ (void)initialize
{
    // 获取数据库的路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [documentPath stringByAppendingPathComponent:@"status.sqlite"];
    WJLog(@"%@", documentPath);
    
    // 创建/打开数据库
    _fmdb = [FMDatabase databaseWithPath:sqlitePath];
    
    if ([_fmdb open]) {
        WJLog(@"打开数据库成功");
        // 创建/打开表
        NSString *sql = @"CREATE TABLE IF NOT EXISTS t_status  (id INTEGER PRIMARY KEY AUTOINCREMENT, idstr TEXT NOT NULL, dict BLOB NOT NULL, access_token TEXT NOT NULL);";
        if ([_fmdb executeUpdate:sql]) {
            WJLog(@"创建表成功");
        }
    }
}

/** 从哪里加载微博数据 */
+ (void)statusWithRequestParameter:(WJStatusRequestParameter *)ReqParameter sucess:(successBlock)success failure:(failureBlock)failure
{
    NSArray *statuses = [self statusCacheWithRequest:ReqParameter];
    
    if (statuses.count > 0) {      // 本地获取数据
        if (success) {
            WJHomeStatusResult *result = [[WJHomeStatusResult alloc] init];
            result.statuses = statuses;
            success(result);
        }
    } else {        // 网络获取数据
        [WJHTTPTool get:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:ReqParameter.keyValues success:^(id responseObject) {
            
            // 把加载到的微博数据写入到本地数据库中
            for (NSDictionary *statusDic in responseObject[@"statuses"]) {
                [self saveStatusCache:statusDic];
            }
            
            // 把加载的最新数据转成模型
            WJHomeStatusResult *result = [WJHomeStatusResult objectWithKeyValues:responseObject];
            
            // 如果成功的block有值，就把获取的数据传出去
            if (success) {    // 这里应该有block的循环引用问题
                success(result);
            }
        } failure:^(NSError *error) {
            // 如果失败了，就把错误的信息传出去
            if (failure) {
                failure(error);
            }
        }];

    }
}

/**
 *  读取本地缓存的数据
 *  @param reqPara 请求参数模型
 *  @return 缓存的微博数据。里面装的是WJStatus模型
 */
+ (NSArray *)statusCacheWithRequest:(WJStatusRequestParameter *)reqPara
{
    NSMutableArray *statusArray = [NSMutableArray array];
    
    // 1.根据请求参数模型中有没有since_id和max_id，来判断是上拉刷新还是下拉刷新，还是刚启动数据库
    // 从数据库中返回的数据类型是 FMResultSet
    FMResultSet *set = nil;
    if (reqPara.since_id) {    // 下拉刷新
        // 返回比since_id大的微博数据
        set = [_fmdb executeQuery:@"SELECT * FROM t_status WHERE idstr > ? AND access_token = ? ORDER BY idstr DESC LIMIT ?", reqPara.since_id , reqPara.access_token, reqPara.count];
        
    } else if (reqPara.max_id) {   // 上拉刷新
        // 返回小于或等于max_id的微博
        set = [_fmdb executeQuery:@"SELECT * FROM t_status WHERE idstr <= ? AND access_token = ? ORDER BY idstr DESC LIMIT ?", reqPara.max_id , reqPara.access_token, reqPara.count];
        
    } else {    // 刚启动数据库
        set = [_fmdb executeQuery:@"SELECT * FROM t_status WHERE  access_token = ? ORDER BY idstr DESC LIMIT ?", reqPara.access_token, reqPara.count];
    }
    
    // 2.FMResultSet -> WJStatus , set -> statusArray
    while ([set next]) {
        // 取出二进制形式的微博数据
        NSData *data = [set dataForColumn:@"dict"];   //column : 列的意思，代表字段的名称。
        // 二进制数据转为字典数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        // 字典数据转为模型数据
        WJStatus *status = [WJStatus objectWithKeyValues:dict];
        // 模型添加到模型数组中
        [statusArray addObject:status];
    }
    
    return statusArray;
}

/**
 *  保存传入的微博对象到本地
 *  @param statusDic 需要保存的微博对象
 *  @return 是否保存成功
 */
+ (BOOL)saveStatusCache:(NSDictionary *)statusDic
{
    // 字典转成二进制数据
    NSData *statusData = [NSJSONSerialization dataWithJSONObject:statusDic options:NSJSONWritingPrettyPrinted error:NULL];
    // 表的字段参数
    NSString *access_token = [WJAccountTool read].access_token;
    NSString *idstr = statusDic[@"idstr"];
    
    // 存储数据
    BOOL success = [_fmdb executeUpdate:@"INSERT INTO t_status (idstr, dict, access_token) VALUES (?, ?, ?);", idstr, statusData, access_token];
    
    if (success) {
        WJLog(@"存储数据成功");
        return YES;
    } else {
        WJLog(@"存储数据失败");
        return NO;
    }
}

@end
