//
//  LDPayOptionView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/10.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDPayOptionView.h"
#import "LDVIPButton.h"

@interface LDPayOptionView ()
/** 记录选中的Vipbutton  */
@property (nonatomic,strong) LDVIPButton * selectedVipButton;
/** 视图View  */
@property (nonatomic,strong) UIView * contentView;

@end

@implementation LDPayOptionView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSArray * vipType = @[@"续费VIP月卡",@"续费VIP季卡",@"续费VIP年卡"];
        NSArray * money = @[@"300元",@"900元",@"3600元"];
        self.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
        //添加子视图
        CGRect contentRect = CGRectMake(kScreenW, frame.size.height - 200, kScreenW, 200);
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = kWhiteColor;
        self.contentView.frame = contentRect;
        [self addSubview:self.contentView];
        //防止点击事件穿透到父View
        UIButton * coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        coverButton.frame = self.contentView.bounds;
        coverButton.backgroundColor = kClearColor;
        [coverButton addTarget:self action:@selector(coverButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:coverButton];
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_right);
//            make.bottom.equalTo(self.mas_bottom).offset(0);
//            make.height.offset(200);
//            make.width.offset(kScreenW);
//        }];
        CGFloat X = LDHPadding;
        CGFloat Y = LDVPadding;
        CGFloat W = kScreenW - 2 * LDHPadding;
        CGFloat H = 50;
        for (int i = 0; i < 3; i++) {
            CGRect rect = CGRectMake(X, Y + (Y + H) * i, W, H);
            
            NSString * leftStr = vipType[i];
            NSString * rightStr = money[i];
            LDVIPButton * button = [LDVIPButton buttonWithType:UIButtonTypeCustom leftTitle:leftStr rightTitle:rightStr frame:rect];
            [self.contentView addSubview:button];
            [button addTarget:self action:@selector(goodsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100 + i;
        }
    }
    return self;
}
#pragma mark - 点击事件
- (void)goodsButtonClick:(LDVIPButton *)goodsButton{
    //将原来选中的 取消 选中
    self.selectedVipButton.selected = NO;
 
    //将点击的 做 选中标记
    goodsButton.selected = YES;
    

    NSInteger tag = goodsButton.tag;
    
    //代理回调用
    [self.delegate payOptionViewDidSelectButton:goodsButton.leftLabel.text rightString:goodsButton.rightLable.text];
    
    switch (tag) {
        case 100:
            {
            }
            break;
            
        case 101:
        {
            
        }
            break;
        case 102:
        {
            
        }
            break;
            
    }
    self.selectedVipButton = goodsButton;
    
}
- (void)showPayOptionViewOn:(UIView *)superView{
    
    //自己是个背景 View
    [superView addSubview:self];
    
    CGRect contentRect = CGRectMake(0, self.frame.size.height - 200, kScreenW, 200);

    [UIView animateWithDuration:0.25 animations:^{
  
        self.contentView.frame = contentRect;
    }];
    
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//    }];
    
//    [UIView animateWithDuration:0.25 animations:^{
//
//        [self.contentView layoutIfNeeded];
//    }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGRect contentRect = CGRectMake(kScreenW, self.frame.size.height - 200, kScreenW, 200);

    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = contentRect;

    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}
- (void)coverButtonClick{
    
    LDLog(@"%@", @11)
}
- (void)dealloc{
    
    LDLogFunc
}
@end
