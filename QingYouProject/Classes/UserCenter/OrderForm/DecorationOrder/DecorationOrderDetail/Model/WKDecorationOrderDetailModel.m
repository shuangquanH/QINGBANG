//
//  SQDecorationDetailModel.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationOrderDetailModel.h"

@implementation WKDecorationOrderDetailModel

- (NSString *)orderTitle {
    if (!_orderTitle) {
        switch (_status) {
            case 1:
                _orderTitle = @"待付款";
                break;
            case 2:
                _orderTitle = @"已关闭";
                break;
            case 3:
                _orderTitle = @"受理中";
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


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"paymentList": [WKDecorationStageModel class],
             @"decorateProperty_list": [WKDecorationPropertyModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

@end

