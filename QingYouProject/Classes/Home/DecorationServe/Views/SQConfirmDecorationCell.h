//
//  SQConfirmDecorationCell.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  确认订单cell和支付方式view

#import <UIKit/UIKit.h>
#import "SQDecorationDetailModel.h"


typedef enum : NSUInteger {
    SQPayByNull,
    SQPayByAirPay,
    SQPayByWechat,
} PayType;




/** 确认订单cell  */
@interface SQConfirmDecorationCell : UIView

@property (nonatomic, strong) SQDecorationDetailModel       *detailModel;

@property (nonatomic, copy) NSString       *leaveMessageStr;

@end


@protocol SQConfirmDecorationPayDelegate

- (void)payType:(PayType)type;

@end

/** 支付方式  */
@interface SQConfirmDecorationPayLabel : UIView

@property (nonatomic, weak) id <SQConfirmDecorationPayDelegate> delegate;

@end
