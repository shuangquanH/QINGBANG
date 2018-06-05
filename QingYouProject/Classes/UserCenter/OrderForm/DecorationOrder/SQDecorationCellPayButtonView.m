//
//  SQDecorationCellPayButtonView.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationCellPayButtonView.h"

const CGFloat kFunctionButtonWidth = 60.0;
const CGFloat kFunctionButtonLeftMargin = 10.0;
const CGFloat kFunctionButtonTopMargin = 0.0;

@implementation SQDecorationCellPayButtonView
{
    NSMutableArray<UIButton *> *_buttons;
    UILabel *_alreadyPayLabel;
    NSInteger _stage;
}


- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo stage:(NSInteger)stage {
    
    if (stage < 0 || stage > 3) {
        NSLog(@"%@ %ld 阶段不符合规则", NSStringFromClass([self class]), stage);
        return;
    }
    
    _stage = stage;
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    
    if (orderInfo.orderState == 4) {//装修中，待付款
        if (stage == 0) {//定金
            [self showAlreadyPayLabelWithTitle:@"已支付"];
        }
        else if (stage == 1) {//阶段1
            [self reSetStageByStageState:orderInfo.stageOneState];
        }
        else if (stage == 2) {//阶段2
            [self reSetStageByStageState:orderInfo.stageTwoState];
        }
        else {//阶段3
            [self reSetStageByStageState:orderInfo.stageThreeState];
        }
    }
    else if (orderInfo.orderState == 5) {//已完成
        [self showAlreadyPayLabelWithTitle:@"已支付"];
    }
    else {
        if (stage == 0) {//定金(状态：1.已支付(一个描述标签)， 2.待付款(取消订单、付款)，3.已关闭(删除))
            if (orderInfo.orderState == 1) {//待付款
                [self reSetFunctionButtonsWithTitles:@[@"付款", @"取消订单"] types:@[@(WKDecorationOrderActionTypePay), @(WKDecorationOrderActionTypeCancel)]];
            }
            else if (orderInfo.orderState == 2) {//已关闭
                [self reSetFunctionButtonsWithTitles:@[@"删除订单"] types:@[@(WKDecorationOrderActionTypeDelete)]];
            }
            else {//受理中
                [self showAlreadyPayLabelWithTitle:@"已支付"];
                if (self.isInDetail) {//在详情中，未申请退款则显示申请退款按钮，否则显示查看退款详情
                    if (orderInfo.canRefund) {//可以申请退款
                        UIButton *btn = [self setupButtonWithTitle:@"申请退款"];
                        btn.tag = WKDecorationOrderActionTypeRefund;
                        [btn addTarget:self action:@selector(click_typeButton:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:btn];
                        [_buttons addObject:btn];
                        
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.centerY.mas_equalTo(0);
                            make.width.mas_equalTo(kFunctionButtonWidth);
                            make.top.mas_equalTo(kFunctionButtonTopMargin);
                        }];
                    }
                    else if (orderInfo.isInRefund) {//正在申请退款
                        UIButton *btn = [self setupButtonWithTitle:@"查看退款详情"];
                        btn.tag = WKDecorationOrderActionTypeRefundDetail;
                        [btn addTarget:self action:@selector(click_typeButton:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:btn];
                        [_buttons addObject:btn];
                        
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.centerY.mas_equalTo(0);
                            make.width.mas_equalTo(kFunctionButtonWidth);
                            make.top.mas_equalTo(kFunctionButtonTopMargin);
                        }];
                    }
                    
                }
            }
        
        }
        else {//订单状态1\2\3，无其他阶段
            [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
            [_buttons removeAllObjects];
        }
    }
}

//重新调整按钮
- (void)reSetFunctionButtonsWithTitles:(NSArray<NSString *> *)titles types:(NSArray<NSNumber *> *)types {
    
    _alreadyPayLabel.hidden = YES;
    
    while (_buttons.count > titles.count) {
        UIButton *btn = [_buttons lastObject];
        [btn removeFromSuperview];
        [_buttons removeLastObject];
    }
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn;
        if (_buttons.count > i) {
            btn = [_buttons objectAtIndex:i];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
        }
        else {
            btn = [self setupButtonWithTitle:titles[i]];
            [btn addTarget:self action:@selector(click_typeButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            [_buttons addObject:btn];
        }

        btn.tag = [types objectAtIndex:i].integerValue;
        
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(- i * (kFunctionButtonWidth + kFunctionButtonLeftMargin));
            make.top.mas_equalTo(kFunctionButtonTopMargin);
            make.width.mas_equalTo(kFunctionButtonWidth);
        }];
    }
    
    [self layoutIfNeeded];
}

- (void)showAlreadyPayLabelWithTitle:(NSString *)title {
    if (!_alreadyPayLabel) {
        _alreadyPayLabel = [UILabel labelWithFont:13.0 textColor:[UIColor redColor]];
        [self addSubview:_alreadyPayLabel];
        [_alreadyPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.mas_equalTo(0);
        }];
    }
    _alreadyPayLabel.text = title;
    _alreadyPayLabel.hidden = NO;
    
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [_buttons removeAllObjects];
    
    [self layoutIfNeeded];
}

- (void)reSetStageByStageState:(NSInteger)stageState {
    if (stageState == 1) {
        [self reSetFunctionButtonsWithTitles:@[@"补登", @"付款"] types:@[@(WKDecorationOrderActionTypeRepair), @(WKDecorationOrderActionTypePay)]];
    }
    else if (stageState == 2) {
        [self showAlreadyPayLabelWithTitle:@"已支付"];
    }
    else {//补登审核
        [self showAlreadyPayLabelWithTitle:@"补登审核中"];
    }
}

//生成标准按钮
- (UIButton *)setupButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3.0;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    return btn;
}

- (void)click_typeButton:(UIButton *)sender {
    if ([self.actionDelegate respondsToSelector:@selector(actionView:didClickActionType:forStage:)]) {
        [self.actionDelegate actionView:self didClickActionType:sender.tag forStage:_stage];
    }
}

@end
