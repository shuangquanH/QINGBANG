//
//  WKDecorationRefundModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKDecorationRefundModel : NSObject

@property (nonatomic, copy  ) NSString *ID;

/** 退款状态 0.审核中 5.退款成功 2.退款已撤销 6.退款申请失败 */
@property (nonatomic, assign) NSInteger status;
/** 退款金额 */
@property (nonatomic, copy  ) NSString *amount;
/** 退款理由 */
@property (nonatomic, copy  ) NSString *comment;
/** 退款失败原因 */
@property (nonatomic, copy  ) NSString *remarks;
/** 退款发起时间 */
@property (nonatomic, copy  ) NSString *createDate;
/** 退款撤销时间 */
@property (nonatomic, copy  ) NSString *updateDate;
/** 退款天数 */
@property (nonatomic, copy  ) NSString *day;
/** 退款小时数 */
@property (nonatomic, copy  ) NSString *hours;
/** 退款分钟数 */
@property (nonatomic, copy  ) NSString *minutes;

@end
