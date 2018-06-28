//
//  NSString+SQAttributeString.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "NSString+SQAttributeString.h"

@implementation NSString (SQAttributeString)


- (NSAttributedString *)attributedStringFromNSString:(NSString *)normalString startLocation:(NSInteger)location forwardFont:(UIFont *)forwardFont backFont:(UIFont *)backFont forwardColor:(UIColor *)forwardColor backColor:(UIColor *)backColor{
    
    NSAssert(location < normalString.length,@"normalString字符串的长度要大于 startLocation");
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:normalString];
    
    if (location == 0) {
        
    }else {
        
        //前段文字 设置 : Font 和 Color
        [attrStr addAttribute:NSFontAttributeName
                        value:forwardFont
                        range:NSMakeRange(0,location)];
        
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:forwardColor
                        range:NSMakeRange(0,location)];
    }
    
    
    //后段文字 设置 : Font 和 Color
    [attrStr addAttribute:NSFontAttributeName
                    value:backFont
                    range:NSMakeRange(location,normalString.length - location)];
    
    
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:backColor
                    range:NSMakeRange(location,normalString.length - location)];
    
    return attrStr;
    
}
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}


@end
