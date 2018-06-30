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
                NSString *propertyStr = [NSString stringWithFormat:@"%@:%@", m.propertyName, m.propertyValue];
                [tmpStr appendAttributedString:[[NSAttributedString alloc] initWithString:propertyStr]];
                if (i != self.skuAttrList.count - 1) {
                   [tmpStr appendAttributedString:[[NSAttributedString alloc] initWithString:@";"]];
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


- (void)setSkuAttrList:(NSArray<WKDecorationPropertyModel *> *)skuAttrList {
    if (!skuAttrList.count) {
        return;
    }
}


@end
