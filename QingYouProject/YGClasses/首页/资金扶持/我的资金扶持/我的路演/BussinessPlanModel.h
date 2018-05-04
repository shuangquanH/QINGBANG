//
//  BussinessPlanModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/15.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BussinessPlanModel : NSObject
/** 收益权 */
@property (nonatomic, copy  ) NSString *firmName;
/** 价格 */
@property (nonatomic, copy  ) NSString *name;
/** 详细 */
@property (nonatomic, copy  ) NSString *address;
/** 个人限购 */
@property (nonatomic, copy  ) NSString *contactPhone;

@property (nonatomic, copy  ) NSString *status;

@property (nonatomic, copy  ) NSString *audit;


@end
