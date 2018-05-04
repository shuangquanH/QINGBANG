//
//  NSString+LDAttributedString.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "NSString+LDAttributedString.h"

@implementation NSString (LDAttributedString)
- (NSAttributedString *)ld_attributedStringFromNSString:(NSString *)normalString startLocation:(NSInteger)location forwardFont:(UIFont *)forwardFont backFont:(UIFont *)backFont forwardColor:(UIColor *)forwardColor backColor:(UIColor *)backColor{
    
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
-(NSAttributedString *)ld_getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}


@end
