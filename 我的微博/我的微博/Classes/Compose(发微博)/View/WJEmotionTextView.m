//
//  WJEmotionTextView.m
//  我的微博
//
//  Created by wangjie on 15-4-12.
//  Copyright (c) 2015年 sias. All rights reserved.
//

#import "WJEmotionTextView.h"
#import "WJEmotionAttachment.h"
#import "WJEmotion.h"

@implementation WJEmotionTextView

- (void)insertEmotion:(WJEmotion *)emotion
{
    // 生成一个带图片的属性文字(attachment : 附件)
    WJEmotionAttachment *attachment = [[WJEmotionAttachment alloc] init];
    
    attachment.emotion = emotion;
    attachment.bounds = CGRectMake(0, -4, self.font.lineHeight, self.font.lineHeight);
    
    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 光标所在的位置
    NSUInteger oldLocation = self.selectedRange.location;
    // 创建一个属性字符串
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    
    [attrString appendAttributedString:self.attributedText];
    [attrString replaceCharactersInRange:self.selectedRange withAttributedString:imageString];
    // 给这个属性字符串添加一些属性
    [attrString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attrString.length)];
    
    self.attributedText = attrString;
    self.selectedRange = NSMakeRange(oldLocation + 1, 0);
}

// textView中的属性文字拼接转换成普通文字（发送的网络数据是普通文字）
- (NSString *)emotionText
{
    // 把textView中的属性文字拼接转换成普通文字（发送的网络数据是普通文字）
    NSMutableString *text = [NSMutableString string];
    
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        // 根据block中attrs参数的key:NSAttachment取出一个属性文字对应的attachment附件
        WJEmotionAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment) {
            // 拼接图片对应的文字
            [text appendString:attachment.emotion.chs];
        } else {
            // 拼接文字对应的属性文字
            NSAttributedString *attrString = [self.attributedText attributedSubstringFromRange:range];
            [text appendString:attrString.string];
        }
    }];
    
    return text;
}

@end
