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

- (NSAttributedString *)decorationDescAttributeString {
    if (!_decorationDescAttributeString) {
        if (!self.decorateProperty_list.count) {
            _decorationDescAttributeString = [[NSAttributedString alloc] initWithString:@""];
            return _decorationDescAttributeString;
        }
        
        NSMutableAttributedString *tmpStr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < self.decorateProperty_list.count; i++) {
            WKDecorationPropertyModel *m = self.decorateProperty_list[i];
            NSString *propertyStr = [NSString stringWithFormat:@"%@: %@", m.propertyName, m.propertyValue];
            [tmpStr appendAttributedString:[[NSAttributedString alloc] initWithString:propertyStr]];
            if (i % 2 == 0) {//空格
                [tmpStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            }
            if (i % 2 == 1 && (i != self.decorateProperty_list.count-1)) {//每两个属性进行换行
                [tmpStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
            
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        [tmpStr setAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, tmpStr.length)];
        
        _decorationDescAttributeString = [[NSAttributedString alloc] initWithAttributedString:tmpStr];
    }
    return _decorationDescAttributeString;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"stage_list": [WKDecorationStageModel class],
             @"decorateProperty_list": [WKDecorationPropertyModel class]
             };
}

@end

