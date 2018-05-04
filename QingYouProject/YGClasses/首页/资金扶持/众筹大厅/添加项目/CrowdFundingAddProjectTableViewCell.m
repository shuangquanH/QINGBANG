//
//  CrowdFundingAddProjectTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CrowdFundingAddProjectTableViewCell.h"

@implementation CrowdFundingAddProjectTableViewCell
{
    UILabel *_nameLabel;
    UITextField *_textField;
    UILabel *_contentLabel;
    UIImageView *_headImageView;
    UIView *_baseView;
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
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 120, 50)];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _nameLabel.textColor = colorWithDeepGray;
        [_baseView addSubview:_nameLabel];
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YGScreenWidth-70, 10, 40, 40)];
//        _headImageView.layer.cornerRadius = 20;
        _headImageView.layer.borderColor = colorWithLine.CGColor;
        _headImageView.layer.borderWidth = 0.7;
        _headImageView.clipsToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_baseView addSubview:_headImageView];
        _headImageView.hidden = YES;
        
        if ([reuseIdentifier containsString:@"CrowdFundingAddProjectTableViewCelltextfield"]) {
            
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(_nameLabel.x+_nameLabel.width+10, 0, YGScreenWidth-(_nameLabel.x+_nameLabel.width+10)-12, _nameLabel.height)];
            _textField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _textField.textColor = colorWithDeepGray;
            _textField.placeholder = @"";
            _textField.delegate = self;
            _textField.textAlignment = NSTextAlignmentRight;
            [_baseView addSubview:_textField];
            [_textField setValue:colorWithLightGray forKeyPath:@"_placeholderLabel.textColor"];

            if ([reuseIdentifier isEqualToString:@"CrowdFundingAddProjectTableViewCelltextfield0"]) {
                _textField.placeholder = @"单位（元）";
                _textField.tag = 1000;
            }else{
                _textField.placeholder = @"目标天数";
                _textField.tag = 1001;

            }
            
            if ([reuseIdentifier isEqualToString:@"CrowdFundingAddProjectTableViewCelltextfield4"]) {
                _textField.placeholder = @"请填写联盟名称（限12字）";
                _textField.tag = 1000;
            }
            if ([reuseIdentifier isEqualToString:@"CrowdFundingAddProjectTableViewCelltextfield5"]) {
                _textField.placeholder = @"请填写联盟简介（限20字）";
                _textField.tag = 1000;
            }
            if ([reuseIdentifier isEqualToString:@"CrowdFundingAddProjectTableViewCelltextfield2"]) {
                _textField.tag = 1002;

            }

        }else
        {
            UIImageView *arrowImageView = [[UIImageView alloc] init];
            arrowImageView.frame = CGRectMake(0, 0, 17, 17);
            arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
            [arrowImageView sizeToFit];
            self.accessoryView = arrowImageView;
    
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.x+_nameLabel.width+10, 0, YGScreenWidth-(_nameLabel.x+_nameLabel.width+10)-30, _nameLabel.height)];
            _contentLabel.text = @"";
            _contentLabel.textAlignment = NSTextAlignmentRight;
            _contentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
            _contentLabel.textColor = colorWithDeepGray;
            [_baseView addSubview:_contentLabel];
            _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }

//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, baseView.height-1, YGScreenWidth-10, 1)];
//        lineView.backgroundColor = colorWithTable;
//        [baseView addSubview:lineView];
        
    }
    return self;
}


- (void)setModel:(CrowdFundingAddProjectModel *)model withIndexPath:(NSIndexPath *)indexPath
{
    _model = model;
    _indexPath = indexPath;
    _nameLabel.text = _model.title;
    if (indexPath.section == 1) {
        if ( [_model.content containsString:@"请填写"])
        {
            _textField.placeholder = _model.content;
        }else
        {
            _textField.text = _model.content;
        }
    }
    else
    {
        if ( [_model.content containsString:@"请填写"] || [_model.content containsString:@"请上传"] ||  [_model.content containsString:@"请选择"])
        {
            _textField.placeholder = _model.content;
            _contentLabel.text = _model.content;
            _contentLabel.textColor = colorWithLightGray;
        }else
        {
            _contentLabel.text = _model.content;
            _contentLabel.textColor = colorWithBlack;

            _textField.text = _model.content;

        }
    }
    _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, 50);
    _headImageView.hidden = YES;
    if ( _model.image != nil || (indexPath.section == 0 && indexPath.row == 0))
    {
        if (_model.image != nil )
        {
            _headImageView.hidden = NO;
            _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, 60);

            _nameLabel.frame =  CGRectMake(10,0 , 120, _baseView.height);

            _headImageView.frame = CGRectMake(YGScreenWidth-70, 10, 40, 40);
            
            if (![model.content containsString:@"请"])
            {
                _contentLabel.text = @"";
                [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.content] placeholderImage:YGDefaultImgAvatar];
            }
            if (![_model.image isEqual:YGDefaultImgAvatar]) {
                _headImageView.image = _model.image;

            }
        }
        
    }

  
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_needReturnIndexPath == YES) {
        [self.delegate textfieldReturnValue:textField.text withTextIndexPath:_indexPath];
        
    }else
    {
        
        [self.delegate textfieldReturnValue:textField.text withTextfiledTag:textField.tag];
    }
}
@end
