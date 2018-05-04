//
//  MineProjectApplyModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineProjectApplyModel : NSObject
/** 标题 */
@property (nonatomic, copy  ) NSString *remarks;
/** 内容 */
@property (nonatomic, copy  ) NSString *enterpriseName;

@property (nonatomic, copy  ) NSString *orderNumber;

@property (nonatomic, copy  ) NSString *processTime;

@property (nonatomic, copy  ) NSString *completedTime;

@property (nonatomic, copy  ) NSString *auditStatus;

@property (nonatomic, copy  ) NSString *id;

@end
