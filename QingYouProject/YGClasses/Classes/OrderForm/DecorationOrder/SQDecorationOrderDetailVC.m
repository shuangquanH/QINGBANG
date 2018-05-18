//
//  SQDecorationOrderDetailVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationOrderDetailVC.h"
#import "SQDecorationOrderCell.h"

@interface SQDecorationOrderDetailVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView       *contentScrollView;
@property (nonatomic, strong) UIView       *contentView;
@property (nonatomic, assign) CGFloat       lastcontentOffset;


@end

@implementation SQDecorationOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"订单详情";
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.contentView];
    self.contentScrollView.contentSize = self.contentView.frame.size;
    
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentScrollView);
//        make.width.equalTo(self.contentScrollView);
//    }];
    
    [self sqaddSubVies];
    
}
- (void)sqaddSubVies {
    UIView  *headerView = [[UIView alloc] init];
    headerView.backgroundColor = colorWithMainColor;
    [self.contentView addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(120);
    }];
    
    UIView  *stagesView = [[UIView alloc] init];
    stagesView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:stagesView];
    
    [stagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(80);
    }];
    
    UIView  *addressView = [[UIView alloc] init];
    addressView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(stagesView.mas_bottom);
        make.height.mas_equalTo(120);
    }];
    
    SQDecorationOrderCellWithThreeStage   *cell = [[SQDecorationOrderCellWithThreeStage alloc] init];
    cell.model=@"dd";
    [self.contentView addSubview:cell];
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(addressView.mas_bottom);
    }];
    
    
    
    UIView  *functionView = [[UIView alloc] init];
    functionView.backgroundColor = colorWithMainColor;
    [self.contentView addSubview:functionView];
    
    [functionView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(YGScreenHeight-KNAVHEIGHT-40);
        make.height.mas_equalTo(40);
    }];
    
    UIView  *serviceView = [[UIView alloc] init];
    serviceView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:serviceView];
    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(functionView.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    
    UIView  *orderDetailView = [[UIView alloc] init];
    orderDetailView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:orderDetailView];
    [orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(serviceView.mas_bottom);
        make.height.mas_equalTo(200);
    }];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat hight = scrollView.frame.size.height;
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
    CGFloat offset = contentOffset - self.lastcontentOffset;
    self.lastcontentOffset = contentOffset;
    
    if (offset > 0 && contentOffset > 0) {
        [UIView animateWithDuration:0.3 animations:^{//上拉
           self.contentScrollView.contentOffset=CGPointMake(0, YGScreenHeight-KNAVHEIGHT);
        }];
    }
    if (offset < 0 && distanceFromBottom > hight) {
        [UIView animateWithDuration:0.3 animations:^{//下拉
            self.contentScrollView.contentOffset=CGPointZero;
        }];
    }
    if (contentOffset == 0) {//滑动到顶部
    }
    if (distanceFromBottom < hight) {//滑动到底部
    }
}



#pragma mark LazyLoad
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        CGRect frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-KNAVHEIGHT);
        _contentScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        CGRect frame = CGRectMake(0, 0, YGScreenWidth, (YGScreenHeight-KNAVHEIGHT)*2);
        _contentView = [[UIView alloc] initWithFrame:frame];
    }
    return _contentView;
}



@end
