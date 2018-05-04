//
//  DesignEffectCell.h
//  QingYouProject
//
//  Created by zhaoao on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignEffectModel.h"

@interface DesignEffectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designerLabel;

@property(nonatomic,strong)DesignEffectModel *model;

@end
