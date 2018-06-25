//
//  SQDecorationDetailViewModel.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationDetailViewModel.h"

#import "SQDecorationDetailStagesView.h"
#import "SQDecorationDetailAddressView.h"
#import "SQDecorationDetailFunctionView.h"
#import "SQDecorationDetailServerView.h"
#import "SQDecorationDetailOrderNumberView.h"
#import "WKDecorationOrderBaseCell.h"
#import "SQDecorationDetailStateHeadView.h"
#import "WKDecorationStateCell.h"

@interface WKDecorationDetailSectionView: UIView<WKDecorationDetailViewProtocol>
@end
@implementation WKDecorationDetailSectionView
- (void)configOrderDetailInfo:(WKDecorationOrderDetailModel *)orderDetailInfo {}
- (CGSize)viewSize { return CGSizeMake(kScreenW, KSCAL(20)); }
@end

@interface WKDecorationDetailViewModel()<decorationOrderCellDelegate>

@end

@implementation WKDecorationDetailViewModel

- (void)sendOrderDetailRequestWithOrderNum:(NSString *)orderNum completed:(void (^)(WKDecorationOrderDetailModel *, NSError *))completed {
    
    if (!orderNum.length) {
        [YGAppTool showToastWithText:@"找不到该订单信息"];
        completed(nil, nil);
        return;
    }
    
    [SQRequest post:KAPI_DECORATIONORDERDETAIL param:@{@"orderNum": orderNum} success:^(id response) {
        if ([response[@"code"] longLongValue] == 0) {
           WKDecorationOrderDetailModel *order = [WKDecorationOrderDetailModel yy_modelWithJSON:response[@"data"]];
            [self setupByOrderInfo:order];
            completed(order, nil);
        }
        else {
            completed(nil, [NSError errorWithDomain:response[@"msg"] code:-999 userInfo:nil]);
        }
        NSLog(@"订单详情：%@", response);
    } failure:^(NSError *error) {
        NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
        NSHTTPURLResponse *reponse = underlyingError.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        if (reponse && reponse.statusCode >= 500) {
            completed(nil, [NSError errorWithDomain:@"服务器错误，请稍后重试" code:reponse.statusCode userInfo:nil]);
        }
        else {
            completed(nil, [NSError errorWithDomain:@"网络错误，请稍后重试" code:reponse.statusCode userInfo:nil]);
        }
    }];
  
}

- (void)setupByOrderInfo:(WKDecorationOrderDetailModel *)orderInfo {
    if (!orderInfo) {
        return;
    }
    
    //已经初始化过子视图，查看是否更新订单信息视图
    if (_subviewArray.count) {
        if (orderInfo.orderInfo.status == 3) {//受理中订单
            if (![_orderCell isKindOfClass:[WKDecorationDealingOrderCell class]]) {//更新视图
                WKDecorationDealingOrderCell *cell = [[WKDecorationDealingOrderCell alloc] init];
                NSMutableArray *tmpArr = [_subviewArray mutableCopy];
                NSInteger index = [_subviewArray indexOfObject:_orderCell];
                [tmpArr replaceObjectAtIndex:index withObject:cell];
                [_orderCell removeFromSuperview];
                _orderCell = cell;
            }
        }
        else {
            if (![_orderCell isKindOfClass:[WKDecorationOrderMutableStageCell class]]) {//更新视图
                WKDecorationOrderMutableStageCell *cell = [[WKDecorationOrderMutableStageCell alloc] init];
                NSMutableArray *tmpArr = [_subviewArray mutableCopy];
                NSInteger index = [_subviewArray indexOfObject:_orderCell];
                [tmpArr replaceObjectAtIndex:index withObject:cell];
                [_orderCell removeFromSuperview];
                _orderCell = cell;
            }
        }
        return;
    }
    
    NSMutableArray<UIView<WKDecorationDetailViewProtocol> *> *tmp = [NSMutableArray array];
    
    SQDecorationDetailStateHeadView *stageView = [[SQDecorationDetailStateHeadView alloc] initWithFrame:CGRectZero];
    [tmp addObject:stageView];
    
    if (orderInfo.orderInfo.status == 4 || orderInfo.orderInfo.status == 5 || orderInfo.orderInfo.status == 3) {
        //订单进度
        SQDecorationDetailStagesView *stagesView = [[SQDecorationDetailStagesView alloc] initWithFrame:CGRectZero];
        [tmp addObject:stagesView];
    }
    
    //订单联系人
    SQDecorationDetailAddressView *addressView = [[SQDecorationDetailAddressView alloc] initWithFrame:CGRectZero];
    [tmp addObject:addressView];
    
    //订单状态
    WKDecorationStateCell *stateCell = [[WKDecorationStateCell alloc] init];
    stateCell.isInDetail = YES;
    [tmp addObject:stateCell];
    
    //订单详情
    if (orderInfo.orderInfo.status == 3) {//受理中订单
        _orderCell = [[WKDecorationDealingOrderCell alloc] init];
    }
    else if (orderInfo.orderInfo.status == 1 || orderInfo.orderInfo.status == 2) {//待付款、已关闭
        _orderCell = [[WKDecorationOrderBaseCell alloc] init];
    }
    else {
        _orderCell = [[WKDecorationOrderMutableStageCell alloc] init];
    }
    _orderCell.isInOrderDetail = YES;
    _orderCell.delegate = self;
    _orderCell.backgroundColor = [UIColor whiteColor];
    [tmp addObject:_orderCell];
 
    //订单动作
    if (orderInfo.orderInfo.status == 4 || orderInfo.orderInfo.status == 5) {//装修中，已完成
        //组分割视图
        WKDecorationDetailSectionView *section_1 = [WKDecorationDetailSectionView new];
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

    if (orderInfo.orderInfo.status != 3) {
        //组分割视图
        WKDecorationDetailSectionView *section_2 = [WKDecorationDetailSectionView new];
        [tmp addObject:section_2];
        
        //联系客服
        SQDecorationDetailServerView *serverView = [[SQDecorationDetailServerView alloc] initWithFrame:CGRectZero];
        [tmp addObject:serverView];
        
        @weakify(self)
        @weakify(serverView)
        serverView.serviceBlock = ^(NSInteger tag) {
            @strongify(self)
            @strongify(serverView)
            [self.orderDetailDelegate serviceView:serverView didClickServiceType:tag];
        };
    }
  
    //组分割视图
    WKDecorationDetailSectionView *section_3 = [WKDecorationDetailSectionView new];
    [tmp addObject:section_3];
    
    //订单编号信息
    SQDecorationDetailOrderNumberView *numberView = [[SQDecorationDetailOrderNumberView alloc] initWithFrame:CGRectZero];
    [tmp addObject:numberView];
    
    _subviewArray = [tmp copy];

}

#pragma mark - decorationOrderCellDelegate
- (void)decorationCell:(WKDecorationOrderBaseCell *)decorationCell tapedOrderActionType:(WKDecorationOrderActionType)actionType forStage:(NSInteger)stage {
    if ([self.orderDetailDelegate respondsToSelector:@selector(orderCell:didClickAction:forStage:)]) {
        [self.orderDetailDelegate orderCell:decorationCell
                             didClickAction:actionType
                                   forStage:stage];
    }
}


@end
