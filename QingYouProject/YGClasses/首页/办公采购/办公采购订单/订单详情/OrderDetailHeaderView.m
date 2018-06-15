//
//  OrderDetailHeaderView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderDetailHeaderView.h"

@interface OrderDetailHeaderView ()

/** orderStatus 订单状态 */
@property (nonatomic,strong) UILabel * statusLabel;
/** orderTime  下单时间*/
@property (nonatomic,strong) UILabel * orderTimeLabel;

@end


@implementation OrderDetailHeaderView
- (void)reloadDataWithOrderStatus:(NSString *)orderStatus orderTime:(NSString *)orderTime{
    
    self.statusLabel.text = orderStatus;
    self.orderTimeLabel.text = orderTime;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    
    self.statusLabel = [UILabel ld_labelWithTextColor:LDFFTextColor textAlignment:NSTextAlignmentLeft font:LDBoldFont(15) numberOfLines:0];
    [self addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.offset(LDVPadding);
    }];
    
    self.orderTimeLabel = [UILabel ld_labelWithTextColor:LD9ATextColor textAlignment:NSTextAlignmentLeft font:LDFont(13) numberOfLines:0];
    [self addSubview:self.orderTimeLabel];
    [self.orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(LDVPadding);
    }];
    
    UIView * line = [UIView new];
    [self addSubview:line];
    line.backgroundColor = colorWithLine;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.right.offset(0);
        make.height.offset(LDVPadding);
    }];
    
    
    
    
    //假数据
//    self.statusLabel.text = @"待付款";
//    self.orderTimeLabel.text = @"创建时间: 2017-09-27 15:32";
}
@end
