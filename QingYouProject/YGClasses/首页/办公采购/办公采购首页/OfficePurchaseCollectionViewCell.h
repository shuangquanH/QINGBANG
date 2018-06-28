//
//  OfficePurchaseCollectionViewCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"
@class OfficePurchaseModel;
@interface OfficePurchaseCollectionViewCell : SQBaseTableViewCell
/** model  */
@property (nonatomic,strong) OfficePurchaseModel * model;
@end
