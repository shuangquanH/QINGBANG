//
//  SecondhandReplaceLogisticeInforTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplaceLogisticeInforTableViewCell.h"
#import "SecondhandReplaceLogisticeInforModel.h"

@interface SecondhandReplaceLogisticeInforTableViewCell ()
{
    UILabel * _addressLabel;
    UILabel * _timeLable;
    UIImageView * _arriveImage;
    UILabel * _top;
    UILabel * _bottom;

}
@end
@implementation SecondhandReplaceLogisticeInforTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}
-(void)setModel:(SecondhandReplaceLogisticeInforModel *)model withRow:(NSInteger )row withCount:(NSUInteger )count
{    
    _model =model;
    _addressLabel.text = model.context;
    _timeLable.text = model.time;
    _addressLabel.textColor = colorWithDeepGray;
    _timeLable.textColor = colorWithDeepGray;
    _top.hidden = NO;
    _bottom.hidden = NO;
    _arriveImage.image = [UIImage imageNamed:@"secondhand_messagehint_gray"];

    if(row!=0)
    {
        if(row== (count -1))
        {
            _bottom.hidden =YES;
        }
         return;
    }
    _arriveImage.image = [UIImage imageNamed:@"secondhand_messagehint_green"];
    _addressLabel.textColor = colorWithMainColor;
    _timeLable.textColor = colorWithMainColor;
    _top.hidden =YES;

}
- (void)setupUI{
  
    _top = [UILabel new];
    _top.backgroundColor = colorWithLine;
    [self.contentView addSubview:_top];
    [_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
        make.width.offset(1);
        make.height.offset(10);
    }];
    
    _arriveImage = [UIImageView new];
    [self.contentView addSubview:_arriveImage];
    [_arriveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_top.mas_bottom);
        make.width.height.offset(10);
        make.left.offset(10);
    }];
    
    _bottom = [UILabel new];
    _bottom.backgroundColor = colorWithLine;
    [self.contentView addSubview:_bottom];
    [_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_arriveImage.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(1);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    _addressLabel = [UILabel new];
    _addressLabel.textColor = colorWithDeepGray;
    _addressLabel.numberOfLines = 0;
    _addressLabel.font =[UIFont systemFontOfSize:YGFontSizeSmallTwo];
    [self.contentView addSubview:_addressLabel];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_arriveImage.mas_right).offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.mas_equalTo(_arriveImage.mas_top).offset(-5);
    }];
    
    _timeLable = [UILabel new];
    _timeLable.numberOfLines = 0;
    _timeLable.textColor = colorWithDeepGray;
    _timeLable.font =[UIFont systemFontOfSize:YGFontSizeSmallTwo];
    [self.contentView addSubview:_timeLable];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_arriveImage.mas_right).offset(LDHPadding);
        make.right.offset(-LDHPadding);
        make.top.mas_equalTo(_addressLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(self.contentView).offset(-LDHPadding);
    }];
}
@end



