//
//  WJEmotion.m
//  我的微博
//
//  Created by wangjie on 15-4-10.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJEmotion.h"
#import "MJExtension.h"

@implementation WJEmotion

MJCodingImplementation // 这一句就是下面两个方法

///**
// *  从文件中解析对象的时候调用：说明对象的那些属性需要读取
// */
//- (id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        self.chs = [decoder decodeObjectForKey:@"chs"];
//        self.png = [decoder decodeObjectForKey:@"png"];
//        self.folder = [decoder decodeObjectForKey:@"folder"];
//    }
//    
//    return self;
//}
//
///**
// *  把一个对象写入文件的时候调用：说明对象的那些属性需要被存储
// */
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.chs forKey:@"chs"];
//    [encoder encodeObject:self.png forKey:@"png"];
//    [encoder encodeObject:self.folder forKey:@"folder"];
//}

/**
 *  会在对比两个对象是否为同一个对象的时候调用
 */
- (BOOL)isEqual:(WJEmotion *)object
{
    return [self.chs isEqualToString:object.chs];
}
@end
