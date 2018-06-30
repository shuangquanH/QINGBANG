//
//  NSString+SQJudge.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/30.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "NSString+SQJudge.h"

@implementation NSString (SQJudge)
- (BOOL)isBlankString {
    if (!self) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!self.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [self stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}
@end
