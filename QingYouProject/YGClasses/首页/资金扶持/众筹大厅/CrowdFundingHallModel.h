//
//  CrowdFundingHallModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrowdFundingHallModel : NSObject
/** 收益权 */
@property (nonatomic, copy  ) NSString *id;
/** 价格 */
@property (nonatomic, copy  ) NSString *projectName;
/** 详细 */
@property (nonatomic, copy  ) NSString *projectDescribe;
/** 个人限购 */
@property (nonatomic, copy  ) NSString *raiseGoal;
/** 剩余 */
@property (nonatomic, copy  ) NSString *raiseDays;
/** 总共 */
@property (nonatomic, copy  ) NSString *projectAddress;
//
/** 剩余 */
@property (nonatomic, copy  ) NSString *calm;
/** 总共 */
@property (nonatomic, copy  ) NSString *hasRaise;

/** 剩余 */
@property (nonatomic, copy  ) NSString *picture;
/** 总共 */
@property (nonatomic, copy  ) NSString *projectIntroduction;

/** 剩余 */
@property (nonatomic, copy  ) NSString *riskPrompt;
/** 总共 */
@property (nonatomic, copy  ) NSString *createDate;

/** 剩余 */
@property (nonatomic, copy  ) NSString *projectPlan;
/** 收藏*/
@property (nonatomic, copy  ) NSString *colFlag;

@property (nonatomic, copy  ) NSString *groupNum;

@property (nonatomic, copy  ) NSString *process;

@property (nonatomic, copy  ) NSString *delFlag;

@property (nonatomic, copy  ) NSString *searchFromPage;

@property (nonatomic, copy  ) NSString *projectState;

@property (nonatomic, copy  ) NSString *telephone;

@property (nonatomic, copy  ) NSString *subFlag; //判断是否已购买

@property (nonatomic, copy  ) NSString *selFlag; //"selFlag": "0", 0可以认购 1不可以认购
@property (nonatomic, copy  ) NSString *shutFlag; //"shutFlag": 作为项目是否终止标示 0未终止 1已终止
@property (nonatomic, copy  ) NSString *calmStr; //冷静期说明



/** 剩余 */
@property (nonatomic, copy  ) NSString *amount;
/** 总共 */
@property (nonatomic, copy  ) NSString *price;

/** 剩余 */
@property (nonatomic, copy  ) NSString *subscribeId;
/** 收藏*/
@property (nonatomic, copy  ) NSString *subscriptionCopies;

@property (nonatomic, copy  ) NSString *subscribeType;

//我的资金扶持我的项目状态
@property (nonatomic, copy  ) NSString *project_state;




@property (nonatomic, copy  ) NSString *investmentState; ///0 未到期未筹满 1已到期未筹满 2未到期已筹满 3未到期终止 4超过48小时无操作

@property (nonatomic, copy  ) NSString *url;

@end
