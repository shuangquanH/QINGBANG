//
//  OrderDetailBottomView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderDetailBottomView.h"



@interface OrderDetailBottomView ()

/** 订单底部相关字段  */
@property (nonatomic,strong) NSArray * dataArray;
/** 最后一个label  */
@property (nonatomic,strong) UILabel * lastLabel;
/** 底部视图  */
@property (nonatomic,strong) UIView * bottomView;
@end

@implementation OrderDetailBottomView

#pragma mark - 刷新数据
- (void)reloadDataWithTitleArry:(NSArray *)titleArry WithOrderNumber:(NSArray *)orderNumberArray {
    
    for (int i = 0; i < orderNumberArray.count; i ++) {
        
        UILabel * label = [self viewWithTag:100 + i];
        
        label.text = [NSString stringWithFormat:@"%@%@",titleArry[i],orderNumberArray[i]];
    }

}

- (instancetype)initOrderDetailBottomViewWithY:(CGFloat)y leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle bottomNumber:(int)number{
    
    
    self = [super initWithFrame:CGRectMake(0, y, kScreenW, 0)];
    
    UIView * lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, LDVPadding)];
    
    lineTop.backgroundColor = LDEEPaddingColor;
    
    [self addSubview:lineTop];
    
    CGFloat X = LDHPadding;
    CGFloat W = kScreenW - 2 * LDHPadding+10;
    CGFloat H = 2 * LDHPadding+5;
    CGFloat Y = 2 * LDHPadding+5;
    
    for (int i = 0; i < number; i++) {
        
        
        UILabel * lable = [UILabel labelWithFont:YGFontSizeNormal textColor:LD9ATextColor textAlignment:NSTextAlignmentLeft];
        
        lable.frame = CGRectMake(X, Y + H * i, W, H);
        
        [self addSubview:lable];
        
        lable.tag = 100 + i;
        
        if (i == (number - 1)) {
            
            self.lastLabel = lable;
            
        }
        
    }

    //底部视图
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lastLabel.frame), kScreenW, 4 * LDVPadding)];
    
    [self addSubview:self.bottomView];
    
    UIButton * receiveButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:rightButtonTitle selectedTitle:rightButtonTitle normalTitleColor:LDMainColor selectedTitleColor:LDMainColor backGroundColor:kWhiteColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:14];
    [receiveButton addTarget:self action:@selector(receiveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:receiveButton];
    
    [receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(- LDHPadding);
        make.top.offset(8);
        make.bottom.offset(-5);
        
        if (rightButtonTitle.length > 0) {//有值
            
            make.width.offset([UILabel calculateWidthWithString:rightButtonTitle textFont:[UIFont systemFontOfSize:YGFontSizeNormal] numerOfLines:1].width + 30);
            
        }else {//无值
            
           make.width.offset([UILabel calculateWidthWithString:rightButtonTitle textFont:[UIFont systemFontOfSize:YGFontSizeNormal] numerOfLines:1].width);
            
        }
        
    }];
    
    UIButton * chargebackButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:leftButtonTitle selectedTitle:leftButtonTitle normalTitleColor:LD16TextColor selectedTitleColor:LD16TextColor backGroundColor:kWhiteColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:14];
    
    [chargebackButton addTarget:self action:@selector(chargebackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:chargebackButton];
    
    
    [chargebackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(receiveButton.mas_left).offset(- LDHPadding);
        make.top.offset(8);
        make.bottom.offset(-5);
        if (leftButtonTitle.length > 0) {//有值
            
            make.width.offset([UILabel calculateWidthWithString:leftButtonTitle textFont:[UIFont systemFontOfSize:YGFontSizeNormal] numerOfLines:1].width + 30);

        }else {//无值
            
            make.width.offset([UILabel calculateWidthWithString:leftButtonTitle textFont:[UIFont systemFontOfSize:YGFontSizeNormal] numerOfLines:1].width);

        }
    }];
    
    chargebackButton.layer.borderWidth = 1;
    chargebackButton.layer.cornerRadius = 14;
    chargebackButton.layer.masksToBounds = YES;
    chargebackButton.layer.borderColor = colorWithLine.CGColor;
    receiveButton.layer.borderWidth = 1;
    receiveButton.layer.cornerRadius = 14;
    receiveButton.layer.masksToBounds = YES;
    receiveButton.layer.borderColor = LDMainColor.CGColor;
    
    
    chargebackButton.hidden = (leftButtonTitle.length > 0) ? NO : YES;
    receiveButton.hidden = (rightButtonTitle.length > 0) ? NO : YES;
    
    
    self.frame = CGRectMake(0, y, kScreenW, CGRectGetMaxY(self.lastLabel.frame) + 4 * LDVPadding);
    
    return self;
}
#pragma mark - 确认收货点击事件
- (void)receiveButtonClick:(UIButton *)receiveButton{
    [self.delegate orderDetailBottomViewPayBtnClick:receiveButton];
}

#pragma mark - 申请退单点击事件
- (void)chargebackButtonClick:(UIButton *)chargebackButton{
    [self.delegate orderDetailBottomViewCancelBtnClick:chargebackButton];
}
#pragma mark - 懒加载数据源
//- (NSArray *)dataArray{
//
//    if (!_dataArray) {
//        _dataArray = @[@"订单单号: ",@"下单时间: ",@"支付时间: ",@"发货时间: ",@"确认时间: "];
//    }
//    return _dataArray;
//
//}
@end
