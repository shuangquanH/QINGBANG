//
//  PlayTogetherSignupTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PlayTogetherSignupTableViewCell.h"
#import "UITextField+YG.h"

@implementation PlayTogetherSignupTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self configUI];
    }
    
    return self;
}

- (void)configUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = colorWithDeepGray;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_titleLabel];
    
    _detailTextField = [[UITextField alloc] init];
    _detailTextField.font = _titleLabel.font;
    _detailTextField.textColor = colorWithBlack;
    _detailTextField.textAlignment = NSTextAlignmentRight;
    _detailTextField.delegate = self;
    [self.contentView addSubview:_detailTextField];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.mas_equalTo(12);
         make.centerY.mas_equalTo(0);
     }];
    
    [_detailTextField mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.bottom.mas_equalTo(0);
         make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
         make.right.mas_equalTo(-12);
     }];
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    _infoDic = infoDic;
    _titleLabel.text = infoDic[@"customName"];
    _detailTextField.placeholder = infoDic[@"placeholder"];
    _detailTextField.text = infoDic[@"value"];

//    if([_titleLabel.text isEqualToString:@"联系人"])
//    {
//        _detailTextField.keyboardType = UIKeyboardTypeDefault;
//        _detailTextField.limitTextLength = 6;
//
//    }
//    else
//    {
//        _detailTextField.keyboardType = UIKeyboardTypeNumberPad;
//        _detailTextField.limitTextLength = 11;
//    }
  
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_delegate PlayTogetherSignupTableViewCell:self textFieldDidEndEditingWithString:textField.text];
}


@end

