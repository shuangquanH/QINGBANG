//
//  SQDecorationDetailServerView.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单详情客服视图（联系客服、申请售后）

#import <UIKit/UIKit.h>
#import "SQDecorationDetailViewModel.h"

@interface SQDecorationDetailServerView : UIView<SQDecorationDetailViewProtocol>

@property (nonatomic, copy) void (^ serviceBlock)(NSInteger tag);

@end
