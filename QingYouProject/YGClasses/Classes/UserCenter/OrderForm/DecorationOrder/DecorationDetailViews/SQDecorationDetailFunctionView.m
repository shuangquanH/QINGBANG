//
//  SQDecorationDetailFunctionView.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailFunctionView.h"

const CGFloat kItemMargin = 20.0;
const CGFloat kContentLeftMargin = 40.0;

@implementation SQDecorationDetailFunctionView
{
    UIButton *_downLoadPriceFormBtn;
    UIButton *_checkContractBtn;
    UIButton *_ticketApplyBtn;
    NSInteger _orderState;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        _orderState = -1;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    if (_orderState == orderInfo.orderState) return;
    
    _orderState = orderInfo.orderState;
    CGFloat itemW = (kScreenW - 2 * kItemMargin - 2 * kContentLeftMargin) / 3.0;
    switch (_orderState) {
        case 1:
        case 2:
        {//待付款、已关闭
            if (!_downLoadPriceFormBtn) {
                _downLoadPriceFormBtn = [self setupButtonWithTitle:@"下载报价单" withTag:0];
                [self addSubview:_downLoadPriceFormBtn];
            }
            
            _downLoadPriceFormBtn.hidden = NO;
            _downLoadPriceFormBtn.frame = CGRectMake(kContentLeftMargin + 2 * (itemW + kItemMargin), 5, itemW, 34);
            _ticketApplyBtn.hidden = YES;
            _checkContractBtn.hidden = YES;
        }
            break;
        case 3:
        case 4:
        {//受理中、装修中
            if (!_downLoadPriceFormBtn) {
                _downLoadPriceFormBtn = [self setupButtonWithTitle:@"下载报价单" withTag:0];
                [self addSubview:_downLoadPriceFormBtn];
            }
            
            if (!_checkContractBtn) {
                _checkContractBtn = [self setupButtonWithTitle:@"查看合同" withTag:1];
                [self addSubview:_checkContractBtn];
            }
            
            _downLoadPriceFormBtn.hidden = NO;
            _downLoadPriceFormBtn.frame = CGRectMake(kContentLeftMargin + 1 * (itemW + kItemMargin), 5, itemW, 34);
            _checkContractBtn.hidden = NO;
            _checkContractBtn.frame = CGRectMake(kContentLeftMargin + 2 * (itemW + kItemMargin), 5, itemW, 34);
            _checkContractBtn.hidden = YES;
        }
            break;
        case 5:
        {//已完成
            if (!_downLoadPriceFormBtn) {
                _downLoadPriceFormBtn = [self setupButtonWithTitle:@"下载报价单" withTag:0];
                [self addSubview:_downLoadPriceFormBtn];
            }
            
            if (!_checkContractBtn) {
                _checkContractBtn = [self setupButtonWithTitle:@"查看合同" withTag:1];
                [self addSubview:_checkContractBtn];
            }
            
            if (!_ticketApplyBtn) {
                _ticketApplyBtn = [self setupButtonWithTitle:@"开票申请" withTag:2];
                [self addSubview:_ticketApplyBtn];
            }
            
            _downLoadPriceFormBtn.hidden = NO;
            _downLoadPriceFormBtn.frame = CGRectMake(kContentLeftMargin + 0 * (itemW + kItemMargin), 5, itemW, 34);
            
            _checkContractBtn.hidden = NO;
            _checkContractBtn.frame = CGRectMake(kContentLeftMargin + 1 * (itemW + kItemMargin), 5, itemW, 34);
            
            _ticketApplyBtn.hidden = NO;
            _ticketApplyBtn.frame = CGRectMake(kContentLeftMargin + 2 * (itemW + kItemMargin), 5, itemW, 34);
        }
            break;
        default:
            break;
    }
}

- (CGSize)viewSize {
    return CGSizeMake(kScreenW, 44);
}

- (UIButton *)setupButtonWithTitle:(NSString *)title withTag:(NSInteger)tag {
    UIButton *btn = [UIButton new];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.layer.cornerRadius = 5.0;
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