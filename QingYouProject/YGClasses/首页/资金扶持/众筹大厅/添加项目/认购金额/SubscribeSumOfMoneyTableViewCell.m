//
//  SubscribeSumOfMoneyTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SubscribeSumOfMoneyTableViewCell.h"

@implementation SubscribeSumOfMoneyTableViewCell
{
 
    UILabel *_sumLabel;
    UILabel *_partsLabel;
    UILabel *_limitPartsLabel;
    UILabel *_contentLabel;
    UIView *_baseView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
        UILabel *sumTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 35)];
        sumTitleLabel.text = @"数额";
        sumTitleLabel.textAlignment = NSTextAlignmentLeft;
        sumTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        sumTitleLabel.textColor = colorWithDeepGray;
        [_baseView addSubview:sumTitleLabel];
        
        _sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(sumTitleLabel.x+sumTitleLabel.width,0 , YGScreenWidth-sumTitleLabel.x-sumTitleLabel.width-20, sumTitleLabel.height)];
        _sumLabel.text = @"25000";
        _sumLabel.textAlignment = NSTextAlignmentLeft;
        _sumLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _sumLabel.textColor = colorWithBlack;
        [_baseView addSubview:_sumLabel];
        
        UILabel *partsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sumTitleLabel.x,sumTitleLabel.y+sumTitleLabel.height , sumTitleLabel.width, sumTitleLabel.height)];
        partsTitleLabel.text = @"份数";
        partsTitleLabel.textAlignment = NSTextAlignmentLeft;
        partsTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        partsTitleLabel.textColor = colorWithDeepGray;
        [_baseView addSubview:partsTitleLabel];
        
        _partsLabel = [[UILabel alloc] initWithFrame:CGRectMake(sumTitleLabel.x+sumTitleLabel.width,partsTitleLabel.y , _sumLabel.width, sumTitleLabel.height)];
        _partsLabel.text = @"100";
        _partsLabel.textAlignment = NSTextAlignmentLeft;
        _partsLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _partsLabel.textColor = colorWithBlack;
        [_baseView addSubview:_partsLabel];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,partsTitleLabel.y+partsTitleLabel.height , sumTitleLabel.width, sumTitleLabel.height)];
        nameLabel.text = @"限购量";
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        nameLabel.textColor = colorWithDeepGray;
        [_baseView addSubview:nameLabel];
        
        _limitPartsLabel = [[UILabel alloc] initWithFrame:CGRectMake(sumTitleLabel.x+sumTitleLabel.width ,nameLabel.y, _sumLabel.width, sumTitleLabel.height)];
        _limitPartsLabel.text = @"5";
        _limitPartsLabel.textAlignment = NSTextAlignmentLeft;
        _limitPartsLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _limitPartsLabel.textColor = colorWithBlack;
        [_baseView addSubview:_limitPartsLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,nameLabel.y+nameLabel.height , YGScreenWidth-20, 45)];
        _contentLabel.text = @"描述";
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _contentLabel.textColor = colorWithBlack;
        _contentLabel.numberOfLines = 0;
        [_baseView addSubview:_contentLabel];
        
        
    }
    return self;
}
- (void)setModel:(SubscribeSumOfMoneyModel *)model
{
    _model = model;
    _sumLabel.text =_model.amount;
    _partsLabel.text = _model.copies;
    _limitPartsLabel.text = _model.forPurchasing;
    _contentLabel.text = _model.describe;
    [_contentLabel sizeToFit];
    _contentLabel.frame = CGRectMake(_contentLabel.x, _contentLabel.y, _contentLabel.width, _contentLabel.height);
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _contentLabel.y+_contentLabel.height+10);
}

- (CGSize)sizeThatFits:(CGSize)size
{
   return  CGSizeMake(YGScreenWidth, _baseView.height);
}
@end
