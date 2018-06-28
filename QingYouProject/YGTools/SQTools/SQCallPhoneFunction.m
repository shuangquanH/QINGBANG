//
//  SQCallPhoneFunction.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQCallPhoneFunction.h"

@implementation SQCallPhoneFunction

+ (void)callServicePhone {
    [self callWithPhoem:KSERVICE_PHONE];

}
+ (void)callWithPhoem:(NSString *)phone {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
    CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
    if (version >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

@end
