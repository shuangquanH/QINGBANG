//
//  SQAddTicketApplyInputCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQAddTicketApplyInputCell.h"
#import "UILabel+SQAttribut.h"

@implementation SQAddTicketApplyInputCell
{
    UITextField *_inputTF;
    UILabel *_titleLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.editEnable = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    _titleLab = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_333];
    [self.contentView addSubview:_titleLab];
    
    _inputTF = [[UITextField alloc] init];
    _inputTF.font = KFONT(28);
    _inputTF.textColor = kCOLOR_333;
    [_inputTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_inputTF];
    
    [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(180));
        make.centerY.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-KSCAL(30));
    }];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(KSCAL(30));
        make.right.equalTo(_inputTF.mas_left);
    }];
    
}

- (void)setContentAlignment:(NSTextAlignment)contentAlignment {
    _inputTF.textAlignment = contentAlignment;
}
- (void)setEditEnable:(BOOL)editEnable {
    _inputTF.enabled = editEnable;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _inputTF.keyboardType = keyboardType;
}

- (void)textFieldChanged:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(cell:didEditTextField:)]) {
        [self.delegate cell:self didEditTextField:textField];
    }
}

- (void)configTitle:(NSString *)title placeHodler:(NSString *)placeHodler content:(NSString *)content necessary:(BOOL)necessary {
    if (necessary) {
        _titleLab.text = [NSString stringWithFormat:@"%@ ", title];
        [_titleLab appendImage:[UIImage imageNamed:@"invoicetitle_redpoint"] imageFrame:CGRectMake(0, 2, 7, 7) withType:SQAppendImageInRight];
    }
    else {
        _titleLab.text = title;
    }
    _inputTF.placeholder = placeHodler;
    _inputTF.text = content;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(KAPP_WIDTH, KSCAL(90));
}

@end
