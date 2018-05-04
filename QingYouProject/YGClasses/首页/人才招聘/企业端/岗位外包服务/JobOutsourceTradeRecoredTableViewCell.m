//
//  JobOutsourceTradeRecoredTableViewCell.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "JobOutsourceTradeRecoredTableViewCell.h"

@implementation JobOutsourceTradeRecoredTableViewCell
{
    UILabel *_titleLabel; //标题
    UILabel *_createDate; //创建时间
    UILabel *_nameAndPhoneLabel; //姓名电话

    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setModel:(JobOutSourceRecoredModel *)model
{
    _model = model;
    _createDate.text =[NSString stringWithFormat:@"创建时间：%@",_model.createDate] ;
    NSString *string=[_model.phone stringByReplacingOccurrencesOfString:[_model.phone substringWithRange:NSMakeRange(3,4)]withString:@"****"];
    _nameAndPhoneLabel.text = [NSString stringWithFormat:@"%@  %@",_model.contract,string];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = colorWithTable;
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, YGScreenWidth, 98)];
        baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:baseView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
        _titleLabel.text = @"岗位外包服务";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _titleLabel.textColor = colorWithBlack;
        [baseView addSubview:_titleLabel];
        
        _createDate = [[UILabel alloc] initWithFrame:CGRectMake(10,_titleLabel.height+_titleLabel.y+5 , YGScreenWidth-20, 20)];
        _createDate.text = @"创建时间：2017-9-13 13：54";
        _createDate.textAlignment = NSTextAlignmentLeft;
        _createDate.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _createDate.textColor = colorWithDeepGray;
        [baseView addSubview:_createDate];
        
        
        _nameAndPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_createDate.y+_createDate.height+5 , YGScreenWidth-20, 20)];
        _nameAndPhoneLabel.text = @"3000-5000元/月";
        _nameAndPhoneLabel.textAlignment = NSTextAlignmentLeft;
        _nameAndPhoneLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _nameAndPhoneLabel.textColor = colorWithDeepGray;
        [baseView addSubview:_nameAndPhoneLabel];
        
        }
    return self;
}

@end
