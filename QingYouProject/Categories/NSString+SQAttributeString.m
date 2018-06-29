//
//  NSString+SQAttributeString.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "NSString+SQAttributeString.h"

@implementation NSString (SQAttributeString)

- (NSAttributedString *)setTextColor:(UIColor *)color andRange:(NSRange)range {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:range];
    return attrStr;
}

- (NSAttributedString *)setTextFont:(UIFont *)font andRange:(NSRange)range {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:range];
    return attrStr;
}

- (NSAttributedString *)setTextColor:(UIColor *)color andFont:(UIFont *)font withRange:(NSRange)range {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:range];
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:range];
    return attrStr;
}





- (NSAttributedString *)sqAttributeStringWithCutIndex:(NSInteger)index withLeftFont:(UIFont *)lfont rightFont:(UIFont *)rfont leftColor:(UIColor *)lcolor rightColor:(UIColor *)rcolor {
    
    NSAssert(index<self.length,@"分割点位置不能大于字符串长度!");
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    if (lfont) {
        [attrStr addAttribute:NSFontAttributeName
                        value:lfont
                        range:NSMakeRange(0,index)];
    }
    if (lcolor) {
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:lcolor
                        range:NSMakeRange(0,index)];
    }
    
    if (rfont) {
        [attrStr addAttribute:NSFontAttributeName
                        value:rfont
                        range:NSMakeRange(index,self.length - index)];
    }
    if (rcolor) {
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:rcolor
                        range:NSMakeRange(index,self.length - index)];
    }
    
    return attrStr;
}

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
