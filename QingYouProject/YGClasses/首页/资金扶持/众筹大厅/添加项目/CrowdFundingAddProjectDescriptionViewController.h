//
//  CrowdFundingAddProjectDescriptionViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

typedef enum : NSUInteger {
    iputTypeOfDescriptionType, //项目描述
    iputTypeOfInitiaterIntroduceType, //项目发起人介绍
    iputTypeOfProjectPlanType, //项目方案
    iputTypeOfProjectIntroduceType, //项目介绍
    iputTypeOfProjectCompetitiveAdvantageType, //项目成绩介绍
} iputTypeOfPage;

@protocol CrowdFundingAddProjectDescriptionViewControllerDelegate <NSObject>

//填写描述，发起人介绍，方案，项目介绍
- (void)takeProjectdesOrIntroduceValueBackWithValue:(NSString *)value withInputType:(iputTypeOfPage)inputType;

@end
@interface CrowdFundingAddProjectDescriptionViewController : RootViewController
@property (nonatomic, assign) iputTypeOfPage            iputTypeOfPage;
@property (nonatomic, assign) id<CrowdFundingAddProjectDescriptionViewControllerDelegate>delegate;
@property (nonatomic, copy) NSString            *content;
@property (nonatomic, copy) NSString            *placehoder;

@end
