//
//  WJHTTPTool.m
//  我的微博
//
//  Created by wangjie on 15-4-14.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJHTTPTool.h"
#import "AFNetworking.h"

@implementation WJHTTPTool

+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters files:(NSArray *)files success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (WJHTTPFile *file in files) {
            [formData appendPartWithFileData:file.data name:file.name fileName:file.filename mimeType:file.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

@end






#pragma mark - WJHTTPFile模型类的实现
@implementation WJHTTPFile

+ (instancetype)fileWithData:(NSData *)data name:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType
{
    WJHTTPFile *file = [[self alloc] init];
    file.data = data;
    file.name = name;
    file.filename = filename;
    file.mimeType = mimeType;
    return file;
}

@end



