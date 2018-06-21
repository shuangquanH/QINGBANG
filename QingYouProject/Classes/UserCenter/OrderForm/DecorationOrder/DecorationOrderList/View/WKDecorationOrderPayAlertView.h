//
//  WKDecorationOrderPayAlertView.h
//  QingYouProject
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKDecorationOrderDetailModel;

typedef NS_ENUM(NSUInteger, WKDecorationPayType) {
    WKDecorationPayTypeAliPay,
    WKDecorationPayTypeWechatPay
};

@interface WKDecorationOrderPayAlertView : UIView

@property (nonatomic, copy) void (^ paymentAction)(WKDecorationPayType payType);

- (void)showPaymentViewInSuperView:(UIView *)superView;

- (void)dismissPaymentView;

@end
