//
//  IssueAdvertiseViewSpreadTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisesForInfoModel.h"

@interface IssueAdvertiseViewSpreadTableViewCell : UITableViewCell
@property (nonatomic, strong) AdvertisesForInfoModel            *model;
- (void)setModel:(AdvertisesForInfoModel *)model  withIndexPath:(NSIndexPath *)indexPath;

@end
