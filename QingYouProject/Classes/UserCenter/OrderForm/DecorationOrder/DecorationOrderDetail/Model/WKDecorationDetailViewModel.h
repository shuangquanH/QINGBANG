//
//  SQDecorationDetailViewModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  订单详情视图管理类

#import <Foundation/Foundation.h>
#import "WKDecorationOrderDetailModel.h"
#import "ManageMailPostModel.h"
#import "SQDecorationCellPayButtonView.h"

@class WKDecorationDetailViewModel, SQDecorationDetailFunctionView, SQDecorationDetailServerView, SQDecorationOrderCell, WKDecorationAddressModel;

@protocol WKDecorationDetailViewProtocol<NSObject>

- (void)configOrderInfo:(WKDecorationOrderDetailModel *)orderInfo;

- (CGSize)viewSize;

@optional
- (void)configAddressInfo:(WKDecorationAddressModel *)addressInfo;

@end

@protocol WKDecorationDetailViewModelDelegate<NSObject>

@optional
/** 0：联系客服 1：申请售后 */
- (void)serviceView:(SQDecorationDetailServerView *)serviceView didClickServiceType:(NSInteger)serviceType;
/** 0：下载报价单 1：查看合同 2：开票申请 */
- (void)functionView:(SQDecorationDetailFunctionView *)functionView didClickFunctionType:(NSInteger)functionType;
/** 点击了按钮动作 */
- (void)orderCell:(SQDecorationOrderCell *)orderCell didClickAction:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage;

@end

@interface WKDecorationDetailViewModel : NSObject


@property (nonatomic, strong, readonly) NSArray<UIView<WKDecorationDetailViewProtocol> *> *subviewArray;

@property (nonatomic, strong, readonly) SQDecorationOrderCell *orderCell;

@property (nonatomic, weak) id<WKDecorationDetailViewModelDelegate> orderDetailDelegate;

- (void)setupByOrderInfo:(WKDecorationOrderDetailModel *)orderInfo;

- (void)sendOrderDetailRequestWithOrderNum:(NSString *)orderNum completed:(void(^)(WKDecorationOrderDetailModel *order, NSError *error))completed;

@end
