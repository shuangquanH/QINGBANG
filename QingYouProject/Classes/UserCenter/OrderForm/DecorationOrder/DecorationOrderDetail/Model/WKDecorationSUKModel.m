//
//  WKDecorationSUKModel.m
//  QingYouProject
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationSUKModel.h"

@implementation WKDecorationPropertyModel

@end

@implementation WKDecorationSUKModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

- (NSAttributedString *)skuProductDescAttributeString {
    if (!_skuProductDescAttributeString) {
        NSMutableAttributedString *tmpStr;
        if (!self.skuAttrList.count) {
            tmpStr = [[NSMutableAttributedString alloc] initWithString:@"暂无商品描述信息"];
        }
        else {
            tmpStr = [[NSMutableAttributedString alloc] init];
            for (int i = 0; i < self.skuAttrList.count; i++) {
                WKDecorationPropertyModel *m = self.skuAttrList[i];
                NSString *propertyStr = [NSString stringWithFormat:@"%@: %@", m.propertyName, m.propertyValue];
                [tmpStr appendAttributedString:[[NSAttributedString alloc] initWithString:propertyStr]];
                if (i % 2 == 0) {//空格
                    [tmpStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
                }
                if (i % 2 == 1 && (i != self.skuAttrList.count-1)) {//每两个属性进行换行
                    [tmpStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                }
            }
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        [tmpStr setAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, tmpStr.length)];
        
        _skuProductDescAttributeString = [[NSAttributedString alloc] initWithAttributedString:tmpStr];
    }
    return _skuProductDescAttributeString;
}

- (NSAttributedString *)skuProductNameAttributeString {
    if (!_skuProductNameAttributeString) {
        if (!self.skuDesc.length) {
            _skuProductNameAttributeString = [[NSAttributedString alloc] initWithString:@""];
            return _skuProductNameAttributeString;
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        _skuProductNameAttributeString = [[NSAttributedString alloc] initWithString:self.skuDesc attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    }
    return _skuProductNameAttributeString;
}

- (NSAttributedString *)skuProductPriceAttributeString {
    if (!_skuProductPriceAttributeString) {
        if (!self.skuPrice.length) {
            _skuProductPriceAttributeString = [[NSAttributedString alloc] initWithString:@""];
            return _skuProductPriceAttributeString;
        }
        NSMutableAttributedString *estimatePrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@（预估价）", self.skuPrice]];
        [estimatePrice setAttributes:@{NSForegroundColorAttributeName: kCOLOR_PRICE_RED} range:NSMakeRange(0, 2+self.skuPrice.length)];
        _skuProductPriceAttributeString = [estimatePrice copy];
    }
    return _skuProductPriceAttributeString;
}


@end
