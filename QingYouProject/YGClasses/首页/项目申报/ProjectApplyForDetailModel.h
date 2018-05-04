//
//  ProjectApplyForDetailModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectApplyForDetailModel : NSObject
@property (nonatomic, copy  ) NSString *author;
/** 内容 */
@property (nonatomic, copy  ) NSString *updateDate;

@property (nonatomic, copy  ) NSString *delFlag;

@property (nonatomic, copy  ) NSString *id;


@property (nonatomic, copy  ) NSString *fundName;
/** 内容 */
@property (nonatomic, copy  ) NSString *grade;

@property (nonatomic, copy  ) NSString *createDate;

@property (nonatomic, copy  ) NSString *preferentialPolicy;
@property (nonatomic, copy  ) NSString *declareConditions;


@property (nonatomic, copy  ) NSString *projectInterpretation;


/** 内容 */
@property (nonatomic, copy  ) NSString *gradeid;

@property (nonatomic, copy  ) NSString *gradecreateDate;

@property (nonatomic, copy  ) NSString *gradedelFlag;
/** 内容 */
@property (nonatomic, copy  ) NSString *gradegrade;

@property (nonatomic, copy  ) NSString *graderank;
@property (nonatomic, copy  ) NSString *source;

@property (nonatomic, copy  ) NSString *gradeupdateDate;
@property (nonatomic, copy  ) NSString *projectAgreement;


@end
