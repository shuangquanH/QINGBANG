//
//  AreaChooseCollectionCell.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingAreaModel.h"

@interface AreaChooseCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *areaImageView;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property(nonatomic,strong)MeetingAreaModel *model;

@end
