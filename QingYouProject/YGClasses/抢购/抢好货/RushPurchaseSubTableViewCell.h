//
//  RushPurchaseSubTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/5.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RushPurchaseProductModel.h"

@protocol  RushPurchaseSubTableViewCellDelegate <NSObject>

- (void)RushPurchaseSubTableViewCellClickNoticeButtonWithModel:(RushPurchaseProductModel *)model andIndexPath:(NSIndexPath *)indexPath andNoticeButton:(UIButton *)btn;
@end
@interface RushPurchaseSubTableViewCell : UITableViewCell
@property (nonatomic, strong) RushPurchaseProductModel            *model;
@property (nonatomic, strong) NSIndexPath            *indexPath;
@property (nonatomic, assign) id<RushPurchaseSubTableViewCellDelegate>delegate;

- (void)setModel:(RushPurchaseProductModel *)model withIndexPath:(NSIndexPath *)indexPath;
@end
