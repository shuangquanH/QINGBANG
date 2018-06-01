//
//  SQAddTicketApplyInputCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQAddTicketApplyInputCell.h"

@implementation SQAddTicketApplyInputCell
{
    UITextField *_inputTF;
    UILabel *_titleLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    _titleLab = [UILabel labelWithFont:15.0 textColor:[UIColor blackColor]];
    [_titleLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_titleLab];
    
    _inputTF = [[UITextField alloc] init];
    _inputTF.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_inputTF];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_titleLab.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-15);
    }];
}

- (void)configTitle:(NSString *)title placeHodler:(NSString *)placeHodler content:(NSString *)content {
    _titleLab.text = title;
    _inputTF.placeholder = placeHodler;
    _inputTF.text = content;
}

@end
