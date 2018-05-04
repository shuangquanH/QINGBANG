//
//  RSCrowFundingSubscribeTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RSCrowFundingSubscribeTableViewCell.h"

@implementation RSCrowFundingSubscribeTableViewCell
{
    UIView              *_baseView;
    UILabel             *_titleLabel;
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
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews
{
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 20)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_baseView];
    
    UIView *sectionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    sectionlineView.backgroundColor = colorWithLine;
    [_baseView addSubview:sectionlineView];
    
    UILabel *leaderLabel = [[UILabel alloc] init];
    leaderLabel.textColor = colorWithDeepGray;
    leaderLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    leaderLabel.text = @"您将获得:";
    leaderLabel.frame = CGRectMake(10, 10, YGScreenWidth-20, 25);
    [_baseView addSubview:leaderLabel];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, YGScreenWidth-20, 20)];
    _titleLabel.textColor = colorWithDeepGray;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = @"有个技术工厂 有个技术工厂 有个技术工厂有个技术工厂有个技术工厂有个技术工厂有个技术工厂 有个技术工厂 有个技术工厂有个技术工厂有个技术工厂有个技术工厂有个技术工厂 有个技术工厂 有个技术工厂有个技术工厂有个技术工厂有个技术工厂有个技术工厂 有个技术工厂 有个技术工厂有个技术工厂有个技术工厂有个技术工厂有个技术工厂 有个技术工厂 有个技术工厂有个技术工厂有个技术工厂有个技术工厂";
    [_baseView addSubview:_titleLabel];
}

- (void)setModel:(RSCorwFundingSubscribeModel *)model
{
    _model = model;
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_model.describes];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_model.describes length])];
    NSDictionary *attribute =@{NSFontAttributeName:_titleLabel.font,NSParagraphStyleAttributeName:paragraphStyle};
    //attributedText设置后之前设置的都失效
     CGSize size = [_model.describes boundingRectWithSize:CGSizeMake(YGScreenWidth -20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _titleLabel.frame = CGRectMake(_titleLabel.x, _titleLabel.y, _titleLabel.width, size.height);
    _titleLabel.attributedText = attributedString;
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _titleLabel.y+_titleLabel.height+15);
}
- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(YGScreenWidth, _baseView.height);
}

@end
