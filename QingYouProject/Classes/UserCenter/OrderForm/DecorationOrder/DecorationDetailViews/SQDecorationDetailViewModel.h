//
//  SQDecorationDetailViewModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单详情视图管理类

#import <Foundation/Foundation.h>
#import "SQDecorationDetailModel.h"

@class SQDecorationDetailViewModel, SQDecorationDetailFunctionView, SQDecorationDetailServerView;

@protocol SQDecorationDetailViewProtocol<NSObject>

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo;

- (CGSize)viewSize;

@end

@protocol SQDecorationDetailViewModelDelegate<NSObject>

@optional
/** 0：联系客服 1：申请售后 */
- (void)serviceView:(SQDecorationDetailServerView *)serviceView didClickServiceType:(NSInteger)serviceType;
/** 0：下载报价单 1：查看合同 2：开票申请 */
- (void)functionView:(SQDecorationDetailFunctionView *)functionView didClickFunctionType:(NSInteger)functionType;

@end

@interface SQDecorationDetailViewModel : NSObject


@property (nonatomic, strong, readonly) NSArray<UIView<SQDecorationDetailViewProtocol> *> *subviewArray;

@property (nonatomic, weak) id<SQDecorationDetailViewModelDelegate> orderDetailDelegate;

- (void)setupByOrderInfo:(SQDecorationDetailModel *)orderInfo;


@end
