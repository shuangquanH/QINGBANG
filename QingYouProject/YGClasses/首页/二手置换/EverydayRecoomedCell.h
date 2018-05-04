//
//  EverydayRecoomedCell.h
//  QingYouProject
//
//  Created by zhaoao on 2017/12/11.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondMainRecommendModel.h"

@interface EverydayRecoomedCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@property(nonatomic,strong)SecondMainRecommendModel *model;

@end
