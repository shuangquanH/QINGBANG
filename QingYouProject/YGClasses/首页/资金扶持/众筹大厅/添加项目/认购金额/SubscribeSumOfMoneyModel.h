//
//  SubscribeSumOfMoneyModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscribeSumOfMoneyModel : NSObject
/** 标题 */
@property (nonatomic, copy  ) NSString *amount;
/** 封面图 */
@property (nonatomic, copy  ) NSString *copies;

/** 标题 */
@property (nonatomic, copy  ) NSString *forPurchasing;
/** 封面图 */
@property (nonatomic, copy  ) NSString *describe;
@end
