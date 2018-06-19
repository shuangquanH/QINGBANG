//
//  SQDecorationDetailFunctionView.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单详情视动作视图（下载报价单、查看合同、开票申请）

#import <UIKit/UIKit.h>
#import "WKDecorationDetailViewModel.h"

@interface SQDecorationDetailFunctionView : UIView<WKDecorationDetailViewProtocol>

@property (nonatomic, copy) void (^ functionBlock)(NSInteger tag);

@end
