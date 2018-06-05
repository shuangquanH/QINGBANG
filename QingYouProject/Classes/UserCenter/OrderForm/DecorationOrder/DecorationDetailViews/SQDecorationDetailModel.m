//
//  SQDecorationDetailModel.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailModel.h"

@implementation SQDecorationDetailModel

- (instancetype)init {
    if (self == [super init]) {
        _stageOneState = 1;
        _stageTwoState = 1;
        _stageThreeState = 1;
    }
    return self;
}

- (NSString *)orderTitle {
    if (!_orderTitle) {
        switch (_orderState) {
            case 1:
                _orderTitle = @"待付款";
                break;
            case 2:
                _orderTitle = @"已关闭";
                break;
            case 3:
            {
                if (_isInRefund) {
                    _orderTitle = @"受理中（待退款）";
                }
                else {
                    _orderTitle = @"受理中";
                }
            }
                break;
            case 4:
                _orderTitle = @"装修中,待付款";
                break;
            case 5:
                _orderTitle = @"已完成";
                break;
        }
    }
    return _orderTitle;
}

@end

@implementation WKDecorationOrderDetailModel

@end

