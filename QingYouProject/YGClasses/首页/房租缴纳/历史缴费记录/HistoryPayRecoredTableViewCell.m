//
//  HistoryPayRecoredTableViewCell.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "HistoryPayRecoredTableViewCell.h"

@implementation HistoryPayRecoredTableViewCell
{
    UILabel *_weekdaysNameLabel;
    UILabel *_daysNameLabel;
    UILabel *_moneyLabel;
    UILabel *_typeAndHostLabel;
    UIButton *_selectButton;
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
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews
{
    //热门推荐label
    _weekdaysNameLabel = [[UILabel alloc]init];
    _weekdaysNameLabel.textColor = colorWithDeepGray;
    _weekdaysNameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _weekdaysNameLabel.text = @"周六";
    _weekdaysNameLabel.frame = CGRectMake(10, 10,60, 20);
    [self.contentView addSubview:_weekdaysNameLabel];
    
    //热门推荐label
    _daysNameLabel = [[UILabel alloc]init];
    _daysNameLabel.textColor = colorWithDeepGray;
    _daysNameLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _daysNameLabel.text = @"08-29";
    _daysNameLabel.frame = CGRectMake(10, _weekdaysNameLabel.y+_weekdaysNameLabel.height,120, 20);
    [self.contentView addSubview:_daysNameLabel];


    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = CGRectMake(YGScreenWidth, 10, 0,0);
    [_selectButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"choice_btn_green"] forState:UIControlStateSelected];
    _selectButton.imageView.contentMode = UIViewContentModeCenter;
    [_selectButton addTarget:self action:@selector(selectItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectButton];
    _selectButton.selected = YES;
    //热门推荐label
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.textColor = colorWithBlack;
    _moneyLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _moneyLabel.text = @"-300.00";
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_moneyLabel];

    
    if ([self.reuseIdentifier isEqualToString:@"AskForInvoiceViewController"]) {
        _selectButton.frame = CGRectMake(YGScreenWidth-50, 10, 40, 40);
        _selectButton.selected = NO;
        _moneyLabel.textColor = colorWithOrangeColor;

    }
 
    _moneyLabel.frame = CGRectMake(130, 10,YGScreenWidth-_selectButton.width-10-130, 20);
    
    //热门推荐label
    _typeAndHostLabel = [[UILabel alloc]init];
    _typeAndHostLabel.textColor = colorWithBlack;
    _typeAndHostLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _typeAndHostLabel.text = @"电费-青网科技园";
    _typeAndHostLabel.textAlignment = NSTextAlignmentRight;
    _typeAndHostLabel.frame = CGRectMake(130, _moneyLabel.y+_moneyLabel.height,YGScreenWidth-_selectButton.width-10-130, 20);
    [self.contentView addSubview:_typeAndHostLabel];

//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, YGScreenWidth-10, 1)];
//    lineView.backgroundColor = colorWithLine;
//    [self.contentView addSubview:lineView];
    
    

}
- (void)setModel:(HistoryPayRecordModel *)model withIndexPath:(NSIndexPath *)indexPath
{
    _model = model;
    _indexPath = indexPath;
    _weekdaysNameLabel.text = _model.week;
    _daysNameLabel.text = _model.time;
    _moneyLabel.text = [NSString stringWithFormat:@"%@",_model.money];
    if ([_cellType isEqualToString:@"cell"]) {
        _moneyLabel.text = [NSString stringWithFormat:@"-%@",_model.money];
    }
    NSString *typeString = [_model.type isEqualToString:@"1"]?@"房租":([_model.type isEqualToString:@"2"]?@"水费":@"电费");
    _typeAndHostLabel.text = [NSString stringWithFormat:@"%@",typeString];
    _selectButton.selected = _model.isSelect;
    
}

- (void)selectItemButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.delegate selectButtonClickWithIndexPath:_indexPath];
}
@end
