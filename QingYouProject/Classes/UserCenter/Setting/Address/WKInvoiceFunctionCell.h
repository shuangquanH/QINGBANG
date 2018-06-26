//
//  WKInvoiceFunctionCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"

@class WKInvoiceFunctionCell;
@protocol WKInvoiceFunctionCellDelegate<NSObject>

- (void)functionCell:(WKInvoiceFunctionCell *)functionCell didClickType:(NSInteger)type withIndexPath:(NSIndexPath *)indexPath;

@end

@interface WKInvoiceFunctionCell : SQBaseTableViewCell

@property (nonatomic, weak) id<WKInvoiceFunctionCellDelegate> functionDelegate;

- (void)configIndexPath:(NSIndexPath *)indexPath isDefault:(BOOL)isDefault;

@end
