//
//  WKDecorationOrderAlertView.h
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKDecorationOrderAlertView : UIView

+ (WKDecorationOrderAlertView *)alertWithDetail:(NSString *)detail titles:(NSArray<NSString *> *)titles bgColors:(NSArray<UIColor *> *)bgColor handler:(void(^)(NSInteger index))handler;

@end
