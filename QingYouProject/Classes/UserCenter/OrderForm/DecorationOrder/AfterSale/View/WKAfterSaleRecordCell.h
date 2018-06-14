//
//  WKAfterSaleRecordCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKAfterSaleModel.h"

@class WKAfterSaleRecordCell;

@protocol WKAfterSaleRecordCellDelegate<NSObject>

- (void)recordCell:(WKAfterSaleRecordCell *)recordCell didSelectImageIndex:(NSInteger)imageIndex withSaleInfo:(WKAfterSaleModel *)saleInfo withTargetView:(UIView *)targetView;

@end

@interface WKAfterSaleRecordCell : UITableViewCell

@property (nonatomic, weak) id<WKAfterSaleRecordCellDelegate> delegate;

- (void)configInfo:(WKAfterSaleModel *)info;

+ (CGFloat)cellHeightWithSaleInfo:(WKAfterSaleModel *)saleInfo;

@end
