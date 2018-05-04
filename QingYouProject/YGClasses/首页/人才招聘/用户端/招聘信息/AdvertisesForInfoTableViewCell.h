//
//  AdvertisesForInfoTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertiseModel.h"

@protocol AdvertisesForInfoTableViewCellDelegate <NSObject>

@optional
//删除
- (void)deleteAdvertiseWithModel:(AdvertiseModel *)model;
//发送简历
- (void)deliverIntroduceWithModel:(AdvertiseModel *)model;

@end
@interface AdvertisesForInfoTableViewCell : UITableViewCell
@property (nonatomic, assign) id<AdvertisesForInfoTableViewCellDelegate>delegate;
@property (nonatomic, strong) AdvertiseModel            *model;

@end
