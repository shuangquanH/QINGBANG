//
//  InvoiceHistoryTableViewCell.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "InvoiceHistoryTableViewCell.h"

@implementation InvoiceHistoryTableViewCell
{
    UILabel *_createDateLabel;
    UILabel *_priceLabel;
    UILabel *_statusLabel;
    UILabel *_AcceptWayLabel;
    UILabel *_AcceptWayTitleLabel;
    UILabel *_statusTitleLabel;
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

- (void)setModle:(InvoiceHistoryModel *)modle
{
    _modle = modle;
    _createDateLabel.text = _modle.content;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_modle.money];
    _statusLabel.text = _modle.state;
    if ([_modle.status isEqualToString:@"2"])
    {
        _AcceptWayLabel.hidden = YES;
        _AcceptWayTitleLabel.hidden = YES;
        _AcceptWayTitleLabel.y = YES;
        _statusTitleLabel.frame = CGRectMake(10,_priceLabel.y+_priceLabel.height , 40, 25);
        _statusLabel.y = _statusTitleLabel.y;
        _baseView.frame = CGRectMake(0,0, YGScreenWidth, 80);
    }else
    {
        _AcceptWayLabel.text  = [NSString stringWithFormat:@"发送到邮箱"];
        _statusLabel.text = _modle.state;
//        [_modle.type isEqualToString:@"1"]?@"已发送":@"未发送";
        _baseView.frame = CGRectMake(0,0, YGScreenWidth, 110);

    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = colorWithTable;
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, 110)];
    _baseView.backgroundColor = colorWithYGWhite;
    [self.contentView addSubview:_baseView];
    
    UILabel *createdateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5 , 75, 25)];
    createdateTitleLabel.text = @"发生时间:";
    createdateTitleLabel.textAlignment = NSTextAlignmentLeft;
    createdateTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    createdateTitleLabel.textColor = colorWithDeepGray;
    [_baseView addSubview:createdateTitleLabel];

    _createDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(createdateTitleLabel.x+createdateTitleLabel.width, createdateTitleLabel.y, YGScreenWidth-(createdateTitleLabel.x+createdateTitleLabel.width+10)-20, createdateTitleLabel.height)];
    _createDateLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _createDateLabel.textColor = colorWithBlack;
    [_baseView addSubview:_createDateLabel];
    _createDateLabel.text = @"";

    
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,createdateTitleLabel.y+createdateTitleLabel.height , 75, 25)];
    priceTitleLabel.text = @"发票金额:";
    priceTitleLabel.textAlignment = NSTextAlignmentLeft;
    priceTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    priceTitleLabel.textColor = colorWithDeepGray;
    [_baseView addSubview:priceTitleLabel];

    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_createDateLabel.x, priceTitleLabel.y, YGScreenWidth-(priceTitleLabel.x+priceTitleLabel.width+10)-20, priceTitleLabel.height)];
    _priceLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _priceLabel.textColor = colorWithMainColor;
    [_baseView addSubview:_priceLabel];
    _priceLabel.text = @"";

    _AcceptWayTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, priceTitleLabel.y+priceTitleLabel.height, 75, priceTitleLabel.height)];
    _AcceptWayTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _AcceptWayTitleLabel.textColor = colorWithDeepGray;
    [_baseView addSubview:_AcceptWayTitleLabel];
    _AcceptWayTitleLabel.text = @"收取方式:";

    _AcceptWayLabel = [[UILabel alloc] initWithFrame:CGRectMake(_AcceptWayTitleLabel.x+_AcceptWayTitleLabel.width, priceTitleLabel.y+priceTitleLabel.height, YGScreenWidth-(_AcceptWayTitleLabel.x+_AcceptWayTitleLabel.width+10)-20, priceTitleLabel.height)];
    _AcceptWayLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _AcceptWayLabel.textColor = colorWithBlack;
    [_baseView addSubview:_AcceptWayLabel];
    _AcceptWayLabel.text = @"收取方式:";
    
    _statusTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_AcceptWayLabel.y+_AcceptWayLabel.height , 40, 25)];
    _statusTitleLabel.text = @"状态:";
    _statusTitleLabel.textAlignment = NSTextAlignmentLeft;
    _statusTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _statusTitleLabel.textColor = colorWithDeepGray;
    [_baseView addSubview:_statusTitleLabel];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, _statusTitleLabel.y, YGScreenWidth-(_statusTitleLabel.x+_statusTitleLabel.width+10)-20, _statusTitleLabel.height)];
    _statusLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _statusLabel.textColor = colorWithBlack;
    [_baseView addSubview:_statusLabel];
    _statusLabel.text = @"";

    
    
}
@end
