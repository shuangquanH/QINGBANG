//
//  CrowdFundingAddProjectNameViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol CrowdFundingAddProjectNameViewControllerDelegate <NSObject>

- (void)takeProjectNameValueBackWithValue:(NSString *)value;

@end
@interface CrowdFundingAddProjectNameViewController : RootViewController
@property (nonatomic, assign) id<CrowdFundingAddProjectNameViewControllerDelegate>delegate;
@property (nonatomic, assign) int            companyNameOrProjectName;
@property (nonatomic, copy) NSString            *content;
@end
