//
//  ChooseJobPositionViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "AdvertisesForInfoModel.h"

@protocol ChooseJobPositionViewControllerDelegate <NSObject>

- (void)takePositionModel:(AdvertisesForInfoModel *)model;

@end

@interface ChooseJobPositionViewController : RootViewController
@property (nonatomic, assign) id<ChooseJobPositionViewControllerDelegate>delegate;
@property (nonatomic, strong) AdvertisesForInfoModel            *model;
@property (nonatomic, copy) NSString            *pageType;

@end
