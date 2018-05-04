//
//  RoadShowHallModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoadShowHallModel : NSObject
/** 标题 */
@property (nonatomic, copy  ) NSString *createDate;
/** 描述 */
@property (nonatomic, copy  ) NSString *updateDate;
/** 视频地址 */
@property (nonatomic, copy  ) NSString *id;
/** 封面图 */
@property (nonatomic, copy  ) NSString *logo;
/** htmlstring */
@property (nonatomic, copy  ) NSString *roadshowName;

@property (nonatomic, copy  ) NSString *companyName;
//
@property (nonatomic, copy  ) NSString *industryField;
@property (nonatomic, copy  ) NSString *contactName;

/** 标题 */
@property (nonatomic, copy  ) NSString *contactPhone;
/** 描述 */
@property (nonatomic, copy  ) NSString *contactEmail;
/** 视频地址 */
@property (nonatomic, copy  ) NSString *roadshowGrade;
/** 封面图 */
@property (nonatomic, copy  ) NSString *teamIntroduction;
/** htmlstring */
@property (nonatomic, copy  ) NSString *roadshowIntroduction;

@property (nonatomic, copy  ) NSString *competitiveAdvantage;
//
@property (nonatomic, copy  ) NSString *businessPlan;
@property (nonatomic, copy  ) NSString *videoData;
@property (nonatomic, copy  ) NSString *auditStatus;

@property (nonatomic, copy  ) NSString *videoImg; //封面图

@property (nonatomic, copy  ) NSString *delFlag; //封面图

@property (nonatomic, copy  ) NSString *searchFromPage; //封面图


@end
