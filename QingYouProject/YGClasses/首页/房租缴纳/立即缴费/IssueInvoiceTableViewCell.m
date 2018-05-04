//
//  IssueInvoiceTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "IssueInvoiceTableViewCell.h"

@implementation IssueInvoiceTableViewCell
{
    UILabel *_nameLabel;
    UITextField *_textField;
    UILabel *_contentLabel;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = colorWithTable;
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
        baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:baseView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 115, 45)];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _nameLabel.textColor = colorWithDeepGray;
        [baseView addSubview:_nameLabel];
        
        
       NSArray *titleArray = @[@"开具类型",@"税务登记证号",@"基本开户银行名称",@"基本开户账号",@"注册场所地址",@"注册固定电话"];

            NSArray *array = @[@"个人",@"登记证号",@"开户银行",@"开户账号",@"准确地址",@"固定电话"];

            _textField = [[UITextField alloc] initWithFrame:CGRectMake(_nameLabel.x+_nameLabel.width+10, 0, YGScreenWidth-(_nameLabel.x+_nameLabel.width+10)-10, _nameLabel.height)];
            _textField.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            _textField.textColor = colorWithDeepGray;
            _textField.placeholder = @"";
            _textField.delegate = self;
            _textField.textAlignment = NSTextAlignmentRight;
            [baseView addSubview:_textField];
            [_textField setValue:colorWithLightGray forKeyPath:@"_placeholderLabel.textColor"];
            
            int index = [[reuseIdentifier substringFromIndex:reuseIdentifier.length-1] intValue];
            _textField.tag = 10000+index;
            _nameLabel.text = titleArray[index];
        if ([reuseIdentifier containsString:@"CrowdFundingAddProjectTableViewCelltextfield"]) {
            _textField.placeholder = [NSString stringWithFormat:@"请输入%@",array[index]];

        }else
        {
            _textField.placeholder = @"";
            _textField.userInteractionEnabled = NO;

        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 45, YGScreenWidth-10, 1)];
        lineView.backgroundColor = colorWithTable;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate IssueInvoiceTableViewCellTakeTextfield:textField];
}
- (void)setModel:(InvoiceInfoManagerModel *)model withIsChange:(BOOL)isChange
{
    _model = model;
    
        if (isChange == true && [_model.title isEqualToString:@"type"])
        {
            _textField.text = [_model.content isEqualToString:@"0"]?@"个人":@"企业";
            _textField.userInteractionEnabled = NO;
        }else
        {
            _textField.text = _model.content;
        }
}

@end
