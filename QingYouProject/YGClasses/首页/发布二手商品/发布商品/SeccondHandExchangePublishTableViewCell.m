//
//  SeccondHandExchangePublishTableViewCell.m
//  QingYouProject
//
//  Created by 王丹 on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SeccondHandExchangePublishTableViewCell.h"

@implementation SeccondHandExchangePublishTableViewCell
{
    UITextField *_textField;
    UIImageView *_arrowImageView;
    UILabel *_alreadyLabel;
    UIButton *_checkButton;
    UILabel *_uinitLabel;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(SeccondHandExchangePublishModel *)model withIndexPath:(NSIndexPath *)indexPath
{
    _model  = model;
    _indexPath = indexPath;
    _alreadyLabel.text = _model.title;
    _textField.placeholder = _model.placehoder;
    _textField.text = _model.content;
    _arrowImageView.hidden = YES;
    [_alreadyLabel sizeToFit];
    _alreadyLabel.frame = CGRectMake(_alreadyLabel.x,_alreadyLabel.y, _alreadyLabel.width, 45);
    _checkButton.selected = _model.isSelect;
    _textField.userInteractionEnabled = YES;

    if (_indexPath.row == 0) {
        _textField.userInteractionEnabled = NO;
        _arrowImageView.hidden = NO;
        _textField.frame = CGRectMake(_alreadyLabel.x+_alreadyLabel.width+10, 0, YGScreenWidth-(_alreadyLabel.x+_alreadyLabel.width+10)-30, _alreadyLabel.height);

    }
    if (_indexPath.row == 0 || _indexPath.row == 2 || _indexPath.row == 3) {
        if (_checkButton.selected == NO) {
            _textField.userInteractionEnabled = NO;
        }
    }
    if (_indexPath.row ==1 ||_indexPath.row == 4 || _indexPath.row == 5)
    {
   
        _checkButton.hidden = YES;
        if (_indexPath.row == 1)
        {
            _uinitLabel.hidden = NO;
            _textField.frame = CGRectMake(_alreadyLabel.x+_alreadyLabel.width+10, 0, YGScreenWidth-(_alreadyLabel.x+_alreadyLabel.width+10)-60, _alreadyLabel.height);
            if (_model.isSelect == YES) {
                _textField.userInteractionEnabled = YES;
            }else
            {
                _textField.userInteractionEnabled = NO;
            }
            
        }else
        {
            _alreadyLabel.x = 10;
        }
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *aggrementView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
        [self.contentView addSubview:aggrementView];
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkButton.frame = CGRectMake(0, 5, 35, 35);
        _checkButton.tag = 1994;
        [_checkButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"choice_btn_green"] forState:UIControlStateSelected];
        _checkButton.contentMode = UIViewContentModeCenter;
        [_checkButton addTarget:self action:@selector(isAgreeClick:) forControlEvents:UIControlEventTouchUpInside];
        [aggrementView addSubview:_checkButton];
        
        _alreadyLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 90, 45)];
        _alreadyLabel.text = @"已阅读";
        _alreadyLabel.textAlignment = NSTextAlignmentRight;
        _alreadyLabel.textColor = colorWithDeepGray;
        _alreadyLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [_alreadyLabel sizeToFit];
        _alreadyLabel.frame = CGRectMake(_alreadyLabel.x,_alreadyLabel.y, _alreadyLabel.width, 45);
        [aggrementView addSubview:_alreadyLabel];

        _textField = [[UITextField alloc] initWithFrame:CGRectMake(_alreadyLabel.x+_alreadyLabel.width+10, 0, YGScreenWidth-(_alreadyLabel.x+_alreadyLabel.width+10)-20, _alreadyLabel.height)];
        _textField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _textField.textColor = colorWithDeepGray;
        _textField.placeholder = @"";
        _textField.delegate = self;
        _textField.textAlignment = NSTextAlignmentRight;
        [aggrementView addSubview:_textField];
        [_textField setValue:colorWithLightGray forKeyPath:@"_placeholderLabel.textColor"];
        
         _uinitLabel = [[UILabel alloc]initWithFrame:CGRectMake(YGScreenWidth-45, _textField.y, 20, 45)];
        _uinitLabel.text = @"元";
        _uinitLabel.textAlignment = NSTextAlignmentRight;
        _uinitLabel.textColor = colorWithBlack;
        _uinitLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [aggrementView addSubview:_uinitLabel];
        _uinitLabel.hidden = YES;
        
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.frame = CGRectMake(0, 0, 17, 17);
        _arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
        [_arrowImageView sizeToFit];
        self.accessoryView = _arrowImageView;

    }
    return self;
}

- (void)isAgreeClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.delegate SeccondHandExchangePublishTableViewCellSelectButtonActionWithIndexPath:_indexPath];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate SeccondHandExchangePublishTableViewCelltextfieldReturnValue:textField.text withTextIndexPath:_indexPath];
}
@end
