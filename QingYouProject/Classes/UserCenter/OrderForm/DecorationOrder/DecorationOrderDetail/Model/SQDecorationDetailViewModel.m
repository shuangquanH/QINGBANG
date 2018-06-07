//
//  SQDecorationDetailViewModel.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailViewModel.h"

#import "SQDecorationDetailStagesView.h"
#import "SQDecorationDetailAddressView.h"
#import "SQDecorationDetailFunctionView.h"
#import "SQDecorationDetailServerView.h"
#import "SQDecorationDetailOrderNumberView.h"
#import "SQDecorationOrderCell.h"
#import "SQDecorationDetailStateHeadView.h"

@interface SQDecorationDetailSectionView: UIView<SQDecorationDetailViewProtocol>
@end

@implementation SQDecorationDetailSectionView
- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {}
- (CGSize)viewSize { return CGSizeMake(kScreenW, 15); }
@end

@interface SQDecorationDetailViewModel()<decorationOrderCellDelegate>

@end

@implementation SQDecorationDetailViewModel

- (void)sendOrderDetailRequestWithOrderNum:(NSString *)orderNum completed:(void (^)(WKDecorationOrderDetailModel *, NSError *))completed {
    
    if (!orderNum.length) {
        [YGAppTool showToastWithText:@"找不到该订单信息"];
        completed(nil, nil);
        return;
    }
    [SQRequest post:KAPI_DECORATIONORDERDETAIL param:nil success:^(id response) {
        WKDecorationOrderDetailModel *order = [WKDecorationOrderDetailModel yy_modelWithJSON:response[@"data"]];
        [self setupByOrderInfo:order.order_info];
        completed(order, nil);
    } failure:^(NSError *error) {
        completed(nil, error);
    }];
  
}

- (void)setupByOrderInfo:(SQDecorationDetailModel *)orderInfo {
    if (!orderInfo) {
        return;
    }
    
    NSMutableArray<UIView<SQDecorationDetailViewProtocol> *> *tmp = [NSMutableArray array];
    
    SQDecorationDetailStateHeadView *headerView = [[SQDecorationDetailStateHeadView alloc] initWithFrame:CGRectZero];
    [tmp addObject:headerView];
    
    if (orderInfo.orderState == 4 || orderInfo.orderState == 5) {
        //订单进度
        SQDecorationDetailStagesView *stagesView = [[SQDecorationDetailStagesView alloc] initWithFrame:CGRectZero];
        [tmp addObject:stagesView];
    }
    
    //订单联系人
    SQDecorationDetailAddressView *addressView = [[SQDecorationDetailAddressView alloc] initWithFrame:CGRectZero];
    [tmp addObject:addressView];
    
    //组分割视图
    SQDecorationDetailSectionView *section_0 = [SQDecorationDetailSectionView new];
    [tmp addObject:section_0];
    
    //订单详情
    if (orderInfo.orderState == 3) {//受理中订单
        _orderCell = [[WKDecorationDealingOrderCell alloc] init];
    }
    else {
        _orderCell = [[WKDecorationOrderMutableStageCell alloc] init];
    }
    _orderCell.isInOrderDetail = YES;
    _orderCell.delegate = self;
    _orderCell.backgroundColor = [UIColor whiteColor];
    [tmp addObject:_orderCell];
 
    //订单动作
    if (orderInfo.orderState == 4 || orderInfo.orderState == 5) {//装修中，已完成
        //组分割视图
        SQDecorationDetailSectionView *section_1 = [SQDecorationDetailSectionView new];
        [tmp addObject:section_1];
        
        SQDecorationDetailFunctionView *functionView = [SQDecorationDetailFunctionView new];
        [tmp addObject:functionView];
        
        @weakify(self)
        @weakify(functionView)
        functionView.functionBlock = ^(NSInteger tag) {
            @strongify(self)
            @strongify(functionView)
            [self.orderDetailDelegate functionView:functionView didClickFunctionType:tag];
        };
    }

    //组分割视图
    SQDecorationDetailSectionView *section_2 = [SQDecorationDetailSectionView new];
    [tmp addObject:section_2];
    
    //联系客服
    SQDecorationDetailServerView *serverView = [[SQDecorationDetailServerView alloc] initWithFrame:CGRectZero];
    [tmp addObject:serverView];
    
    //组分割视图
    SQDecorationDetailSectionView *section_3 = [SQDecorationDetailSectionView new];
    [tmp addObject:section_3];
    
    //订单编号信息
    SQDecorationDetailOrderNumberView *numberView = [[SQDecorationDetailOrderNumberView alloc] initWithFrame:CGRectZero];
    [tmp addObject:numberView];
    
    _subviewArray = [tmp copy];
    
    @weakify(self)
    @weakify(serverView)
    serverView.serviceBlock = ^(NSInteger tag) {
        @strongify(self)
        @strongify(serverView)
        [self.orderDetailDelegate serviceView:serverView didClickServiceType:tag];
    };
    
    
}

#pragma mark - decorationOrderCellDelegate
- (void)decorationCell:(SQDecorationOrderCell *)decorationCell tapedOrderActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    if ([self.orderDetailDelegate respondsToSelector:@selector(orderCell:didClickAction:forStage:)]) {
        [self.orderDetailDelegate orderCell:decorationCell didClickAction:actionType forStage:stage];
    }
}


@end