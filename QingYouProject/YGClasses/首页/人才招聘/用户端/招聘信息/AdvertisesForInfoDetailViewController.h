//
//  AdvertisesForInfoDetailViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface AdvertisesForInfoDetailViewController : RootViewController
@property (nonatomic, copy) NSString            *pageType; //员工端只是查看信息 企业端预览完成跳转发布
@property (nonatomic, strong) NSMutableArray            *listArray;
@property (nonatomic, copy)   NSString *benefitsId;
@property (nonatomic, copy)   NSString *recruitmentItemId;
@end
