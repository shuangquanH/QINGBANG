//
//  WKDecorationRefundModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKDecorationRefundModel : NSObject
/** 退款状态 1.审核中 2.退款成功 3.退款已撤销 4.退款申请失败 */
@property (nonatomic, assign) NSInteger refundState;
/** 退款金额 */
@property (nonatomic, copy  ) NSString *refundPrice;
/** 退款失败原因 */
@property (nonatomic, copy  ) NSString *refundFailReason;
/** 退款发起时间 */
@property (nonatomic, copy  ) NSString *createTime;
/** 退款截止时间 */
@property (nonatomic, copy  ) NSString *limitTime;
/** 退款撤销时间 */
@property (nonatomic, copy  ) NSString *cancelTime;
@end
