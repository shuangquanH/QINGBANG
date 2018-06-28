//
//  OfficePurchaseTableViewCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"
@class OfficePurchaseDetailModel;
@interface OfficePurchaseTableViewCell : SQBaseTableViewCell
/** OfficePurchaseModel  */
@property (nonatomic,strong) OfficePurchaseDetailModel * model;
- (void)signUpSetModel:(OfficePurchaseDetailModel *)model;

@end
