//
//  FindMainModel.h
//  NiXiSchool
//
//  Created by nefertari on 2017/3/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinancialAccountingModel : NSObject
/** 标题 */
@property (nonatomic, copy  ) NSString *title;
/** 描述 */
@property (nonatomic, copy  ) NSString *detail;
/** 封面图 */
@property (nonatomic, copy  ) NSString *img;

@property (nonatomic, copy  ) NSString *commerceID;

@property (nonatomic, copy  ) NSString *commerceImg;

@property (nonatomic, copy  ) NSString *commercePrice;

@property (nonatomic, copy  ) NSString *commerceName;

//
@property (nonatomic, copy  ) NSString *financeID;

@property (nonatomic, copy  ) NSString *financeImg;

@property (nonatomic, copy  ) NSString *financePrice;

@property (nonatomic, copy  ) NSString *financeName;
@end
