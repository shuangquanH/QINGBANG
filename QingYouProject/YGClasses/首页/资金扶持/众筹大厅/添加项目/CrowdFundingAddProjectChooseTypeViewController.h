//
//  CrowdFundingAddProjectChooseTypeViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "CrowdFundingAddProjectChooseTypeModel.h"

@protocol CrowdFundingAddProjectChooseTypeViewControllerDelegate <NSObject>

- (void)takeTypeValueBackWithModel:(CrowdFundingAddProjectChooseTypeModel *)model;

@end
@interface CrowdFundingAddProjectChooseTypeViewController : RootViewController
@property (nonatomic, assign) id<CrowdFundingAddProjectChooseTypeViewControllerDelegate>delegate;
@property (nonatomic, copy) NSString        *pageFromController;

@end
