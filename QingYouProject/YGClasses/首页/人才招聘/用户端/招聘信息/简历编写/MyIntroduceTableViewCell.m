//
//  MyIntroduceTableViewCell.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyIntroduceTableViewCell.h"

@implementation MyIntroduceTableViewCell

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
    _detailTextField.placeholder = @"请选择";
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
    _titleLabel.text = infoDic[@"title"];
    if ([infoDic[@"showArrow"] boolValue])
    {
        _detailTextField.userInteractionEnabled = NO;
        _detailTextField.placeholder = @"请选择";
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        _detailTextField.userInteractionEnabled = YES;
        _detailTextField.placeholder = infoDic[@"placeHolder"];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_delegate myIntroduceTableViewCell:self textFieldDidEndEditingWithString:textField.text];
}

@end
