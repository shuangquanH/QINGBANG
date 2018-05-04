//
//  IssueAdvertiseViewTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "IssueAdvertiseViewTableViewCell.h"
#import "IssueAdvertiseViewController.h"

@implementation IssueAdvertiseViewTableViewCell
{
    UILabel *_nameLabel;
    UITextField *_textField;
    UILabel *_contentLabel;
    UITextView *_textView;
    UIView *_baseView;
    UILabel *_placehodlerLabel;

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
        self.contentView.backgroundColor = colorWithYGWhite;
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 100, 45)];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _nameLabel.textColor = colorWithDeepGray;
        [_baseView addSubview:_nameLabel];
        
        
        if ([reuseIdentifier containsString:@"CrowdFundingAddProjectTableViewCelltextfield"]) {
            
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(_nameLabel.x+_nameLabel.width+10, 0, YGScreenWidth-(_nameLabel.x+_nameLabel.width+10)-10, _nameLabel.height)];
            _textField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _textField.textColor = colorWithDeepGray;
            _textField.placeholder = @"";
            _textField.delegate = self;
            _textField.textAlignment = NSTextAlignmentRight;
            [_baseView addSubview:_textField];
            [_textField setValue:colorWithLightGray forKeyPath:@"_placeholderLabel.textColor"];
            
            if ([reuseIdentifier isEqualToString:@"CrowdFundingAddProjectTableViewCelltextfieldCompanyName"])
            {
                _textField.placeholder = @"请输入企业名称";
                _textField.tag = 1000;
            }else if([reuseIdentifier isEqualToString:@"CrowdFundingAddProjectTableViewCelltextfieldCount"])
            {
                _textField.placeholder = @"请输入招聘人数";
                _textField.tag = 1001;
                
            }else if([reuseIdentifier isEqualToString:@"CrowdFundingAddProjectTableViewCelltextfieldName"])
            {
                _textField.placeholder = @"请输入姓名";
                _textField.tag = 1002;
                
            }else if([reuseIdentifier isEqualToString:@"CrowdFundingAddProjectTableViewCelltextfieldPhone"])
            {
                _textField.placeholder = @"请输入手机号码";
                _textField.tag = 1003;
            }
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _baseView.height-1, YGScreenWidth-10, 1)];
//            lineView.backgroundColor = colorWithTable;
//            [_baseView addSubview:lineView];
            
        }else  if ([reuseIdentifier containsString:@"CrowdFundingAddProjectTableViewCelltextView"])
        {
            _baseView.frame = CGRectMake(_baseView.x, _baseView.y, YGScreenWidth, 100);
         
            _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, _nameLabel.y+_nameLabel.height, YGScreenWidth-20, 45)];
            _textView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _textView.textColor = colorWithBlack;
            _textView.returnKeyType = UIReturnKeyDone;
            _textView.backgroundColor = [UIColor clearColor];
            _textView.textAlignment = NSTextAlignmentLeft;
//            _textView.placeholder = @"请输入职位描述";
            _textView.scrollEnabled = NO;
            _textView.delegate = self;
            [_baseView addSubview:_textView];
            
            _placehodlerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 100, 45)];
            _placehodlerLabel.text = @"请输入职位描述";
            _placehodlerLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            _placehodlerLabel.textColor = colorWithPlaceholder;
            [_textView addSubview:_placehodlerLabel];
            
            
        }else
        {
            UIImageView *arrowImageView = [[UIImageView alloc] init];
            arrowImageView.frame = CGRectMake(0, 0, 17, 17);
            arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
            [arrowImageView sizeToFit];
            self.accessoryView = arrowImageView;
            
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.x+_nameLabel.width+10, 0, YGScreenWidth-(_nameLabel.x+_nameLabel.width+10)-30, _nameLabel.height)];
            _contentLabel.text = @"请选择";
            _contentLabel.textAlignment = NSTextAlignmentRight;
            _contentLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
            _contentLabel.textColor = colorWithDeepGray;
            [_baseView addSubview:_contentLabel];
            _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _baseView.height-1, YGScreenWidth-10, 1)];
//            lineView.backgroundColor = colorWithLine;
//            [_baseView addSubview:lineView];
            
        }
        
      
    }
    return self;
}


- (void)setModel:(AdvertisesForInfoModel *)model withIndexPath:(NSIndexPath *)indexPath
{
    _model = model;
    _indexPath = indexPath;
    _nameLabel.text = _model.title;
    _textField.text = _model.content;
    _contentLabel.text = _model.content;
    if ([self.reuseIdentifier isEqualToString:@"CrowdFundingAddProjectTableViewCelltextView"]) {
        _textView.text = _model.content;
        
    }
    if (![_contentLabel.text isEqualToString:@"请选择"]) {
        _contentLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placehodlerLabel.hidden = NO;
    }else
    {
        _placehodlerLabel.hidden = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
        [self.delegate textViewCell:self didChangeText:textView.text];
    }
    CGRect bounds = textView.frame;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(YGScreenWidth-20, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size.height = newSize.height;
    textView.frame = bounds;
    
    CGRect rect = _baseView.frame;
    rect.size.height = newSize.height+60;
    _baseView.frame = rect;
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}
- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _model.content = textField.text;
    [self.delegate textfieldEndEdtingWithModel:_model withIndexPath:_indexPath];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(YGScreenWidth, _baseView.height);
}
@end
