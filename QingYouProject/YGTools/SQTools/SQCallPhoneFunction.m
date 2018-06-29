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
    [YGAlertView showAlertWithTitle:title buttonTitlesArray:@[@"取消", @"确定"] buttonColorsArray:@[kCOLOR_333, KCOLOR_MAIN] handler:^(NSInteger buttonIndex) {
        if (buttonIndex!=0) {
            [self callWithPhoem:phone];
        }
        
    }];


}



@end
