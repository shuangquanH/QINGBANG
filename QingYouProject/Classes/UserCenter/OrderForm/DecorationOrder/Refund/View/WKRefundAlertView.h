//
//  WKRefundAlertView.h
//  QingYouProject
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKDecorationStageModel;

@interface WKRefundAlertView : UIView

+ (WKRefundAlertView *)refundAlert;

@property (nonatomic, strong) WKDecorationStageModel *stageInfo;

@property (nonatomic, copy) void (^ refundHandler)(NSString *reason);

@end
