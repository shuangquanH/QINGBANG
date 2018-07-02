//
//  SQCallPhoneFunction.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQCallPhoneFunction.h"
#import "WKDecorationOrderAlertView.h"


@implementation SQCallPhoneFunction

+ (void)callServicePhone {
    [self callWithPhoem:KSERVICE_PHONE];
}
+ (void)callServicePhoneWithPopver {
    [self callWithPhoem:KSERVICE_PHONE withPopverTitle:@"是否拨打客服电话?"];
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

+ (void)callWithPhoem:(NSString *)phone withPopverTitle:(NSString *)title {
    [WKDecorationOrderAlertView alertWithDetail:title titles:@[@"确定", @"取消"] bgColors:@[KCOLOR_MAIN, KCOLOR(@"98999A")] handler:^(NSInteger index) {
        if (index == 0) {
            [self callWithPhoem:phone];
        }
    }];
}



@end
