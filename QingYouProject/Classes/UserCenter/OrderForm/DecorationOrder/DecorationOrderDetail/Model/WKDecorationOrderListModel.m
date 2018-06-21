//
//  SQDecorationDetailModel.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationOrderListModel.h"

@implementation WKDecorationStageModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end

@implementation WKDecorationOrderListModel

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

- (WKDecorationStageModel *)activityStageInfo {
    if (!_activityStageInfo) {
        for (NSInteger i = self.paymentList.count - 1; i >= 0; i--) {
            WKDecorationStageModel *stageInfo = self.paymentList[i];
            if (stageInfo.status > 0) {
                _activityStageInfo = stageInfo;
                break;
            }
        }
    }
    return _activityStageInfo;
}

- (NSAttributedString *)skuProductNameAttributeString {
    if (!_skuProductNameAttributeString) {
        if (!self.productName.length) {
            _skuProductNameAttributeString = [[NSAttributedString alloc] initWithString:@"暂无商品名称"];
            return _skuProductNameAttributeString;
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        _skuProductNameAttributeString = [[NSAttributedString alloc] initWithString:self.productName attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    }
    return _skuProductNameAttributeString;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"paymentList": [WKDecorationStageModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

@end

