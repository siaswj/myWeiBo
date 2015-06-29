//
//  WJHTTPTool.h
//  我的微博
//
//  Created by wangjie on 15-4-14.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJHTTPTool : NSObject
+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  文件上传
 *  因为file参数本身要带很多参数，一种方法是传字典实现一对一，但字典不太好，所以要传一个模型对象实现一对一传参
 *  @param files  数组里面装的都是 WJHTTPFile模型对象
 */
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters files:(NSArray *)files success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end




#pragma mark - WJHTTPFile模型类的声明
@interface WJHTTPFile : NSObject

/** 文件的数据 */
@property (nonatomic, strong) NSData *data;
/** 文件的参数名 */
@property (nonatomic, copy) NSString *name;
/** 文件名 */
@property (nonatomic, copy) NSString *filename;
/** 文件的类型 */
@property (nonatomic, copy) NSString *mimeType;

+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType;

@end
