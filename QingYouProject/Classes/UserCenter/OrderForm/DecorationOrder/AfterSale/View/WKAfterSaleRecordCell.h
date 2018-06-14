//
//  WKAfterSaleRecordCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKAfterSaleModel.h"

@interface WKAfterSaleRecordCell : UITableViewCell

- (void)configInfo:(WKAfterSaleModel *)info;

+ (CGFloat)cellHeightWithSaleInfo:(WKAfterSaleModel *)saleInfo;

@end
