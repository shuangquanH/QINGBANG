//
//  SecondhandReplacementMyInteractionTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementMyInteractionTableViewCell.h"
#import "SecondhandReplacementMyInteractionModel.h"

@implementation SecondhandReplacementMyInteractionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.numberOfLines =0 ;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
    }];

    UITapGestureRecognizer *titleLabelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapGestureRecognizerClick)];
    [_titleLabel addGestureRecognizer:titleLabelTapGestureRecognizer];
    _titleLabel.userInteractionEnabled = YES; //
    
    
    _exchangeLabel = [[UILabel alloc]init];
    _exchangeLabel.textColor = colorWithDeepGray;
    _exchangeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _exchangeLabel.numberOfLines =0 ;
    [self.contentView addSubview:_exchangeLabel];
    [_exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
    }];
    UITapGestureRecognizer *exchangeLabelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeLabelTapGestureRecognizerClick)];
    // 2. 将点击事件添加到label上
    [_exchangeLabel addGestureRecognizer:exchangeLabelTapGestureRecognizer];
    _exchangeLabel.userInteractionEnabled = YES; //
    
    _exchangeLabel.text = @"";
    
    _agreeButton = [[UIButton alloc]init];
    [self.contentView addSubview:_agreeButton];
    [_agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _agreeButton.layer.borderWidth = 1;
    _agreeButton.layer.cornerRadius = 12;
    _agreeButton.layer.masksToBounds = YES;
    _agreeButton.layer.borderColor = colorWithMainColor.CGColor;
    _agreeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    [_agreeButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    
    float w = ([UILabel calculateWidthWithString:_agreeButton.titleLabel.text textFont:LDFont(12) numerOfLines:1].width + 30);
    [_agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-LDHPadding);
        make.top.equalTo(_exchangeLabel.mas_bottom).offset(10);
        make.width.offset(w);
         make.height.offset(24);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-LDHPadding);
       
    }];
    
    
    _refuseButton = [[UIButton alloc]init];
    [self.contentView addSubview:_refuseButton];
    [_refuseButton addTarget:self action:@selector(refuseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _refuseButton.layer.borderWidth = 1;
    _refuseButton.layer.cornerRadius = 12;
    _refuseButton.layer.masksToBounds = YES;
    _refuseButton.layer.borderColor = colorWithLine.CGColor;
    _refuseButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [_refuseButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    
    [_refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_agreeButton.mas_left).offset(-LDHPadding);
        make.top.equalTo(_exchangeLabel.mas_bottom).offset(10);
        make.width.offset(w);
        make.height.offset(24);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-LDHPadding);;
    }];
    
}

-(void)setModel:(SecondhandReplacementMyInteractionModel *)model
{
    _model = model;
    
    NSInteger status = [model.status integerValue];
    
    switch (status) {
        case 1:
        {
            _titleLabel.attributedText = [[NSString stringWithFormat:@"%@ 想用%@",model.buyerName,model.tobeChangeName] ld_attributedStringFromNSString:[NSString stringWithFormat:@"%@ 想用%@",model.buyerName,model.tobeChangeName] startLocation:[NSString stringWithFormat:@"%@ 想用",model.buyerName].length forwardFont:[UIFont systemFontOfSize:YGFontSizeNormal] backFont:[UIFont systemFontOfSize:YGFontSizeNormal] forwardColor:colorWithBlack backColor:colorWithDeepGray];
            
            _exchangeLabel.attributedText = [[NSString stringWithFormat:@"与您换%@",model.wantChangeName] ld_attributedStringFromNSString:[NSString stringWithFormat:@"与您换%@",model.wantChangeName] startLocation:3 forwardFont:[UIFont systemFontOfSize:YGFontSizeNormal] backFont:[UIFont systemFontOfSize:YGFontSizeNormal] forwardColor:colorWithBlack backColor:colorWithDeepGray];
            
            _agreeButton.hidden = NO;
            _refuseButton.hidden =NO;
            [_refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];

            [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
            float w = ([UILabel calculateWidthWithString:@"同意" textFont:LDFont(12) numerOfLines:1].width + 30);
            [_agreeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(w);
                make.height.offset(24);
            }];
            [_refuseButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(w);
                make.height.offset(24);
            }];
        }
            break;
        case 2:
        {
            NSString * titleStr = [NSString stringWithFormat:@"%@ 同意了您用%@",model.buyerName,model.tobeChangeName];
            
            _titleLabel.attributedText = [titleStr ld_attributedStringFromNSString:titleStr startLocation:[NSString stringWithFormat:@"%@ 同意了您用",model.buyerName].length forwardFont:[UIFont systemFontOfSize:YGFontSizeNormal] backFont:[UIFont systemFontOfSize:YGFontSizeNormal] forwardColor:colorWithBlack backColor:colorWithDeepGray];
            
            NSString * exchangeStr = [NSString stringWithFormat:@"与Ta换%@",model.wantChangeName];
            
            _exchangeLabel.attributedText = [exchangeStr ld_attributedStringFromNSString:exchangeStr startLocation:4 forwardFont:[UIFont systemFontOfSize:YGFontSizeNormal] backFont:[UIFont systemFontOfSize:YGFontSizeNormal] forwardColor:colorWithBlack backColor:colorWithDeepGray];
            
            _agreeButton.hidden = NO;
            _refuseButton.hidden =YES;
            
            [_agreeButton setTitle:@"立即支付" forState:UIControlStateNormal];
            float w = ([UILabel calculateWidthWithString:@"立即支付" textFont:LDFont(12) numerOfLines:1].width + 30);
            [_agreeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(w);
                make.height.offset(24);
            }];
            [_refuseButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(w);
                make.height.offset(24);
            }];
        }
            break;
        case 3:
        {
            NSString * titleStr = [NSString stringWithFormat:@"%@ 拒绝了您用%@",model.buyerName,model.tobeChangeName];
            
            _titleLabel.attributedText = [titleStr ld_attributedStringFromNSString:titleStr startLocation:[NSString stringWithFormat:@"%@ 拒绝了您用",model.buyerName].length forwardFont:[UIFont systemFontOfSize:YGFontSizeNormal] backFont:[UIFont systemFontOfSize:YGFontSizeNormal] forwardColor:colorWithBlack backColor:colorWithDeepGray];
            
            NSString * exchangeStr = [NSString stringWithFormat:@"与Ta换%@",model.wantChangeName];
            
            _exchangeLabel.attributedText = [exchangeStr ld_attributedStringFromNSString:exchangeStr startLocation:4 forwardFont:[UIFont systemFontOfSize:YGFontSizeNormal] backFont:[UIFont systemFontOfSize:YGFontSizeNormal] forwardColor:colorWithBlack backColor:colorWithDeepGray];
            
            _agreeButton.hidden = YES;
            _refuseButton.hidden =YES;
            [_agreeButton setTitle:@"" forState:UIControlStateNormal];
            [_refuseButton setTitle:@"" forState:UIControlStateNormal];

            [_refuseButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            [_agreeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
        }
            break;

        default:
            break;
    }
}

-(void)refuseButtonClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementMyInteractionTableViewCellRefuseButtonButton:btn withRow:self.row];
}
-(void)agreeButtonClick:(UIButton *)btn
{
    [self.delegate secondhandReplacementMyInteractionTableViewCellAgreeButtonButton:btn withRow:self.row];
}
-(void)titleLabelTapGestureRecognizerClick
{
    [self.delegate secondhandReplacementMyInteractionTableViewCellOtherGoodsDetailWithRow:self.row];
}
-(void)exchangeLabelTapGestureRecognizerClick
{
    [self.delegate secondhandReplacementMyInteractionTableViewCellMyGoodsDetailWithRow:self.row];
}
@end


