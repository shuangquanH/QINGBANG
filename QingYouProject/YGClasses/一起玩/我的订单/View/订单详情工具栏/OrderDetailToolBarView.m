//
//  OrderDetailToolBarView.m
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/4.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderDetailToolBarView.h"

@implementation OrderDetailToolBarView

- (instancetype)initWithOrderType:(OrderType)orderType
{
    if(self = [super init])
    {
        _orderType = orderType;
        self.frame = CGRectMake(0, KAPP_HEIGHT - KTAB_HEIGHT - KNAV_HEIGHT, KAPP_WIDTH, KTAB_HEIGHT);
        self.backgroundColor = colorWithYGWhite;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    switch (_orderType) {
        case PAYMENTPENDINGORDER:
        {
            UIButton * goPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            goPayButton.frame = CGRectMake(YGScreenWidth - 12.5 - 70, 15, 70, 25);
            [goPayButton setTitle:@"去支付" forState:UIControlStateNormal];
            [goPayButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
            goPayButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            goPayButton.layer.cornerRadius = 12.5;
            goPayButton.layer.masksToBounds = YES;
            goPayButton.layer.borderColor = colorWithMainColor.CGColor;
            goPayButton.layer.borderWidth = 0.8;
            [goPayButton addTarget:self action:@selector(goPayButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:goPayButton];
            
            UIButton * cancelOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelOrderButton.frame = CGRectMake(CGRectGetMinX(goPayButton.frame) - 15 - 70, 15, 70, 25);
            [cancelOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [cancelOrderButton addTarget:self action:@selector(cancelOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [cancelOrderButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            cancelOrderButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            cancelOrderButton.layer.cornerRadius = 12.5;
            cancelOrderButton.layer.masksToBounds = YES;
            cancelOrderButton.layer.borderColor =colorWithTabNaviLine.CGColor;
            cancelOrderButton.layer.borderWidth = 0.8;
            [self addSubview:cancelOrderButton];
            
            UIButton * callSponsorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            callSponsorButton.frame = CGRectMake(CGRectGetMinX(cancelOrderButton.frame) - 15 - 85, 15, 85, 25);
            [callSponsorButton addTarget:self action:@selector(callSponsorButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [callSponsorButton setTitle:@"联系主办方" forState:UIControlStateNormal];
            [callSponsorButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            callSponsorButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            callSponsorButton.layer.cornerRadius = 12.5;
            callSponsorButton.layer.masksToBounds = YES;
            callSponsorButton.layer.borderColor =colorWithTabNaviLine.CGColor;
            callSponsorButton.layer.borderWidth = 0.8;
            [self addSubview:callSponsorButton];
            
        }
            break;
        case PARTICIPATEINORDER:
        {
            UIButton * cancelActiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelActiveButton.frame = CGRectMake(YGScreenWidth - 12.5 - 70, 15, 70, 25);
            [cancelActiveButton setTitle:@"取消活动" forState:UIControlStateNormal];
            [cancelActiveButton addTarget:self action:@selector(cancelActiveButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [cancelActiveButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            cancelActiveButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            cancelActiveButton.layer.cornerRadius = 12.5;
            cancelActiveButton.layer.masksToBounds = YES;
            cancelActiveButton.layer.borderColor = colorWithTabNaviLine.CGColor;
            cancelActiveButton.layer.borderWidth = 0.8;
            [self addSubview:cancelActiveButton];
            
            UIButton * callSponsorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            callSponsorButton.frame = CGRectMake(CGRectGetMinX(cancelActiveButton.frame) - 15 - 85, 15, 85, 25);
            [callSponsorButton setTitle:@"联系主办方" forState:UIControlStateNormal];
            [callSponsorButton addTarget:self action:@selector(callSponsorButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [callSponsorButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            callSponsorButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            callSponsorButton.tag = 10000;
            callSponsorButton.layer.cornerRadius = 12.5;
            callSponsorButton.layer.masksToBounds = YES;
            callSponsorButton.layer.borderColor =colorWithTabNaviLine.CGColor;
            callSponsorButton.layer.borderWidth = 0.8;
            [self addSubview:callSponsorButton];
        }
            break;
        case OVERORDER:
        {
            UIButton * delOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            delOrderButton.frame = CGRectMake(YGScreenWidth - 12.5 - 70, 15, 70, 25);
            [delOrderButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [delOrderButton addTarget:self action:@selector(delOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [delOrderButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            delOrderButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            delOrderButton.layer.cornerRadius = 12.5;
            delOrderButton.layer.masksToBounds = YES;
            delOrderButton.layer.borderColor = colorWithTabNaviLine.CGColor;
            delOrderButton.layer.borderWidth = 0.8;
            [self addSubview:delOrderButton];
        }
            break;
        case REFUNDSINGORDER:
        {
//            UIButton * delOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            delOrderButton.frame = CGRectMake(YGScreenWidth - 12.5 - 70, 15, 70, 25);
//            [delOrderButton setTitle:@"删除订单" forState:UIControlStateNormal];
//            [delOrderButton addTarget:self action:@selector(delOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
//            [delOrderButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
//            delOrderButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
//            delOrderButton.layer.cornerRadius = 12.5;
//            delOrderButton.layer.masksToBounds = YES;
//            delOrderButton.layer.borderColor = colorWithLightGray.CGColor;
//            delOrderButton.layer.borderWidth = 0.8;
//            [self addSubview:delOrderButton];
        }
            break;
        case REFUNDSEDORDER:
        {
            UIButton * delOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            delOrderButton.frame = CGRectMake(YGScreenWidth - 12.5 - 70, 15, 70, 25);
            [delOrderButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [delOrderButton addTarget:self action:@selector(delOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [delOrderButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            delOrderButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            delOrderButton.layer.cornerRadius = 12.5;
            delOrderButton.layer.masksToBounds = YES;
            delOrderButton.layer.borderColor = colorWithTabNaviLine.CGColor;
            delOrderButton.layer.borderWidth = 0.8;
            [self addSubview:delOrderButton];
        }
            break;
    }
}

- (void)goPayButtonClick
{
    [self.delegate payOrderButtonClickedWithOrderDetailToolBarView:self];
}

- (void)cancelOrderButtonClick
{
    [self.delegate cancelOrderButtonClickedWithOrderDetailToolBarView:self];
}

- (void)callSponsorButtonClick
{
    [self.delegate callSponsorButtonClickedWithOrderDetailToolBarView:self];
}

- (void)cancelActiveButtonClick
{
    [self.delegate cancelActiveButtonClickedWithOrderDetailToolBarView:self];
}

- (void)delOrderButtonClick
{
    [self.delegate delOrderButtonClickedWithOrderDetailToolBarView:self];
}
@end
