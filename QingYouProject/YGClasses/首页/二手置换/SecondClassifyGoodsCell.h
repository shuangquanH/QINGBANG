//
//  SecondClassifyGoodsCell.h
//  QingYouProject
//
//  Created by zhaoao on 2017/12/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondClassfilyGoodsModel.h"

@interface SecondClassifyGoodsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property(nonatomic,strong)SecondClassfilyGoodsModel *model;

@end
