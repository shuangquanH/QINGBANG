//
//  SQDecorationOrderDetailVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationOrderDetailVC.h"
#import "SQTicketApplyViewController.h"
#import "SQApplyAfterSaleViewController.h"

#import "SQDecorationDetailViewModel.h"

@interface SQDecorationOrderDetailVC () <UIScrollViewDelegate, SQDecorationDetailViewModelDelegate>

@property (nonatomic, strong) UIScrollView  *contentScrollView;
@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, assign) CGFloat       lastcontentOffset;

@property (nonatomic, strong) SQDecorationDetailViewModel *orderDetailVM;
@end

@implementation SQDecorationOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"订单详情";
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.contentView];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
    }];
    
    [self sqaddSubVies];
    
}
- (void)sqaddSubVies {
    
    SQDecorationDetailModel *model = [SQDecorationDetailModel new];
    model.orderState = 5;
    
    self.orderDetailVM = [SQDecorationDetailViewModel new];
    self.orderDetailVM.orderDetailDelegate = self;
    [self.orderDetailVM setupByOrderInfo:model];
    
    for (UIView<SQDecorationDetailViewProtocol> *v in self.orderDetailVM.subviewArray) {
        [v configOrderInfo:model];
        [self.contentView addSubview:v];
    }
    
    [self makeConstraints];
}

- (void)makeConstraints {
    
    UIView *lastView;
    for (int i = 0; i < self.orderDetailVM.subviewArray.count; i++) {
        UIView<SQDecorationDetailViewProtocol> *v = [self.orderDetailVM.subviewArray objectAtIndex:i];
        if (i == 0) {
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.mas_equalTo(0);
                make.size.mas_equalTo([v viewSize]);
            }];
        }
        else {
            
            if (i == self.orderDetailVM.subviewArray.count - 1) {
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(0);
                    make.top.equalTo(lastView.mas_bottom);
                    make.height.mas_equalTo([v viewSize].height);
                }];
            }
            else {
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.equalTo(lastView.mas_bottom);
                    make.height.mas_equalTo([v viewSize].height);
                }];
            }
        }
        
        lastView = v;
    }
}


#pragma mark - SQDecorationDetailViewModelDelegate
- (void)serviceView:(SQDecorationDetailServerView *)serviceView didClickServiceType:(NSInteger)serviceType {
    /** 0：联系客服 1：申请售后 */
    if (serviceType == 0) {
        NSString *url = @"tel:057812345";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else {
        SQApplyAfterSaleViewController *next = [SQApplyAfterSaleViewController new];
        [self.navigationController pushViewController:next animated:YES];
    }
}
- (void)functionView:(SQDecorationDetailFunctionView *)functionView didClickFunctionType:(NSInteger)functionType {
    /** 0：下载报价单 1：查看合同 2：开票申请 */
    if (functionType == 0) {
        
    }
    else if (functionType == 1) {
        
    }
    else {
        SQTicketApplyViewController *next = [SQTicketApplyViewController new];
        [self.navigationController pushViewController:next animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat hight = scrollView.frame.size.height;
//    CGFloat contentOffset = scrollView.contentOffset.y;
//    CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
//    CGFloat offset = contentOffset - self.lastcontentOffset;
//    self.lastcontentOffset = contentOffset;
//    
//    if (offset > 0 && contentOffset > 0) {
//        [UIView animateWithDuration:0.3 animations:^{//上拉
//           self.contentScrollView.contentOffset=CGPointMake(0, YGScreenHeight-KNAV_HEIGHT);
//        }];
//    }
//    if (offset < 0 && distanceFromBottom > hight) {
//        [UIView animateWithDuration:0.3 animations:^{//下拉
//            self.contentScrollView.contentOffset=CGPointZero;
//        }];
//    }
//    if (contentOffset == 0) {//滑动到顶部
//    }
//    if (distanceFromBottom < hight) {//滑动到底部
//    }
}



#pragma mark LazyLoad
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        CGRect frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-KNAV_HEIGHT);
        _contentScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        CGRect frame = CGRectMake(0, 0, YGScreenWidth, (YGScreenHeight-KNAV_HEIGHT)*2);
        _contentView = [[UIView alloc] initWithFrame:frame];
    }
    return _contentView;
}



@end
