//
//  RSCorwFundingSubscribeModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSCorwFundingSubscribeModel : NSObject
/** 收益权 */
@property (nonatomic, copy  ) NSString *id;
/** 价格 */
@property (nonatomic, copy  ) NSString *amount;
/** 详细 */
@property (nonatomic, copy  ) NSString *copies;
/** 个人限购 */
@property (nonatomic, copy  ) NSString *forPurchasing;
/** 剩余 */
@property (nonatomic, copy  ) NSString *power;
/** 总共 */
@property (nonatomic, copy  ) NSString *describes;

@property (nonatomic, copy  ) NSString *leftCopies;


@end
