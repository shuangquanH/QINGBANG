//
//  ProjectApplySuccessModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectApplySuccessModel : NSObject

@property (nonatomic, copy  ) NSString *author;

@property (nonatomic, copy  ) NSString *source;//原因

@property (nonatomic, copy  ) NSString *orderNumber;

@property (nonatomic, copy  ) NSString *fundName;

@property (nonatomic, copy  ) NSString *releaseTime;

@property (nonatomic, copy  ) NSString *enterpriseName;

@property (nonatomic, copy  ) NSString *enterpriseNature;//企业性质

/** 内容 */
@property (nonatomic, copy  ) NSString *contactPhone; //联系电话

@property (nonatomic, copy  ) NSString *contactPerson; //联系电话

@property (nonatomic, copy  ) NSString *createDate;





/** 内容 */
@property (nonatomic, copy  ) NSString *updateDate;

@property (nonatomic, copy  ) NSString *delFlag;

@property (nonatomic, copy  ) NSString *id;


/** 内容 */
@property (nonatomic, copy  ) NSString *grade;




@property (nonatomic, copy  ) NSString *auditStatus; //订单状态 1:待审核2:进行中3:已完成4:审核不通过




@property (nonatomic, copy  ) NSString *processTime;

@property (nonatomic, copy  ) NSString *completedTime;

@property (nonatomic, copy  ) NSString *cause;//原因


@end
