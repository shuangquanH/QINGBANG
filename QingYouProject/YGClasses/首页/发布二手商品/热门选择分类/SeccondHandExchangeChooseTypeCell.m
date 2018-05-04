//
//  SeccondHandExchangeChooseTypeCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SeccondHandExchangeChooseTypeCell.h"

@implementation SeccondHandExchangeChooseTypeCell
{
    UIView *_baseView;
    UIImageView *_productImageView;
    UILabel  *_nameLabel;
    UIButton *_selectButton;
}
- (void)setModel:(SeccondHandExchangeTypeModel *)model
{
    _model = model;
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:YGDefaultImgSquare];
    _nameLabel.text = _model.title;
    _selectButton.hidden = !_model.isSelect;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (YGScreenWidth - 2 * 4 - 18) / 3 - 4,(YGScreenWidth - 2 * 4 - 18) / 3 - 4)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
        //左线
        UIImage *titleImage = [UIImage imageNamed:@"steward_rent_infomation"];
        _productImageView = [[UIImageView alloc]initWithImage:titleImage];
        _productImageView.frame = CGRectMake(_baseView.width/2-titleImage.size.width/2,_baseView.height/2-titleImage.size.height/2-10,titleImage.size.width,titleImage.size.height);
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
        _productImageView.clipsToBounds = YES;
        [_baseView addSubview:_productImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_productImageView.y+_productImageView.height+5 , _baseView.width, 20)];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _nameLabel.textColor = colorWithDeepGray;
        [_baseView addSubview:_nameLabel];
        
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(_baseView.width-20, 5, 17, 17);
        [_selectButton setImage:[UIImage imageNamed:@"choice_btn_green"] forState:UIControlStateNormal];
        [_selectButton.imageView sizeToFit];
        [_baseView addSubview:_selectButton];
        
    }
    return self;
}
@end
