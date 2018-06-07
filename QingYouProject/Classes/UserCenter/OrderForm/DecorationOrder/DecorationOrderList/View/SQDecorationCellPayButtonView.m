//
//  SQDecorationCellPayButtonView.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/17.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationCellPayButtonView.h"

const CGFloat kFunctionButtonWidth = 150.0;
const CGFloat kFunctionButtonLeftMargin = 20.0;
const CGFloat kFunctionButtonTopMargin = 0.0;

@implementation SQDecorationCellPayButtonView
{
    NSMutableArray<UIButton *> *_buttons;
    UILabel *_alreadyPayLabel;
    NSInteger _stage;
}

- (void)configStageModel:(WKDecorationStageModel *)stageModel withStage:(NSInteger)stage canRefund:(BOOL)canRefund inRefund:(BOOL)inRefund inDetail:(BOOL)inDetail {
    
    if (stage < 0) {
        NSLog(@"%@ %ld 阶段不符合规则", NSStringFromClass([self class]), stage);
        return;
    }
    
    _stage = stage;
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    
    if (stageModel.stageState == 1) {//待付款
        if (stage == 0) {//订金
          [self reSetFunctionButtonsWithTitles:@[@"付款", @"取消订单"] types:@[@(WKDecorationOrderActionTypePay), @(WKDecorationOrderActionTypeCancel)]];
        }
        else {
          [self reSetFunctionButtonsWithTitles:@[@"补登", @"付款"] types:@[@(WKDecorationOrderActionTypeRepair), @(WKDecorationOrderActionTypePay)]];
        }
    }
    else if (stageModel.stageState == 2) {//已支付
        [self showAlreadyPayLabelWithTitle:@"已支付"];
        if (stage == 0 && inDetail) {//订金阶段且在详情中
            if (canRefund) {//可退款
                UIButton *btn;
                if (_buttons.count) {
                    btn = _buttons.firstObject;
                    [btn setTitle:@"退款" forState:UIControlStateNormal];
                    [btn setTitleColor:[self colorWithActionType:WKDecorationOrderActionTypeRefund] forState:UIControlStateNormal];
                    btn.layer.borderColor = [self colorWithActionType:WKDecorationOrderActionTypeRefund].CGColor;
                    btn.hidden = NO;
                }
                else {
                    btn = [self setupButtonWithTitle:@"退款" actionType:WKDecorationOrderActionTypeRefund];
                    [btn addTarget:self action:@selector(click_typeButton:) forControlEvents:UIControlEventTouchUpInside];
                    [_buttons addObject:btn];
                    [self addSubview:btn];
                }
                btn.tag = WKDecorationOrderActionTypeRefund;
                [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(KSCAL(kFunctionButtonTopMargin));
                    make.width.mas_equalTo(KSCAL(kFunctionButtonWidth));
                }];
                return;
            }
            
            if (inRefund) {//退款中
                UIButton *btn;
                if (_buttons.count) {
                    btn = _buttons.firstObject;
                    [btn setTitle:@"退款详情" forState:UIControlStateNormal];
                    [btn setTitleColor:[self colorWithActionType:WKDecorationOrderActionTypeRefundDetail] forState:UIControlStateNormal];
                    btn.layer.borderColor = [self colorWithActionType:WKDecorationOrderActionTypeRefundDetail].CGColor;
                    btn.hidden = NO;
                }
                else {
                    btn = [self setupButtonWithTitle:@"退款详情" actionType:WKDecorationOrderActionTypeRefundDetail];
                    [btn addTarget:self action:@selector(click_typeButton:) forControlEvents:UIControlEventTouchUpInside];
                    [_buttons addObject:btn];
                    [self addSubview:btn];
                }
                btn.tag = WKDecorationOrderActionTypeRefundDetail;
                [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(KSCAL(kFunctionButtonTopMargin));
                    make.width.mas_equalTo(KSCAL(kFunctionButtonWidth));
                }];
                return;
            }
        }
    }
    else if (stageModel.stageState == 3) {//补登审核中
        [self showAlreadyPayLabelWithTitle:@"补登审核中"];
    }
    else if (stageModel.stageState == 4) {//已关闭
        [self reSetFunctionButtonsWithTitles:@[@"删除订单"] types:@[@(WKDecorationOrderActionTypeDelete)]];
    }
    else {//无其他阶段
        [_buttons makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
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
            btn = [self setupButtonWithTitle:titles[i] actionType:[types[i] integerValue]];
            [btn addTarget:self action:@selector(click_typeButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            [_buttons addObject:btn];
        }

        btn.tag = [types objectAtIndex:i].integerValue;
        
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(- i * (KSCAL(kFunctionButtonWidth) + KSCAL(kFunctionButtonLeftMargin)));
            make.top.mas_equalTo(KSCAL(kFunctionButtonTopMargin));
            make.width.mas_equalTo(KSCAL(kFunctionButtonWidth));
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
    
    [_buttons makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
    [self layoutIfNeeded];
}


//生成标准按钮
- (UIButton *)setupButtonWithTitle:(NSString *)title actionType:(WKDecorationOrderActionType)actionType {
    UIColor *titleColor = [self colorWithActionType:actionType];
    UIButton *btn = [UIButton buttonWithTitle:title titleFont:KSCAL(24) titleColor:titleColor];
    btn.layer.cornerRadius = KSCAL(22.5);
    btn.layer.borderColor = titleColor.CGColor;
    btn.layer.borderWidth = 1.0;
    return btn;
}

- (UIColor *)colorWithActionType:(WKDecorationOrderActionType)actionType {
    switch (actionType) {
        case WKDecorationOrderActionTypeCancel:
            return KCOLOR_MAIN;
        default:
            return KCOLOR(@"666666");
    }
}

- (void)click_typeButton:(UIButton *)sender {
    if ([self.actionDelegate respondsToSelector:@selector(actionView:didClickActionType:forStage:)]) {
        [self.actionDelegate actionView:self didClickActionType:sender.tag forStage:_stage];
    }
}

@end
