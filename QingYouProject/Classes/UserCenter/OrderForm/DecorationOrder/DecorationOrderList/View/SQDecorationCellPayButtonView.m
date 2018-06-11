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
    UILabel *_stateLabel;
    NSInteger _stage;
}

- (instancetype)init {
    if (self == [super init]) {
        _stage = -1;
    }
    return self;
}

- (void)configStageModel:(WKDecorationStageModel *)stageModel withStage:(NSInteger)stage inDetail:(BOOL)inDetail {
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
            if (inDetail) {
                [self reSetFunctionButtonsWithTitles:@[@"付款"] types:@[@(WKDecorationOrderActionTypePay)]];
            }
            else {
                [self reSetFunctionButtonsWithTitles:@[@"付款", @"取消订单"] types:@[@(WKDecorationOrderActionTypePay), @(WKDecorationOrderActionTypeCancel)]];
            }
        }
        else {
            if (inDetail) {
                [self reSetFunctionButtonsWithTitles:@[@"付款"] types:@[@(WKDecorationOrderActionTypePay)]];
            }
            else {
                [self reSetFunctionButtonsWithTitles:@[@"补登", @"付款"] types:@[@(WKDecorationOrderActionTypeRepair), @(WKDecorationOrderActionTypePay)]];
            }
        }
    }
    else if (stageModel.stageState == 2) {//已支付
        [self reSetFunctionButtonsWithTitles:@[@"已支付"] types:@[@(WKDecorationOrderActionTypeAlreadyPay)]];
    }
    else if (stageModel.stageState == 3) {//补登审核中
        [self showLabelWithTitle:@"补登审核中"];
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
    
    _stateLabel.hidden = YES;
    
    while (_buttons.count > titles.count) {
        UIButton *btn = [_buttons lastObject];
        [btn removeFromSuperview];
        [_buttons removeLastObject];
    }
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn;
        if (_buttons.count > i) {
            btn = [_buttons objectAtIndex:i];
            btn.hidden = NO;
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

- (void)showLabelWithTitle:(NSString *)title {
    
    [_buttons makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
    
    if (!_stateLabel) {
        _stateLabel = [UILabel labelWithFont:KSCAL(28) textColor:KCOLOR_MAIN];
        [self addSubview:_stateLabel];
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.mas_equalTo(0);
        }];
    }
    
    _stateLabel.hidden = NO;
    _stateLabel.text = title;
}

//生成标准按钮
- (UIButton *)setupButtonWithTitle:(NSString *)title actionType:(WKDecorationOrderActionType)actionType {
    UIColor *titleColor = [self colorWithActionType:actionType];
    UIButton *btn = [UIButton buttonWithTitle:title titleFont:KSCAL(24) titleColor:titleColor];
    btn.layer.cornerRadius = KSCAL(22.5);
    btn.layer.borderColor = titleColor.CGColor;
    btn.layer.borderWidth = 1.0;
    btn.backgroundColor = [UIColor colorWithRed:241.0/255 green:242.0/255 blue:243.0/255 alpha:1.0];
    return btn;
}

- (UIColor *)colorWithActionType:(WKDecorationOrderActionType)actionType {
    switch (actionType) {
        case WKDecorationOrderActionTypeCancel:
        case WKDecorationOrderActionTypeRepair:
            return KCOLOR_MAIN;
        default:
            return kCOLOR_666;
    }
}

- (void)click_typeButton:(UIButton *)sender {
    if ([self.actionDelegate respondsToSelector:@selector(actionView:didClickActionType:forStage:)]) {
        [self.actionDelegate actionView:self didClickActionType:sender.tag forStage:_stage];
    }
}

@end
