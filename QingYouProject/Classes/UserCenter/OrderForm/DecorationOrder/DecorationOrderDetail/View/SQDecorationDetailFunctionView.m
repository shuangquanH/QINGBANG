//
//  SQDecorationDetailFunctionView.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailFunctionView.h"

@implementation SQDecorationDetailFunctionView
{
    UIButton *_downContractBtn;//下载合同
    UIButton *_checkContractBtn;//查看合同
    UIButton *_ticketApplyBtn;//开票申请
    NSInteger _orderState;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        _orderState = -1;
        self.backgroundColor = kCOLOR_RGB(222, 169, 105);
    }
    return self;
}

- (void)configOrderInfo:(WKDecorationOrderDetailModel *)orderInfo {
    if (_orderState == orderInfo.status) return;
    
    _orderState = orderInfo.status;
    CGFloat itemH = KSCAL(98);
    switch (_orderState) {
        case 4:
        {//受理中、装修中
            CGFloat itemW = (kScreenW - 1.0) / 2.0;

            if (!_downContractBtn) {
                _downContractBtn = [self setupButtonWithTitle:@"下载报价单" withTag:0];
                [self addSubview:_downContractBtn];
            }
            
            if (!_checkContractBtn) {
                _checkContractBtn = [self setupButtonWithTitle:@"查看合同" withTag:1];
                [self addSubview:_checkContractBtn];
            }
            
            
            _downContractBtn.hidden = NO;
            _downContractBtn.frame = CGRectMake(0, 0, itemW, itemH);
            
            _checkContractBtn.hidden = NO;
            _checkContractBtn.frame = CGRectMake(itemW + 1.0, 0, itemW, itemH);
            
            _ticketApplyBtn.hidden = YES;
        }
            break;
        case 5:
        {//已完成
            
            CGFloat itemW = (kScreenW - 2.0) / 3.0;

            if (!_downContractBtn) {
                _downContractBtn = [self setupButtonWithTitle:@"下载报价单" withTag:0];
                [self addSubview:_downContractBtn];
            }
            
            if (!_checkContractBtn) {
                _checkContractBtn = [self setupButtonWithTitle:@"查看合同" withTag:1];
                [self addSubview:_checkContractBtn];
            }
            
            if (!_ticketApplyBtn) {
                _ticketApplyBtn = [self setupButtonWithTitle:@"开票申请" withTag:2];
                [self addSubview:_ticketApplyBtn];
            }
            
            _downContractBtn.hidden = NO;
            _downContractBtn.frame = CGRectMake(0, 0, itemW, itemH);
            
            _checkContractBtn.hidden = NO;
            _checkContractBtn.frame = CGRectMake((itemW + 1.0), 0, itemW, itemH);
            
            _ticketApplyBtn.hidden = NO;
            _ticketApplyBtn.frame = CGRectMake(2 * (itemW + 1.0), 0, itemW, itemH);
        }
            break;
        default:
            break;
    }
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, KSCAL(98.0));
}

- (UIButton *)setupButtonWithTitle:(NSString *)title withTag:(NSInteger)tag {
    UIButton *btn = [UIButton new];
    btn.backgroundColor = KCOLOR_MAIN;
    btn.titleLabel.font = KFONT(28);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:kCOLOR_RGB(250, 214, 65) forState:UIControlStateHighlighted];
    [btn setTitleColor:kCOLOR_RGB(250, 214, 65) forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(click_button:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)click_button:(UIButton *)sender {
    if (self.functionBlock) {
        self.functionBlock(sender.tag);
    }
}

@end
