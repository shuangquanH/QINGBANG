//
//  CrowdFundingAddProjectChooseTypeModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrowdFundingAddProjectChooseTypeModel : NSObject
//路演众筹
@property (nonatomic, copy  ) NSString *createDate;
@property (nonatomic, copy  ) NSString *updateDate;
@property (nonatomic, copy  ) NSString *id;
@property (nonatomic, copy  ) NSString *typeId;
@property (nonatomic, copy  ) NSString *type;
@property (nonatomic, copy  ) NSString *rank;

@property (nonatomic, copy  ) NSString *tradeName;
@property (nonatomic, copy  ) NSString *remarks;


//项目申报
@property (nonatomic, copy  ) NSString *grade;
//抢购
@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, copy  ) NSString *roundId;

@end
