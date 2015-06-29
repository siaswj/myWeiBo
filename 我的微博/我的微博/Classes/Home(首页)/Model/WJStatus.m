//
//  WJStatus.m
//  我的微博
//
//  Created by wangjie on 15-4-4.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJStatus.h"
#import "MJExtension.h"
#import "WJPicUrl.h"
#import "NSDate+Extension.h"   // 使用封装的分类
#import "RegexKitLite.h"
#import "WJTextPart.h"
#import "WJEmotionTool.h"
#import "WJEmotion.h"

#define WJAtttibutedTextSize 16  // 属性文本的size

@implementation WJStatus

/**
 *  告诉外界status对象的picurls数组属性中，存放的是WJPicUrl类型的对象
 */
- (NSDictionary *)objectClassInArray
{
    return @{
             @"pic_urls" : [WJPicUrl class]
             };
}

/**
 *  设置微博的来源
 *  
 *  字典转模型：其实就是把字典传给你，然后转换一下，返回一个模型对象........(就是在属性的set方法中)
 */
- (void)setSource:(NSString *)source
{
    if (source.length) {
        NSUInteger location = [source rangeOfString:@">"].location + 1;
        NSUInteger length = [source rangeOfString:@"</"].location - location;
        source = [source substringWithRange:NSMakeRange(location, length)];
    } else {
        source = @"新浪微博";
    }
    
    _source = [@"来自" stringByAppendingString:source];
}

/**
 *  微博的日期格式处理
 */
- (NSString *)created_at
{
    /*
     1分钟内：刚刚
     1小时内：x分钟前
     其他：x小时前
     昨天：昨天
     几天前：显示具体日期
     不是今年：显示年月日时分
     */
    
    // 日期格式化类对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 日期格式
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
    // 真机上要说明所属区域
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 把日期的字符串格式转换成NSDate类型
    NSDate *date = [formatter dateFromString:_created_at];
    
    // 这里明显使用封装比较好，而且分类比较合适！！！！－－－－NSDate的分类
    if ([date isThisYear]) {   // 今年
        if ([date isToday]) {   // 今天
            
            NSDateComponents *components = [date componentsToDate:[NSDate date]];
            if (components.hour >= 1) {   // x小时前：显示几小时前
                return [NSString stringWithFormat:@"%ld小时前", components.hour];
            } else if (components.minute >= 1) {   // 1小时内：显示几分钟前
                return [NSString stringWithFormat:@"%ld分钟前", components.minute];
            } else {   // 1分钟内：显示刚刚
                return @"刚刚";
            }
            
        } else if ([date isYesterday]) {   // 昨天：显示 时－分
            
            formatter.dateFormat = @"HH:mm";
            return [formatter stringFromDate:date];
            
        } else {   // 几天前：显示 月-日-时-分
            
            formatter.dateFormat = @"MM-dd HH:mm";
            return [formatter stringFromDate:date];
            
        }
    } else {   // 不是今年：显示 年-月-日-时-分
        
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:date];
        
    }
}

//- (void)setCreated_at:(NSString *)created_at
//{
//    // 日期格式类
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//    // NSString -> NSDate
//    formatter.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
//    NSDate *date = [formatter dateFromString:created_at];
//    
//    // NSDate -> NSString
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    _created_at = [formatter stringFromDate:date];
//}

// 设置原创微博的正文的时候，包装改文字内容为属性文字
- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    self.attributedText = [self attributedStringWithText:_text];
}

// 设置转发微博的时候，设置转发微博的内容文字为带有属性文字的字符串
- (void)setRetweeted_status:(WJStatus *)retweeted_status
{
    _retweeted_status = retweeted_status;
    
    // 拼接 @ 和 用户名 和 微博正文 -> 一个普通的完整的字符串
    NSString *reStatusText = [NSString stringWithFormat:@"@%@:%@", retweeted_status.user.name, retweeted_status.text];
    // 普通字符串转为带有属性的字符串
    self.reStatusAttributedText = [self attributedStringWithText:reStatusText];
}

// 把普通的文字包装成带有属性的文字
- (NSMutableAttributedString *)attributedStringWithText:(NSString *)text
{
    // 匹配规则上定义的可能还有一点不完整，如: 话题中间有空格，有 ‘-’ 线等。。。。。。。
    
    // 0.匹配规则
    NSString *emotionPattern = @"\\[\\w+\\]";
    NSString *URLPattern = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    NSString *topicPattern = @"#\\w+#";
    NSString *atPattern = @"@\\w+:";
    // 枚举值可以使用 | 连接起来 达到‘叠加’的效果
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, URLPattern, topicPattern, atPattern];
    
    // 第一种方法：利用系统自带的方法来匹配，但在此时的场景下，这种方法不是太方便
    /*
    // 1.创建正则表达式对象
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:NULL];
    
    // 2.利用regex的四个方法来匹配
    // 数组里面存储的都是NSTextCheckingResult对象
    NSArray *results = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    // 创建一个带有属性的字符串，来表示整个微博内容
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    // 遍历数组中的对象
    for (NSTextCheckingResult *result in results) {
        //WJLog(@"%@", [text substringWithRange:result.range]);
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
    }
    */

    
    // 第二种方法：利用第三方框架 RegexKitLite 来匹配。使用的是待匹配字符串的方法
    NSMutableArray *partAttributedStrings = [NSMutableArray array];
    
    // 获取所有匹配到的字符串。第一个参数： 匹配的规则， 第二个参数block： 匹配完成之后的回调
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        // 匹配完成之后会调用这个block，并传入匹配到的字符串,rang等值
        // 把传入的字符串用WJTextPart对象保存起来
        WJTextPart *part = [[WJTextPart alloc] init];
        part.textPart = *capturedStrings;
        part.textPartRange = *capturedRanges;
        part.specialString = YES;
        if ([part.textPart hasPrefix:@"["] && [part.textPart hasSuffix:@"]"]) {
            part.emotionString = YES;
        }
        
        [partAttributedStrings addObject:part];
    }];
    
    // 获取所有不匹配的字符串。第一个参数： 匹配的规则， 第二个参数block： 匹配完成之后的回调
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        WJTextPart *part = [[WJTextPart alloc] init];
        part.textPart = *capturedStrings;
        part.textPartRange = *capturedRanges;
        part.specialString = NO;
        
        [partAttributedStrings addObject:part];
    }];
    
    // 对数组中的元素进行排序, 按照rang的大小重新拼接出正确的字符串
    // 不太明白这个方法。。。。
    [partAttributedStrings sortUsingComparator:^NSComparisonResult(WJTextPart *obj1, WJTextPart *obj2) {
        if (obj1.textPartRange.location > obj2.textPartRange.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    // 创建一个数组，用来存储不是表情的特殊字符串，然后传递给WJStatusTextView对象
    NSMutableArray *speStrArray = [NSMutableArray array];
    // 把普通的字符串转为带有属性的字符串, attrstr代表整个微博文本字符串
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] init];
    
    for (WJTextPart *partString in partAttributedStrings) {
        
        NSAttributedString *temp = [[NSAttributedString alloc] init];
        
        if (partString.emotionString) {   // 表情字符串
            // 根据 表情字符串 获取 对应的表情模型
            WJEmotion *emotion = [WJEmotionTool emotionWithChs:partString.textPart];
            // 根据 表情模型 获取 对应的表情的路径
            NSString *emotionImagePath = [NSString stringWithFormat:@"%@/%@", emotion.folder, emotion.png];
            // 设置表情字符串的附件
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = [UIImage imageNamed:emotionImagePath];   // 注意这里的路径！！。。
            attachment.bounds = CGRectMake(0, -3, WJAtttibutedTextSize, WJAtttibutedTextSize);
            temp = [NSAttributedString attributedStringWithAttachment:attachment];
            
        } else if (partString.specialString && !partString.emotionString) {   // 不是表情的特殊字符串
            temp = [[NSAttributedString alloc] initWithString:partString.textPart attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
            
            // 里面存储的都是‘不是表情的特殊字符串’的WJTextPart模型对象(字符串碎片)
            [speStrArray addObject:partString];
            
        } else {  // 非特殊字符串
            temp = [[NSAttributedString alloc] initWithString:partString.textPart];
            
        }
        
        [attrstr appendAttributedString:temp];
    }

#warning mark - 如果想要通过属性字符串计算字符串的size, 在计算之前必须先设置字符串的字体大小, 如果不设置, 计算出来的值会不正确。 就好比计算普通字符串也必须设置字符串的size一样，需要告诉系统字符串字体的size。
    // 设置属性字符串的字体大小
    [attrstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:WJAtttibutedTextSize] range:NSMakeRange(0, attrstr.length)];
    
#warning mark - TODO。微博文本中，非表情特殊字符串前面如果有表情，则点击添加的View的Frame不对，需重新计算‘不是表情的特殊字符串’的rang值
    // 重新计算‘不是表情的特殊字符串’的rang值（因为显示表情的时候会有bug）

    
    // 把 speStrArray数组 绑定到attrstr的第一个字符上，当attrstr传递到WJOriginalStatus对象的contentLabel.attributedText属性上时，对应的数组也随之传递到WJOriginalStatus对象上的WJStatusTextView对象(WJOriginalStatus对象的.contentLabel)属性中
    [attrstr addAttribute:@"speStrArray" value:speStrArray range:NSMakeRange(0, 1)];
    
    return attrstr;
}

@end
