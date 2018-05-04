//
//  AllOfficePurchaseModel.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllOfficePurchaseModel.h"

@implementation AllOfficePurchaseModel
-(void)setType:(NSString *)type{
    _type = type;
    switch ([type intValue]) {
        case 1:
        {
            _orderStatus = @"待付款";
        }
            break;
        case 2:
        {
            _orderStatus = @"待发货";
        }
            break;
        case 3:
        {
            _orderStatus = @"已发货";
        }
            break;
        case 4:
        {
            _orderStatus = @"交易成功";
        }
            break;
        case 5:
        {
            _orderStatus = @"退款中";
        }
            break;
        case 6:
        {
            _orderStatus = @"退款成功";
        }
            break;
        default:
        {
            _orderStatus = @"退款失败";

        }
            break;
    }
    
}
@end
