//
//  WKOrderRepairModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKOrderRepairModel : NSObject
/* 0表示申请提交 1表示审核失败重新提审 **/
@property (nonatomic, assign) NSInteger repairState;
@property (nonatomic, copy  ) NSString  *createDate;
@property (nonatomic, copy  ) NSString  *reason;
@end
